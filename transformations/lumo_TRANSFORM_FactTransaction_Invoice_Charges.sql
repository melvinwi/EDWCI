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

	;WITH maxRate AS (SELECT inv_client_charges.seq_client_charge_id, MAX (nc_tax_rate_history.tax_rate_history_id) AS tax_rate_history_id, MAX (nc_tax_rate_history.Meta_LatestUpdate_TaskExecutionInstanceId) AS Meta_LatestUpdate_TaskExecutionInstanceId FROM /* Staging */ lumo.inv_client_charges CROSS JOIN /* Staging */ lumo.nc_tax_rate_history WHERE inv_client_charges.charge_date BETWEEN nc_tax_rate_history.start_date AND COALESCE (nc_tax_rate_history.end_date, '9999-12-31') GROUP BY inv_client_charges.seq_client_charge_id, inv_client_charges.charge_date) , taxRate AS (SELECT maxRate.seq_client_charge_id, maxRate.Meta_LatestUpdate_TaskExecutionInstanceId, nc_tax_rate_history.tax_rate FROM maxRate INNER JOIN /* Staging */ lumo.nc_tax_rate_history ON nc_tax_rate_history.tax_rate_history_id = maxRate.tax_rate_history_id), pricePlan AS (SELECT utl_account_price_plan.seq_product_item_id, utl_price_plan.price_plan_code, utl_price_plan.green_percent, CASE WHEN utl_account_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_price_category.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID THEN 1 ELSE 0 END AS Meta_HasChanged, row_number() OVER (PARTITION BY utl_account_price_plan.seq_product_item_id ORDER BY utl_account_price_plan.start_date DESC) AS recency FROM /* Staging */ lumo.utl_account_price_plan INNER JOIN /* Staging */ lumo.utl_price_plan ON utl_price_plan.price_plan_id = utl_account_price_plan.price_plan_id LEFT JOIN /* Staging */ lumo.utl_price_category ON utl_price_category.price_category_id = utl_price_plan.price_category_id WHERE (utl_account_price_plan.end_date IS NULL OR utl_account_price_plan.end_date > GETDATE ()) AND utl_account_price_plan.start_date < GETDATE ()) , productKey AS (SELECT nc_product_item.seq_product_item_id, CASE WHEN nc_product_item.tco_id <> 1 THEN CAST (nc_product_item.tco_id AS nvarchar (100)) WHEN utl_contract_term.contract_term_desc = 'Lumo Express'OR utl_contract_term.contract_term_desc = 'Lumo Express 2012' THEN 'Lumo Express'WHEN utl_contract_term.contract_term_desc = 'Lumo Velocity' THEN 'Lumo Velocity'WHEN utl_contract_term.contract_term_desc = 'Lumo Virgin Staff' THEN 'Lumo Virgin Staff'WHEN utl_contract_term.contract_term_desc = 'Lumo Movers' THEN 'Lumo Movers'WHEN utl_contract_term.contract_term_desc = 'Lumo Basic' THEN 'Lumo Basic'WHEN _pricePlan.green_percent = '0.1' THEN 'Lumo Life 10'WHEN _pricePlan.green_percent = '1' THEN 'Lumo Life 100'WHEN LEFT (_pricePlan.price_plan_code, 3) IN ('OCC', 'STD') THEN 'Lumo Options'ELSE 'Lumo Advantage'END AS ProductKey, CASE WHEN nc_product_item.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_contract_term.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _pricePlan.Meta_HasChanged = 1 THEN 1 ELSE 0 END AS Meta_HasChanged FROM /* Staging */ lumo.nc_product_item LEFT JOIN /* Staging */ lumo.utl_contract_term ON utl_contract_term.contract_term_id = nc_product_item.contract_term_id LEFT JOIN pricePlan AS _pricePlan ON _pricePlan.seq_product_item_id = nc_product_item.seq_product_item_id AND _pricePlan.recency = 1)
	INSERT INTO lumo.FactTransaction (
		FactTransaction.AccountId,
		FactTransaction.ServiceId,
		FactTransaction.ProductId,
		FactTransaction.FinancialAccountId,
		FactTransaction.TransactionDateId,
		FactTransaction.PostedDateId,
		FactTransaction.VersionId,
		FactTransaction.UnitTypeId,
		FactTransaction.Units,
		FactTransaction.Value,
		FactTransaction.Currency,
		FactTransaction.Tax,
		FactTransaction.TransactionType,
		FactTransaction.TransactionDesc,
		FactTransaction.TransactionKey,
		FactTransaction.MeterRegisterId,
		FactTransaction.TransactionSubtype,
		FactTransaction.Reversal,
		FactTransaction.Reversed,
		FactTransaction.StartRead,
		FactTransaction.EndRead,
		FactTransaction.StartDateId,
		FactTransaction.EndDateId,
		FactTransaction.AccountingPeriod,
		FactTransaction.ReceiptBatch)
	  SELECT
		_DimAccount.AccountId,
		COALESCE( _DimService.ServiceId , -1),
		COALESCE( _DimProduct.ProductId , -1),
		COALESCE( _DimFinancialAccount.FinancialAccountId , -1),
		CONVERT(NCHAR(8), COALESCE( inv_client_charges.charge_date , '9999-12-31'), 112),
		CONVERT(NCHAR(8), COALESCE( ar_invoice.posted_date , '9999-12-31'), 112),
		COALESCE( _DimVersion.VersionId , -1),
		/* inv_client_charges.seq_client_charge_id */ -1,
		/* inv_client_charges.seq_client_charge_id */ 0,
		COALESCE( inv_client_charges.charge_amount , 0),
		/* inv_client_charges.seq_client_charge_id */ N'AUD',
		( inv_client_charges.charge_amount * COALESCE (_taxRate.tax_rate, 0)),
		/* inv_client_charges.seq_client_charge_id */ N'Client Charges',
		CAST( inv_client_charges.invoice_description AS nvarchar(100)),
		'CHG' + CAST( inv_client_charges.seq_client_charge_id AS NVARCHAR(11)),
		/* inv_client_charges.seq_client_charge_id */ -1,
		/* inv_client_charges.seq_client_charge_id */ N'Client Charges',
		CASE WHEN inv_invoice_header.reversal = 'Y' THEN N'Yes' WHEN inv_client_charges.invoice_description LIKE '%REVERSAL%' THEN N'Yes'ELSE N'No ' END,
		CASE WHEN inv_invoice_header.reversal = 'Y' THEN N'No 'WHEN inv_client_charges.invoice_description LIKE '%REVERSAL%' THEN N'No 'WHEN inv_invoice_header.reversal_seq_invoice_header_id IS NOT NULL THEN N'Yes'ELSE N'No ' END,
		/* inv_client_charges.seq_client_charge_id */ 0,
		/* inv_client_charges.seq_client_charge_id */ 0,
		/* inv_client_charges.seq_client_charge_id */ 99991231,
		/* inv_client_charges.seq_client_charge_id */ 99991231,
		ar_invoice.seq_accounting_period_id,
		/* inv_client_charges.seq_client_charge_id */ NULL
	  FROM /* Staging */ lumo.inv_client_charges INNER JOIN /* Staging */ lumo.inv_charge_item ON inv_charge_item.seq_charge_item_id = inv_client_charges.seq_charge_item_id LEFT JOIN /* Staging */ lumo.nc_product_item ON nc_product_item.seq_product_item_id = inv_client_charges.seq_product_item_id LEFT JOIN productKey AS _productKey ON _productKey.seq_product_item_id = inv_client_charges.seq_product_item_id LEFT JOIN /* Staging */ lumo.inv_invoice_header ON inv_invoice_header.seq_invoice_header_id = inv_client_charges.seq_invoice_header_id LEFT JOIN /* Staging */ lumo.ar_invoice ON ar_invoice.seq_ar_invoice_id = inv_client_charges.seq_invoice_header_id INNER JOIN /* Dimensional */ lumo.DimAccount AS _DimAccount ON _DimAccount.AccountKey = inv_client_charges.seq_party_id AND _DimAccount.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimService AS _DimService ON _DimService.ServiceKey = nc_product_item.site_id AND _DimService.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimProduct AS _DimProduct ON _DimProduct.ProductKey = _productKey.ProductKey AND _DimProduct.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimFinancialAccount AS _DimFinancialAccount ON _DimFinancialAccount.FinancialAccountKey = inv_charge_item.seq_account_id AND _DimFinancialAccount.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimVersion AS _DimVersion ON _DimVersion.VersionKey = N'Actual' LEFT JOIN taxRate AS _taxRate ON _taxRate.seq_client_charge_id = inv_client_charges.seq_client_charge_id WHERE inv_client_charges.approved ='Y'AND (inv_charge_item.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR inv_client_charges.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR inv_invoice_header.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR ar_invoice.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR nc_product_item.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _productKey.Meta_HasChanged = 1 OR _taxRate.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID);

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;