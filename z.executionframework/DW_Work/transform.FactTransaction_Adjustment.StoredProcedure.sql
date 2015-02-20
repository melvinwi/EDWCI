USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [transform].[FactTransaction_Adjustment]
    @TaskExecutionInstanceID INT
  , @LatestSuccessfulTaskExecutionInstanceID INT
AS
BEGIN

    --Get LatestSuccessfulTaskExecutionInstanceID
    IF  @LatestSuccessfulTaskExecutionInstanceID IS NULL
      BEGIN
        EXEC DW_Utility.config.GetLatestSuccessfulTaskExecutionInstanceID
            @TaskExecutionInstanceID = @TaskExecutionInstanceID
          , @LatestSuccessfulTaskExecutionInstanceID  = @LatestSuccessfulTaskExecutionInstanceID OUTPUT
      END
    --/

    --Drop and create temporary table
    IF OBJECT_ID(N'tempdb..#FactTransaction') IS NOT NULL 
		BEGIN 
			DROP TABLE #FactTransaction 
		END
		
    CREATE TABLE #FactTransaction
        (    AccountId           INT             NULL
	      , ServiceId           INT             NULL
	      , ProductId           INT             NULL
	      , FinancialAccountId  INT             NULL
	      , TransactionDateId   INT             NULL
	      , VersionId           INT             NULL
	      , UnitTypeId          INT             NULL
	      , Units               DECIMAL(18, 4)  NULL
	      , Value               MONEY           NULL
	      , Currency            NCHAR(3)        NULL
	      , Tax                 MONEY           NULL
	      , TransactionType     NVARCHAR(100)   NULL
	      , TransactionDesc     NVARCHAR(100)   NULL
	      , TransactionKey      NVARCHAR(20)    NULL
		 , MeterRegisterId     INT             NULL
		 , TransactionSubtype  NVARCHAR(30)    NULL
		 , Reversal		   NCHAR(3)	    NULL
		 , Reversed		   NCHAR(3)	    NULL
		 , StartRead		   DECIMAL(18,4)   NULL
		 , EndRead		   DECIMAL(18,4)   NULL
		 , StartDateId		   INT		    NULL
		 , EndDateId		   INT		    NULL
	      ) ;
    --/

    --Insert into temporary table
	  ;WITH maxRate AS (SELECT ar_adjust.seq_ar_adjust_id, MAX(nc_tax_rate_history.tax_rate_history_id) AS tax_rate_history_id, MAX(nc_tax_rate_history.Meta_LatestUpdate_TaskExecutionInstanceId) AS Meta_LatestUpdate_TaskExecutionInstanceId FROM DW_Staging.orion.ar_adjust CROSS JOIN DW_Staging.orion.nc_tax_rate_history WHERE ar_adjust.posted_date BETWEEN nc_tax_rate_history.start_date AND COALESCE(nc_tax_rate_history.end_date, '9999-12-31') GROUP BY ar_adjust.seq_ar_adjust_id, ar_adjust.posted_date
    ), taxRate AS (SELECT maxRate.seq_ar_adjust_id, maxRate.Meta_LatestUpdate_TaskExecutionInstanceId, nc_tax_rate_history.tax_rate FROM maxRate INNER JOIN DW_Staging.orion.nc_tax_rate_history ON nc_tax_rate_history.tax_rate_history_id = maxRate.tax_rate_history_id
    )
	  INSERT INTO #FactTransaction 
                  ( AccountId
		              , ServiceId
		              , ProductId
		              , FinancialAccountId
		              , TransactionDateId
		              , VersionId
		              , UnitTypeId
		              , Units
		              , Value
		              , Currency
		              , Tax
				    , TransactionType
		              , TransactionDesc
		              , TransactionKey
				    , MeterRegisterId
				    , TransactionSubtype
				    , Reversal		 
				    , Reversed		 
				    , StartRead		 
				    , EndRead		 
				    , StartDateId		 
				    , EndDateId		 
                  )
	  SELECT
		_DimAccount.AccountId,
		/* ar_adjust.seq_ar_adjust_id */ -1,
		/* ar_adjust.seq_ar_adjust_id */ -1,
		COALESCE( _DimFinancialAccount.FinancialAccountId , -1),
		CONVERT(NCHAR(8), COALESCE( ar_adjust.adj_date , '9999-12-31'), 112),
		COALESCE( _DimVersion.VersionId , -1),
		/* ar_adjust.seq_ar_adjust_id */ -1,
		/* ar_adjust.seq_ar_adjust_id */ 0,
		ar_adjust_reason.cust_tran_multiplier * CASE WHEN COALESCE(ar_adjust_reason.gst_inclusive, 'N') = 'Y' THEN ar_adjust.adj_amount / (1 + COALESCE(_taxRate.tax_rate, 0)) ELSE ar_adjust.adj_amount END,
		/* ar_adjust.seq_ar_adjust_id */ N'AUD',
		ar_adjust_reason.cust_tran_multiplier * CASE WHEN COALESCE(ar_adjust_reason.gst_inclusive, 'N') = 'Y' THEN ar_adjust.adj_amount * COALESCE(_taxRate.tax_rate, 0) / (1 + COALESCE(_taxRate.tax_rate, 0)) ELSE 0 END,
		N'Adjustments',
		ar_adjust_reason.adj_statement_desc,
		/* ar_adjust.seq_ar_adjust_id */ N'ADJ' + CAST(ar_adjust.seq_ar_adjust_id AS NVARCHAR(11)),
		-1,
		N'Adjustments',
		CASE WHEN ar_adjust_reason.adj_desc LIKE '%REVERSAL%' THEN N'Yes' ELSE 'No ' END,
		N'No ',
		0,
		0,
		99991231,
		99991231
	  FROM DW_Staging.orion.ar_adjust 
	  INNER JOIN DW_Staging.orion.ar_adjust_reason ON ar_adjust_reason.seq_adj_reason_id = ar_adjust.seq_adj_reason_id 
	  INNER JOIN DW_Staging.orion.nc_client ON nc_client.seq_party_id = ar_adjust.seq_party_id 
	  INNER JOIN DW_Staging.orion.crm_element_hierarchy ON crm_element_hierarchy.element_id = nc_client.seq_party_id AND crm_element_hierarchy.element_struct_code = 'CLIENT' 
	  INNER JOIN DW_Staging.orion.crm_party_type ON crm_party_type.seq_party_type_id = crm_element_hierarchy.seq_element_type_id AND crm_party_type.party_type <> 'SUBCLIENT' 
	  LEFT JOIN taxRate AS _taxRate ON _taxRate.seq_ar_adjust_id = ar_adjust.seq_ar_adjust_id 
	  INNER JOIN DW_Dimensional.DW.DimAccount AS _DimAccount ON _DimAccount.AccountKey = nc_client.seq_party_id AND _DimAccount.Meta_IsCurrent = 1 
	  LEFT JOIN DW_Dimensional.DW.DimFinancialAccount AS _DimFinancialAccount ON _DimFinancialAccount.FinancialAccountKey = ar_adjust_reason.seq_account_id AND _DimFinancialAccount.Meta_IsCurrent = 1 LEFT JOIN DW_Dimensional.DW.DimVersion AS _DimVersion ON _DimVersion.VersionKey = 'Actual' 
	  WHERE ar_adjust.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR ar_adjust_reason.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _taxRate.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;
    --/
	
	  --Insert into main table
	  INSERT INTO temp.FactTransaction 
                      (			 AccountId
				              , ServiceId
				              , ProductId
				              , FinancialAccountId
				              , TransactionDateId
				              , VersionId
				              , UnitTypeId
				              , Units
				              , Value
				              , Currency
				              , Tax
						    , TransactionType
				              , TransactionDesc
				              , TransactionKey
						    , MeterRegisterId
						    , TransactionSubtype
						    , Reversal		 
						    , Reversed		 
						    , StartRead		 
						    , EndRead		 
						    , StartDateId		 
						    , EndDateId		 
                      )
	  SELECT  AccountId
			    , ServiceId
			    , ProductId
			    , FinancialAccountId
			    , TransactionDateId
			    , VersionId
			    , UnitTypeId
			    , Units
			    , Value
			    , Currency
			    , Tax
			    , TransactionType
			    , TransactionDesc
			    , TransactionKey
			    , MeterRegisterId
			    , TransactionSubtype
			    , Reversal		 
			    , Reversed		 
			    , StartRead		 
			    , EndRead		 
			    , StartDateId		 
			    , EndDateId		 
	  FROM    #FactTransaction;
	  --/
    
    --Return row counts
    SELECT  0 AS ExtractRowCount,
            @@ROWCOUNT AS InsertRowCount,
            0 AS UpdateRowCount,
            0 AS DeleteRowCount,
            0 AS ErrorRowCount;
    --/

END;

GO
USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [transform].[FactTransaction_Adjustment]
    @TaskExecutionInstanceID INT
  , @LatestSuccessfulTaskExecutionInstanceID INT
AS
BEGIN

    --Get LatestSuccessfulTaskExecutionInstanceID
    IF  @LatestSuccessfulTaskExecutionInstanceID IS NULL
      BEGIN
        EXEC DW_Utility.config.GetLatestSuccessfulTaskExecutionInstanceID
            @TaskExecutionInstanceID = @TaskExecutionInstanceID
          , @LatestSuccessfulTaskExecutionInstanceID  = @LatestSuccessfulTaskExecutionInstanceID OUTPUT
      END
    --/

    --Drop and create temporary table
    IF OBJECT_ID(N'tempdb..#FactTransaction') IS NOT NULL 
		BEGIN 
			DROP TABLE #FactTransaction 
		END
		
    CREATE TABLE #FactTransaction
        (    AccountId           INT             NULL
	      , ServiceId           INT             NULL
	      , ProductId           INT             NULL
	      , FinancialAccountId  INT             NULL
	      , TransactionDateId   INT             NULL
	      , VersionId           INT             NULL
	      , UnitTypeId          INT             NULL
	      , Units               DECIMAL(18, 4)  NULL
	      , Value               MONEY           NULL
	      , Currency            NCHAR(3)        NULL
	      , Tax                 MONEY           NULL
	      , TransactionType     NVARCHAR(100)   NULL
	      , TransactionDesc     NVARCHAR(100)   NULL
	      , TransactionKey      NVARCHAR(20)    NULL
		 , MeterRegisterId     INT             NULL
		 , TransactionSubtype  NVARCHAR(30)    NULL
		 , Reversal		   NCHAR(3)	    NULL
		 , Reversed		   NCHAR(3)	    NULL
		 , StartRead		   DECIMAL(18,4)   NULL
		 , EndRead		   DECIMAL(18,4)   NULL
		 , StartDateId		   INT		    NULL
		 , EndDateId		   INT		    NULL
		 , AccountingPeriod		INT			NULL
	      ) ;
    --/

    --Insert into temporary table
	  ;WITH maxRate AS (SELECT ar_adjust.seq_ar_adjust_id, MAX(nc_tax_rate_history.tax_rate_history_id) AS tax_rate_history_id, MAX(nc_tax_rate_history.Meta_LatestUpdate_TaskExecutionInstanceId) AS Meta_LatestUpdate_TaskExecutionInstanceId FROM DW_Staging.orion.ar_adjust CROSS JOIN DW_Staging.orion.nc_tax_rate_history WHERE ar_adjust.posted_date BETWEEN nc_tax_rate_history.start_date AND COALESCE(nc_tax_rate_history.end_date, '9999-12-31') GROUP BY ar_adjust.seq_ar_adjust_id, ar_adjust.posted_date
    ), taxRate AS (SELECT maxRate.seq_ar_adjust_id, maxRate.Meta_LatestUpdate_TaskExecutionInstanceId, nc_tax_rate_history.tax_rate FROM maxRate INNER JOIN DW_Staging.orion.nc_tax_rate_history ON nc_tax_rate_history.tax_rate_history_id = maxRate.tax_rate_history_id
    )
	  INSERT INTO #FactTransaction 
                  ( AccountId
		              , ServiceId
		              , ProductId
		              , FinancialAccountId
		              , TransactionDateId
		              , VersionId
		              , UnitTypeId
		              , Units
		              , Value
		              , Currency
		              , Tax
				    , TransactionType
		              , TransactionDesc
		              , TransactionKey
				    , MeterRegisterId
				    , TransactionSubtype
				    , Reversal		 
				    , Reversed		 
				    , StartRead		 
				    , EndRead		 
				    , StartDateId		 
				    , EndDateId		 
					, AccountingPeriod
                  )
	  SELECT
		_DimAccount.AccountId,
		/* ar_adjust.seq_ar_adjust_id */ -1,
		/* ar_adjust.seq_ar_adjust_id */ -1,
		COALESCE( _DimFinancialAccount.FinancialAccountId , -1),
		CONVERT(NCHAR(8), COALESCE( ar_adjust.adj_date , '9999-12-31'), 112),
		COALESCE( _DimVersion.VersionId , -1),
		/* ar_adjust.seq_ar_adjust_id */ -1,
		/* ar_adjust.seq_ar_adjust_id */ 0,
		ar_adjust_reason.cust_tran_multiplier * CASE WHEN COALESCE(ar_adjust_reason.gst_inclusive, 'N') = 'Y' THEN ar_adjust.adj_amount / (1 + COALESCE(_taxRate.tax_rate, 0)) ELSE ar_adjust.adj_amount END,
		/* ar_adjust.seq_ar_adjust_id */ N'AUD',
		ar_adjust_reason.cust_tran_multiplier * CASE WHEN COALESCE(ar_adjust_reason.gst_inclusive, 'N') = 'Y' THEN ar_adjust.adj_amount * COALESCE(_taxRate.tax_rate, 0) / (1 + COALESCE(_taxRate.tax_rate, 0)) ELSE 0 END,
		N'Adjustments',
		ar_adjust_reason.adj_statement_desc,
		/* ar_adjust.seq_ar_adjust_id */ N'ADJ' + CAST(ar_adjust.seq_ar_adjust_id AS NVARCHAR(11)),
		-1,
		N'Adjustments',
		CASE WHEN ar_adjust_reason.adj_desc LIKE '%REVERSAL%' THEN N'Yes' ELSE 'No ' END,
		N'No ',
		0,
		0,
		99991231,
		99991231,
		ar_adjust.seq_accounting_period_id
	  FROM DW_Staging.orion.ar_adjust 
	  INNER JOIN DW_Staging.orion.ar_adjust_reason ON ar_adjust_reason.seq_adj_reason_id = ar_adjust.seq_adj_reason_id 
	  INNER JOIN DW_Staging.orion.nc_client ON nc_client.seq_party_id = ar_adjust.seq_party_id 
	  INNER JOIN DW_Staging.orion.crm_element_hierarchy ON crm_element_hierarchy.element_id = nc_client.seq_party_id AND crm_element_hierarchy.element_struct_code = 'CLIENT' 
	  INNER JOIN DW_Staging.orion.crm_party_type ON crm_party_type.seq_party_type_id = crm_element_hierarchy.seq_element_type_id AND crm_party_type.party_type <> 'SUBCLIENT' 
	  LEFT JOIN taxRate AS _taxRate ON _taxRate.seq_ar_adjust_id = ar_adjust.seq_ar_adjust_id 
	  INNER JOIN DW_Dimensional.DW.DimAccount AS _DimAccount ON _DimAccount.AccountKey = nc_client.seq_party_id AND _DimAccount.Meta_IsCurrent = 1 
	  LEFT JOIN DW_Dimensional.DW.DimFinancialAccount AS _DimFinancialAccount ON _DimFinancialAccount.FinancialAccountKey = ar_adjust_reason.seq_account_id AND _DimFinancialAccount.Meta_IsCurrent = 1 LEFT JOIN DW_Dimensional.DW.DimVersion AS _DimVersion ON _DimVersion.VersionKey = 'Actual' 
	  WHERE ar_adjust.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR ar_adjust_reason.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _taxRate.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;
    --/
	
	  --Insert into main table
	  INSERT INTO temp.FactTransaction 
                      (			 AccountId
				              , ServiceId
				              , ProductId
				              , FinancialAccountId
				              , TransactionDateId
				              , VersionId
				              , UnitTypeId
				              , Units
				              , Value
				              , Currency
				              , Tax
						    , TransactionType
				              , TransactionDesc
				              , TransactionKey
						    , MeterRegisterId
						    , TransactionSubtype
						    , Reversal		 
						    , Reversed		 
						    , StartRead		 
						    , EndRead		 
						    , StartDateId		 
						    , EndDateId		 
							, AccountingPeriod
                      )
	  SELECT  AccountId
			    , ServiceId
			    , ProductId
			    , FinancialAccountId
			    , TransactionDateId
			    , VersionId
			    , UnitTypeId
			    , Units
			    , Value
			    , Currency
			    , Tax
			    , TransactionType
			    , TransactionDesc
			    , TransactionKey
			    , MeterRegisterId
			    , TransactionSubtype
			    , Reversal		 
			    , Reversed		 
			    , StartRead		 
			    , EndRead		 
			    , StartDateId		 
			    , EndDateId		 
				, AccountingPeriod
	  FROM    #FactTransaction;
	  --/
    
    --Return row counts
    SELECT  0 AS ExtractRowCount,
            @@ROWCOUNT AS InsertRowCount,
            0 AS UpdateRowCount,
            0 AS DeleteRowCount,
            0 AS ErrorRowCount;
    --/

END;

GO
