USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [transform].[DimService]
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
    WITH meterDailyConsumptionAndReadDate
        AS (SELECT utl_meter.site_id,
                   SUM (utl_meter.est_daily_consumption) AS est_daily_consumption,
                   MIN (CASE
                        WHEN NULLIF(utl_meter.next_sched_read_date,'9999-12-31') < GETDATE () THEN NULL
                            ELSE NULLIF(utl_meter.next_sched_read_date,'9999-12-31')
                        END) AS NextScheduledReadDate,
                   MAX (CASE
                        WHEN utl_meter.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID THEN 1
                            ELSE 0
                        END) AS Meta_HasChanged
              FROM DW_Staging.orion.utl_meter
              GROUP BY utl_meter.site_id) ,
    meterHeaderNextScheduledReadDate
        AS (SELECT utl_meter_header.site_id,
                   MIN (CASE
                        WHEN NULLIF(utl_meter_header.next_sched_read_date,'9999-12-31') < GETDATE () THEN NULL
                            ELSE NULLIF(utl_meter_header.next_sched_read_date,'9999-12-31')
                        END) AS NextScheduledReadDate,
                   MAX (CASE
                        WHEN utl_meter_header.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID THEN 1
                            ELSE 0
                        END) AS Meta_HasChanged
              FROM DW_Staging.orion.utl_meter_header
              GROUP BY utl_meter_header.site_id) ,
		    siteFRMPStartDate
		    AS (SELECT utl_account_frmp_history.site_id,
       MAX (utl_account_frmp_history.frmp_date) AS FRMPDate,
       MAX (CASE
            WHEN utl_account_frmp_history.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID THEN 1
                ELSE 0
            END) AS Meta_HasChanged
  FROM DW_Staging.orion.utl_account_frmp_history
  WHERE utl_account_frmp_history.move_in = 'Y'
  GROUP BY utl_account_frmp_history.site_id)
        INSERT INTO temp.DimService (
        DimService.ServiceKey,
        DimService.MarketIdentifier,
        DimService.ServiceType,
        DimService.LossFactor,
        DimService.EstimatedDailyConsumption,
        DimService.MeteringType,
        DimService.ResidentialSuburb,
        DimService.ResidentialPostcode,
        DimService.ResidentialState,
        DimService.NextScheduledReadDate,
	   DimService.FRMPDate) 
        SELECT
        CAST ( utl_site.site_id AS int) ,
        CAST ( utl_site.site_identifier AS nvarchar (30)) ,
        CAST (CASE utl_site.seq_product_type_id
              WHEN '1' THEN 'Internet'
              WHEN '2' THEN 'Electricity'
              WHEN '3' THEN 'Gas'
              WHEN '7' THEN 'Telco'
                  ELSE NULL
              END AS nvarchar (11)) ,
        COALESCE (utl_distrib_loss_factor_sched.dlf_factor, 1.0) ,
        COALESCE ( _meterDailyConsumptionAndReadDate.est_daily_consumption, 0.0) ,
        CAST (CASE utl_site.metering_type
              WHEN 'DEEMED' THEN 'Deemed'
                  ELSE utl_site.metering_type
              END AS nchar (6)) ,
        CAST (UPPER ( utl_site.addr_suburb) AS nvarchar (100)) ,
        CAST ( utl_site.addr_postcode AS nchar (4)) ,
        CAST ( utl_site.addr_city AS nchar (3)) ,
        CASE utl_site.seq_product_type_id
        WHEN '2' THEN _meterHeaderNextScheduledReadDate.NextScheduledReadDate
        WHEN '3' THEN _meterDailyConsumptionAndReadDate.NextScheduledReadDate
            ELSE NULL
        END,
	   _siteFRMPStartDate.FRMPDate
          FROM
               DW_Staging.orion.utl_site LEFT JOIN DW_Staging.orion.utl_distrib_loss_factor_sched
               ON utl_distrib_loss_factor_sched.dlf_id = utl_site.dlf_id
                                         LEFT JOIN meterDailyConsumptionAndReadDate AS _meterDailyConsumptionAndReadDate
               ON _meterDailyConsumptionAndReadDate.site_id = utl_site.site_id
                                         LEFT JOIN meterHeaderNextScheduledReadDate AS _meterHeaderNextScheduledReadDate
               ON _meterHeaderNextScheduledReadDate.site_id = utl_site.site_id
			                          LEFT JOIN siteFRMPStartDate AS _siteFRMPStartDate
               ON _siteFRMPStartDate.site_id = utl_site.site_id
          WHERE ISNULL (utl_distrib_loss_factor_sched.start_date, '1900-01-01') < GETDATE () 
            AND ISNULL (utl_distrib_loss_factor_sched.end_date, '9999-12-31') > GETDATE () 
            AND (utl_site.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
              OR utl_distrib_loss_factor_sched.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
              OR _meterDailyConsumptionAndReadDate.Meta_HasChanged = 1
              OR _meterHeaderNextScheduledReadDate.Meta_HasChanged = 1
		    OR _siteFRMPStartDate.Meta_HasChanged = 1);

    SELECT 0 AS ExtractRowCount,
           @@ROWCOUNT AS InsertRowCount,
           0 AS UpdateRowCount,
           0 AS DeleteRowCount,
           0 AS ErrorRowCount;

END;


GO
