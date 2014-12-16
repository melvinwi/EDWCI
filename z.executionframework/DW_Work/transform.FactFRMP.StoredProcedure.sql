USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [transform].[FactFRMP]
@TaskExecutionInstanceID int
,
@LatestSuccessfulTaskExecutionInstanceID int
AS
BEGIN

    --Get LatestSuccessfulTaskExecutionInstanceID
    IF  @LatestSuccessfulTaskExecutionInstanceID IS NULL
        BEGIN
            EXEC DW_Utility.config.GetLatestSuccessfulTaskExecutionInstanceID
            @TaskExecutionInstanceID = @TaskExecutionInstanceID
            , @LatestSuccessfulTaskExecutionInstanceID = @LatestSuccessfulTaskExecutionInstanceID OUTPUT;
        END;
    --/

    --Drop and create temporary table
    IF OBJECT_ID (N'tempdb..#FRMPHistory') IS NOT NULL
        BEGIN
            DROP TABLE #FRMPHistory;
        END;

    CREATE TABLE #FRMPHistory
    (   accnt_frmp_id_mi    numeric (18, 0) NULL,
        accnt_frmp_id_mo    numeric (18, 0) NULL,
        switch_in_id        varchar (100) COLLATE DATABASE_DEFAULT
                                          NULL,
        switch_out_id       varchar (100) COLLATE DATABASE_DEFAULT
                                          NULL,
        frmp_start          datetime       NULL,
        frmp_end            datetime       NULL,
        date_processed_mi   datetime       NULL,
        date_processed_mo   datetime       NULL,
        site_id             numeric (18, 0) NULL) ;

    -- Insert all FRMP starts
    INSERT INTO #FRMPHistory
    (   accnt_frmp_id_mi,
        switch_in_id,
        frmp_start,
        frmp_end,
        date_processed_mi,
        site_id) 
    SELECT utl_account_frmp_history.accnt_frmp_id,
           nem_transaction.nem_trans_id,
           utl_account_frmp_history.frmp_date,
           '9999-12-31',
           utl_account_frmp_history.insert_datetime,
           utl_account_frmp_history.site_id
      FROM
           DW_Staging.orion.utl_account_frmp_history JOIN DW_Staging.orion.nem_transaction
           ON utl_account_frmp_history.trans_id = nem_transaction.trans_id
      WHERE utl_account_frmp_history.move_in = 'Y';
    
    -- Update with FRMP ends
    UPDATE #FRMPHistory
    SET accnt_frmp_id_mo = utl_account_frmp_history.accnt_frmp_id,
        switch_out_id = nem_transaction.nem_trans_id,
        frmp_end = utl_account_frmp_history.frmp_date,
        date_processed_mo = utl_account_frmp_history.insert_datetime
      FROM #FRMPHistory JOIN DW_Staging.orion.utl_account_frmp_history
           ON #FRMPHistory.site_id = utl_account_frmp_history.site_id
          AND utl_account_frmp_history.move_in = 'N'
          AND DATEDIFF (dd, #FRMPHistory.frmp_start, utl_account_frmp_history.frmp_date) >= 0
          AND DATEDIFF (dd, #FRMPHistory.date_processed_mi, utl_account_frmp_history.insert_datetime) >= 0
                        JOIN DW_Staging.orion.nem_transaction
           ON utl_account_frmp_history.trans_id = nem_transaction.trans_id
                        LEFT JOIN
      DW_Staging.orion.utl_account_frmp_history AS utl_account_frmp_history2
           ON utl_account_frmp_history.site_id = utl_account_frmp_history2.site_id
          AND utl_account_frmp_history2.move_in = 'N'
          AND DATEDIFF (dd, #FRMPHistory.frmp_start, utl_account_frmp_history2.frmp_date) >= 0
          AND DATEDIFF (dd, #FRMPHistory.date_processed_mi, utl_account_frmp_history2.insert_datetime) >= 0
          AND DATEDIFF (dd, utl_account_frmp_history.frmp_date, utl_account_frmp_history2.frmp_date) < 0
      WHERE utl_account_frmp_history2.accnt_frmp_id IS NULL;
    
    -- Fix #1: Set an end date on closed sites with no FRMP end
    UPDATE #FRMPHistory
    SET frmp_end = tmp.MaxFRMPDate
      FROM #FRMPHistory INNER JOIN (SELECT  nc_product_item.site_id,
                                            CONVERT (nchar (8) , COALESCE ( MAX (nc_product_item.date_terminated) , MAX (nc_product_item.accnt_status_date) , '9999-12-31') , 112) AS MaxFRMPDate
                                      FROM
                                           DW_Staging.orion.nc_product_item LEFT OUTER JOIN DW_Staging.orion.utl_account_status
                                           ON utl_account_status.accnt_status_id = nc_product_item.accnt_status_id
                                      GROUP BY nc_product_item.site_id
                                      HAVING MAX (utl_account_status.accnt_status_class_id) = 1) AS tmp
           ON tmp.site_id = #FRMPHistory.site_id
      WHERE #FRMPHistory.frmp_end = '9999-12-31';

    -- Fix #2: Remove the end date on open sites with an end date set
    UPDATE #FRMPHistory
    SET frmp_end = '9999-12-31'
      FROM #FRMPHistory INNER JOIN (SELECT nc_product_item.site_id,
                                           MAX (#FRMPHistory.frmp_start) AS MaxFRMPStart
                                      FROM
                                           DW_Staging.orion.nc_product_item LEFT OUTER JOIN DW_Staging.orion.utl_account_status
                                           ON utl_account_status.accnt_status_id = nc_product_item.accnt_status_id
                                                                            INNER JOIN #FRMPHistory
                                           ON nc_product_item.site_id = #FRMPHistory.site_id
                                      WHERE utl_account_status.accnt_status_class_id = 2
                                      GROUP BY nc_product_item.site_id) AS tmp
           ON tmp.site_id = #FRMPHistory.site_id
          AND tmp.MaxFRMPStart = #FRMPHistory.frmp_start
      WHERE #FRMPHistory.frmp_end <> '9999-12-31';

	 -- Fix #3: Insert a record for sites with no entry that should have a FRMP date
	   INSERT INTO #FRMPHistory
	   (   frmp_start,
		  frmp_end,
		  site_id) 
	   SELECT COALESCE (tmp.MinFRMPDate, tmp.MinDateConnected) ,
			'9999-12-31',
			tmp.site_id
		FROM
			(
			 SELECT nc_product_item.site_id,
				   MIN (nc_product_item.date_connected) AS MinDateConnected,
				   MIN (nc_product_item.frmp_date) AS MinFRMPDate
			   FROM
				   DW_Staging.orion.nc_product_item LEFT OUTER JOIN DW_Staging.orion.utl_account_status
				   ON utl_account_status.accnt_status_id = nc_product_item.accnt_status_id
			   WHERE utl_account_status.accnt_status_class_id = 2
			   GROUP BY nc_product_item.site_id) AS tmp LEFT OUTER JOIN #FRMPHistory
			ON tmp.site_id = #FRMPHistory.site_id
		WHERE #FRMPHistory.site_id IS NULL;


    -- Join & insert
    INSERT INTO temp.FactFRMP (
    FactFRMP.ServiceId,
    FactFRMP.FRMPStartDateId,
    FactFRMP.FRMPEndDateId) 
    SELECT
    _DimService.ServiceId,
    CONVERT (nchar (8) , #FRMPHistory.frmp_start, 112) ,
    CONVERT (nchar (8) , #FRMPHistory.frmp_end, 112) 
      FROM
           #FRMPHistory INNER JOIN DW_Dimensional.DW.DimService AS _DimService
           ON _DimService.ServiceKey = CAST (#FRMPHistory.site_id AS int) 
          AND _DimService.Meta_IsCurrent = 1;

    SELECT 0 AS ExtractRowCount,
           @@ROWCOUNT AS InsertRowCount,
           0 AS UpdateRowCount,
           0 AS DeleteRowCount,
           0 AS ErrorRowCount;

END;


GO
