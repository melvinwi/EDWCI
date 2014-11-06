USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [transform].[zz_FactTransaction_Invoice_Concession]
    @TaskExecutionInstanceID INT
  , @LatestSuccessfulTaskExecutionInstanceID INT
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
	      , TransactionDesc     NVARCHAR(100)   NULL
	      , TransactionKey      NVARCHAR(20)    NULL
	      ) ;
    --/

    --Insert into temporary table
    WITH pricePlan
        AS (SELECT utl_account_price_plan.seq_product_item_id,
                   utl_price_plan.price_plan_code,
                   utl_price_plan.green_percent,
                   CASE
                   WHEN utl_account_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
                     OR utl_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
                     OR utl_price_category.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID THEN 1
                       ELSE 0
                   END AS Meta_HasChanged
              FROM
                   DW_Staging.orion.utl_account_price_plan INNER JOIN DW_Staging.orion.utl_price_plan
                   ON utl_price_plan.price_plan_id = utl_account_price_plan.price_plan_id
                                                           LEFT JOIN DW_Staging.orion.utl_price_category
                   ON utl_price_category.price_category_id = utl_price_plan.price_category_id
              WHERE (utl_account_price_plan.end_date IS NULL
                  OR utl_account_price_plan.end_date > GETDATE ()) 
                AND utl_account_price_plan.start_date < GETDATE ()) , productKey
        AS (SELECT nc_product_item.seq_product_item_id,
                   CASE
                   WHEN nc_product_item.tco_id <> 1 THEN CAST (nc_product_item.tco_id AS nvarchar (100)) 
                   WHEN utl_contract_term.contract_term_desc = 'Lumo Express'
                     OR utl_contract_term.contract_term_desc = 'Lumo Express 2012' THEN 'Lumo Express'
                   WHEN utl_contract_term.contract_term_desc = 'Lumo Velocity' THEN 'Lumo Velocity'
                   WHEN utl_contract_term.contract_term_desc = 'Lumo Virgin Staff' THEN 'Lumo Virgin Staff'
                   WHEN utl_contract_term.contract_term_desc = 'Lumo Movers' THEN 'Lumo Movers'
                   WHEN utl_contract_term.contract_term_desc = 'Lumo Basic' THEN 'Lumo Basic'
                   WHEN _pricePlan.green_percent = '0.1' THEN 'Lumo Life 10'
                   WHEN _pricePlan.green_percent = '1' THEN 'Lumo Life 100'
                   WHEN LEFT (_pricePlan.price_plan_code, 3) IN ('OCC', 'STD') THEN 'Lumo Options'
                       ELSE 'Lumo Advantage'
                   END AS ProductKey,
                   CASE
                   WHEN nc_product_item.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
                     OR utl_contract_term.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
                     OR _pricePlan.Meta_HasChanged = 1 THEN 1
                       ELSE 0
                   END AS Meta_HasChanged
              FROM
                   DW_Staging.orion.nc_product_item LEFT JOIN DW_Staging.orion.utl_contract_term
                   ON utl_contract_term.contract_term_id = nc_product_item.contract_term_id
                                                    LEFT JOIN pricePlan AS _pricePlan
                   ON _pricePlan.seq_product_item_id = nc_product_item.seq_product_item_id) 
        
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
				            , TransactionDesc
				            , TransactionKey
                    )
        SELECT
        _DimAccount.AccountId,
        COALESCE ( _DimService.ServiceId , -1) ,
        COALESCE ( _DimProduct.ProductId , -1) ,
        COALESCE ( _DimFinancialAccount.FinancialAccountId , -1) ,
        CONVERT (nchar (8) , COALESCE ( utl_transaction.transaction_date , '9999-12-31') , 112) ,
        COALESCE ( _DimVersion.VersionId , -1) ,

        /* utl_transaction.trans_id */

        -1,
        COALESCE ( utl_transaction.unit_quantity , 0) * COALESCE (utl_transaction.multiplier, 0) ,
        COALESCE ( utl_transaction.net_amount , 0) ,

        /* utl_transaction.trans_id */

        'AUD',
        COALESCE ( utl_transaction.net_amount , 0) * COALESCE (utl_transaction.tax_rate, 0) ,
        utl_transaction.trans_description,

        /* utl_transaction.trans_id */

        'CON' + CAST (utl_transaction.trans_id AS nvarchar (11)) + '.' + CAST (utl_transaction.trans_seq AS nvarchar (2)) 
          FROM
               DW_Staging.orion.utl_transaction INNER JOIN DW_Staging.orion.utl_transaction_type
               ON utl_transaction_type.trans_type_id = utl_transaction.trans_type_id
              AND utl_transaction_type.trans_type_code = 'CONC'
                                                INNER JOIN DW_Staging.orion.utl_conc_trans
               ON utl_conc_trans.trans_id = utl_transaction.meter_id
                                                INNER JOIN DW_Staging.orion.inv_invoice_detail
               ON inv_invoice_detail.seq_invoice_detail_id = utl_transaction.seq_invoice_detail_id
                                                INNER JOIN DW_Staging.orion.ar_invoice
               ON ar_invoice.seq_ar_invoice_id = inv_invoice_detail.seq_invoice_header_id
                                                INNER JOIN DW_Staging.orion.nc_client
               ON nc_client.seq_party_id = ar_invoice.seq_party_id
                                                INNER JOIN DW_Staging.orion.crm_element_hierarchy
               ON crm_element_hierarchy.element_id = nc_client.seq_party_id
              AND crm_element_hierarchy.element_struct_code = 'CLIENT'
                                                INNER JOIN DW_Staging.orion.crm_party_type
               ON crm_party_type.seq_party_type_id = crm_element_hierarchy.seq_element_type_id
              AND ISNULL (crm_party_type.party_type, '') <> 'SUBCLIENT'
                                                LEFT JOIN productKey AS _productKey
               ON _productKey.seq_product_item_id = utl_transaction.seq_product_item_id
                                                INNER JOIN DW_Dimensional.DW.DimAccount AS _DimAccount
               ON _DimAccount.AccountKey = nc_client.seq_party_id
              AND _DimAccount.Meta_IsCurrent = 1
                                                LEFT JOIN DW_Dimensional.DW.DimService AS _DimService
               ON _DimService.ServiceKey = utl_transaction.site_id
              AND _DimService.Meta_IsCurrent = 1
                                                LEFT JOIN DW_Dimensional.DW.DimProduct AS _DimProduct
               ON _DimProduct.ProductKey = _productKey.ProductKey
              AND _DimProduct.Meta_IsCurrent = 1
                                                LEFT JOIN DW_Dimensional.DW.DimFinancialAccount AS _DimFinancialAccount
               ON _DimFinancialAccount.FinancialAccountKey = 32
              AND _DimFinancialAccount.Meta_IsCurrent = 1
                                                LEFT JOIN DW_Dimensional.DW.DimVersion AS _DimVersion
               ON _DimVersion.VersionKey = 'Actual'
          WHERE utl_transaction.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR utl_transaction_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR utl_conc_trans.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR inv_invoice_detail.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR ar_invoice.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _productKey.Meta_HasChanged = 1;
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
			    , TransactionDesc
			    , TransactionKey
	  FROM    #FactTransaction;
	  --/

    --Return row counts
    SELECT 0 AS ExtractRowCount,
           @@ROWCOUNT AS InsertRowCount,
           0 AS UpdateRowCount,
           0 AS DeleteRowCount,
           0 AS ErrorRowCount;
    --/

END;

GO
