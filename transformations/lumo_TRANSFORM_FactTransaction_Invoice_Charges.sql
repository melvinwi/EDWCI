CREATE PROCEDURE lumo.TRANSFORM_FactTransaction_Invoice_Charges
@TaskExecutionInstanceID INT
,@LatestSuccessfulTaskExecutionInstanceID INT
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

	;WITH pricePlan AS (SELECT utl_account_price_plan.seq_product_item_id, utl_price_plan.price_plan_code, utl_price_plan.green_percent, CASE WHEN utl_account_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_price_category.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID THEN 1 ELSE 0 END AS Meta_HasChanged FROM /* Staging */ lumo.utl_account_price_plan INNER JOIN /* Staging */ lumo.utl_price_plan ON utl_price_plan.price_plan_id = utl_account_price_plan.price_plan_id LEFT JOIN /* Staging */ lumo.utl_price_category ON utl_price_category.price_category_id = utl_price_plan.price_category_id WHERE (utl_account_price_plan.end_date IS NULL OR utl_account_price_plan.end_date > GETDATE()) AND utl_account_price_plan.start_date < GETDATE()), productKey AS (SELECT nc_product_item.seq_product_item_id, (CASE WHEN nc_product_item.tco_id <> 1 THEN CAST(nc_product_item.tco_id AS nvarchar(100)) WHEN utl_contract_term.contract_term_desc = 'Lumo Express' OR utl_contract_term.contract_term_desc = 'Lumo Express 2012' THEN 'Lumo Express' WHEN utl_contract_term.contract_term_desc = 'Lumo Velocity' THEN 'Lumo Velocity' WHEN utl_contract_term.contract_term_desc = 'Lumo Virgin Staff' THEN 'Lumo Virgin Staff' WHEN utl_contract_term.contract_term_desc = 'Lumo Movers' THEN 'Lumo Movers' WHEN utl_contract_term.contract_term_desc = 'Lumo Basic' THEN 'Lumo Basic' WHEN _pricePlan.green_percent = '0.1' THEN 'Lumo Life 10' WHEN _pricePlan.green_percent = '1' THEN 'Lumo Life 100' WHEN left(_pricePlan.price_plan_code,3) IN ('OCC', 'STD') THEN 'Lumo Options' ELSE 'Lumo Advantage' END) AS ProductKey, CASE WHEN nc_product_item.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_contract_term.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _pricePlan.Meta_HasChanged = 1 THEN 1 ELSE 0 END AS Meta_HasChanged FROM /* Staging */ lumo.nc_product_item LEFT JOIN /* Staging */ lumo.utl_contract_term ON utl_contract_term.contract_term_id = nc_product_item.contract_term_id LEFT JOIN pricePlan AS _pricePlan ON _pricePlan.seq_product_item_id = nc_product_item.seq_product_item_id)
	INSERT INTO lumo.FactTransaction (
		FactTransaction.AccountId,
		FactTransaction.ServiceId,
		FactTransaction.ProductId,
		FactTransaction.FinancialAccountId,
		FactTransaction.TransactionDateId,
		FactTransaction.VersionId,
		FactTransaction.UnitTypeId,
		FactTransaction.Units,
		FactTransaction.Value,
		FactTransaction.Currency,
		FactTransaction.Tax,
		FactTransaction.TransactionDesc,
		FactTransaction.TransactionKey)
	  SELECT
		_DimAccount.AccountId,
		COALESCE( _DimService.ServiceId , -1),
		COALESCE( _DimProduct.ProductId , -1),
		COALESCE( _DimFinancialAccount.FinancialAccountKey , -1),
		CONVERT(NCHAR(8), COALESCE( utl_charge_transaction.charge_date , '9999-12-31'), 112),
		COALESCE( _DimVersion.VersionId , -1),
		/* utl_charge_transaction.charge_trans_id */ -1,
		/* utl_charge_transaction.charge_trans_id */ 0,
		COALESCE( utl_charge_transaction.net_amount , 0),
		/* utl_charge_transaction.charge_trans_id */ 'AUD',
		COALESCE( utl_charge_transaction.tax_amount , 0),
		utl_charge_transaction.charge_item_desc,
		/* utl_charge_transaction.charge_trans_id */ 'CHG' + CAST(utl_charge_transaction.charge_trans_id AS NVARCHAR(11))
	  FROM /* Staging */ lumo.utl_charge_transaction INNER JOIN /* Staging */ lumo.inv_charge_item ON inv_charge_item.seq_charge_item_id = utl_charge_transaction.seq_charge_item_id LEFT JOIN /* Staging */ lumo.inv_client_charges ON inv_client_charges.seq_client_charge_id = utl_charge_transaction.seq_client_charge_id LEFT JOIN /* Staging */ lumo.nc_product_item ON nc_product_item.seq_product_item_id = inv_client_charges.seq_product_item_id LEFT JOIN productKey as _productKey ON _productKey.seq_product_item_id = inv_client_charges.seq_product_item_id INNER JOIN /* Dimensional */ lumo.DimAccount AS _DimAccount ON _DimAccount.AccountKey = utl_charge_transaction.seq_party_id AND _DimAccount.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimService AS _DimService ON _DimService.ServiceKey = nc_product_item.site_id AND _DimService.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimProduct AS _DimProduct ON _DimProduct.ProductKey = _productKey.ProductKey AND _DimProduct.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimFinancialAccount AS _DimFinancialAccount ON _DimFinancialAccount.FinancialAccountKey = inv_charge_item.seq_account_id AND _DimFinancialAccount.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimVersion AS _DimVersion ON _DimVersion.VersionKey = 'Actual'WHERE (utl_charge_transaction.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR inv_charge_item.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR inv_client_charges.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR nc_product_item.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _productKey.Meta_HasChanged = 1);

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;