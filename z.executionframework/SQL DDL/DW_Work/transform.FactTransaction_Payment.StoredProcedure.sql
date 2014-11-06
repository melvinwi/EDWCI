USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [transform].[FactTransaction_Payment]
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
      END;
    --/

    --Drop and create temporary table
    IF OBJECT_ID(N'tempdb..#FactTransaction') IS NOT NULL 
		BEGIN 
			DROP TABLE #FactTransaction 
		END
		
    CREATE TABLE #FactTransaction
        ( AccountId           INT             NULL
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
	      ) ;
    --/

    --Insert into temporary table
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
                  )
    SELECT
    _DimAccount.AccountId,
    -1,
    -1,
    COALESCE ( _DimFinancialAccount.FinancialAccountId , -1) ,
    CONVERT (nchar (8) , COALESCE ( ar_receipt.rcpt_date , '9999-12-31') , 112) ,
    COALESCE ( _DimVersion.VersionId , -1) ,
    -1,
    0,
    -1 * ar_receipt.rcpt_amount,
    'AUD',
    0,
    'Payments',
    'Payment - ' + ar_receipt_batch_type.rcpt_batch_type_desc,
    'PAY' + CAST (ar_receipt.seq_rcpt_id AS nvarchar (11)) 
      FROM
           DW_Staging.orion.ar_receipt INNER JOIN DW_Staging.orion.ar_receipt_batch
           ON ar_receipt_batch.seq_rcpt_batch_id = ar_receipt.seq_rcpt_batch_id
                                       INNER JOIN DW_Staging.orion.ar_receipt_batch_type
           ON ar_receipt_batch_type.seq_rcpt_batch_type_id = ar_receipt_batch.seq_rcpt_batch_type_id
                                       INNER JOIN DW_Dimensional.DW.DimAccount AS _DimAccount
           ON _DimAccount.AccountKey = ar_receipt.seq_party_id
          AND _DimAccount.Meta_IsCurrent = 1
                                       INNER JOIN DW_Staging.orion.nc_client
           ON nc_client.seq_party_id = ar_receipt.seq_party_id
                                       INNER JOIN DW_Staging.orion.crm_element_hierarchy
           ON crm_element_hierarchy.element_id = nc_client.seq_party_id
          AND crm_element_hierarchy.element_struct_code = 'CLIENT'
                                       INNER JOIN DW_Staging.orion.crm_party_type
           ON crm_party_type.seq_party_type_id = crm_element_hierarchy.seq_element_type_id
          AND crm_party_type.party_type <> 'SUBCLIENT'
                                       LEFT JOIN DW_Dimensional.DW.DimFinancialAccount AS _DimFinancialAccount
           ON _DimFinancialAccount.FinancialAccountKey = 10
          AND _DimFinancialAccount.Meta_IsCurrent = 1
                                       LEFT JOIN DW_Dimensional.DW.DimVersion AS _DimVersion
           ON _DimVersion.VersionKey = 'Actual'
    WHERE ar_receipt.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
    AND ar_receipt.seq_accounting_period_id IS NOT NULL;
    --/
	
	  --Insert into main table
	  INSERT INTO temp.FactTransaction 
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
