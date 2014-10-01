CREATE PROCEDURE lumo.TRANSFORM_FactTransaction_Invoice_Rebate
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

	;WITH pricePlan AS (SELECT utl_account_price_plan.seq_product_item_id, utl_price_plan.price_plan_code, utl_price_plan.green_percent, CASE WHEN utl_account_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_price_category.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID THEN 1 ELSE 0 END AS Meta_HasChanged, row_number() OVER (PARTITION BY utl_account_price_plan.seq_product_item_id ORDER BY utl_account_price_plan.start_date DESC) AS recency FROM /* Staging */ lumo.utl_account_price_plan INNER JOIN /* Staging */ lumo.utl_price_plan ON utl_price_plan.price_plan_id = utl_account_price_plan.price_plan_id LEFT JOIN /* Staging */ lumo.utl_price_category ON utl_price_category.price_category_id = utl_price_plan.price_category_id WHERE (utl_account_price_plan.end_date IS NULL OR utl_account_price_plan.end_date > GETDATE ()) AND utl_account_price_plan.start_date < GETDATE ()) , productKey AS (SELECT nc_product_item.seq_product_item_id, CASE WHEN nc_product_item.tco_id <> 1 THEN CAST (nc_product_item.tco_id AS nvarchar (100)) WHEN utl_contract_term.contract_term_desc = 'Lumo Express'OR utl_contract_term.contract_term_desc = 'Lumo Express 2012' THEN 'Lumo Express'WHEN utl_contract_term.contract_term_desc = 'Lumo Velocity' THEN 'Lumo Velocity'WHEN utl_contract_term.contract_term_desc = 'Lumo Virgin Staff' THEN 'Lumo Virgin Staff'WHEN utl_contract_term.contract_term_desc = 'Lumo Movers' THEN 'Lumo Movers'WHEN utl_contract_term.contract_term_desc = 'Lumo Basic' THEN 'Lumo Basic'WHEN _pricePlan.green_percent = '0.1' THEN 'Lumo Life 10'WHEN _pricePlan.green_percent = '1' THEN 'Lumo Life 100'WHEN LEFT (_pricePlan.price_plan_code, 3) IN ('OCC', 'STD') THEN 'Lumo Options'ELSE 'Lumo Advantage'END AS ProductKey, CASE WHEN nc_product_item.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_contract_term.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _pricePlan.Meta_HasChanged = 1 THEN 1 ELSE 0 END AS Meta_HasChanged FROM /* Staging */ lumo.nc_product_item LEFT JOIN /* Staging */ lumo.utl_contract_term ON utl_contract_term.contract_term_id = nc_product_item.contract_term_id LEFT JOIN pricePlan AS _pricePlan ON _pricePlan.seq_product_item_id = nc_product_item.seq_product_item_id AND _pricePlan.recency = 1), ppScheduleType AS (SELECT utl_pp_schedule_type.sched_type_id, utl_pp_schedule_type.sched_type_code, COALESCE(utl_pp_schedule_type.seq_account_id, ar_account.seq_account_id) AS seq_account_id, utl_pp_schedule_type.Meta_LatestUpdate_TaskExecutionInstanceId FROM /* Staging */ lumo.utl_pp_schedule_type LEFT JOIN /* Staging */ lumo.utl_pp_schedule_class ON utl_pp_schedule_class.sched_class_id = utl_pp_schedule_type.sched_class_id LEFT JOIN /* Staging */ lumo.nc_product_type ON nc_product_type.seq_product_type_id = utl_pp_schedule_type.seq_product_type_id LEFT JOIN /* Staging */ lumo.ar_account ON ar_account.account_code = LEFT(utl_pp_schedule_class.sched_class_code, 1) + CASE nc_product_type.product_type_code WHEN 'POWER' THEN 'ELECT' ELSE nc_product_type.product_type_code END)
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
		FactTransaction.TransactionType,
		FactTransaction.TransactionDesc,
		FactTransaction.TransactionKey)
	  SELECT
		_DimAccount.AccountId,
		COALESCE( _DimService.ServiceId , -1),
		COALESCE( _DimProduct.ProductId , -1),
		COALESCE( _DimFinancialAccount.FinancialAccountId , -1),
		CONVERT(NCHAR(8), COALESCE( utl_transaction.transaction_date , '9999-12-31'), 112),
		COALESCE( _DimVersion.VersionId , -1),
		/* utl_transaction.trans_id */ -1,
		COALESCE( utl_transaction.unit_quantity , 0) * COALESCE(utl_transaction.multiplier, 0),
		COALESCE( utl_transaction.net_amount , 0),
		/* utl_transaction.trans_id */ 'AUD',
		COALESCE( utl_transaction.net_amount , 0) * 0.10,
		utl_transaction_type.trans_type_desc,
		utl_transaction.trans_description,
		/* utl_transaction.trans_id */ 'REB' + CAST(utl_transaction.trans_id AS NVARCHAR(11)) + '.' + CAST(utl_transaction.trans_seq AS NVARCHAR(2))
	  FROM /* Staging */ lumo.utl_transaction INNER JOIN /* Staging */ lumo.utl_transaction_type ON utl_transaction_type.trans_type_id = utl_transaction.trans_type_id AND utl_transaction_type.trans_type_code = 'REBATE' INNER JOIN /* Staging */ lumo.inv_invoice_detail ON inv_invoice_detail.seq_invoice_detail_id = utl_transaction.seq_invoice_detail_id INNER JOIN /* Staging */ lumo.ar_invoice ON ar_invoice.seq_ar_invoice_id = inv_invoice_detail.seq_invoice_header_id INNER JOIN /* Staging */ lumo.nc_client ON nc_client.seq_party_id = ar_invoice.seq_party_id INNER JOIN /* Staging */ lumo.crm_element_hierarchy ON crm_element_hierarchy.element_id = nc_client.seq_party_id AND crm_element_hierarchy.element_struct_code = 'CLIENT' INNER JOIN /* Staging */ lumo.crm_party_type ON crm_party_type.seq_party_type_id = crm_element_hierarchy.seq_element_type_id AND ISNULL(crm_party_type.party_type, '') <> 'SUBCLIENT' INNER JOIN /* Staging */ lumo.utl_pp_schedule ON utl_pp_schedule.sched_id = utl_transaction.sched_id INNER JOIN ppScheduleType ON ppScheduleType.sched_type_id = utl_pp_schedule.sched_type_id LEFT JOIN productKey as _productKey ON _productKey.seq_product_item_id = utl_transaction.seq_product_item_id INNER JOIN /* Dimensional */ lumo.DimAccount AS _DimAccount ON _DimAccount.AccountKey = nc_client.seq_party_id AND _DimAccount.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimService AS _DimService ON _DimService.ServiceKey = utl_transaction.site_id AND _DimService.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimProduct AS _DimProduct ON _DimProduct.ProductKey = _productKey.ProductKey AND _DimProduct.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimFinancialAccount AS _DimFinancialAccount ON _DimFinancialAccount.FinancialAccountKey = ppScheduleType.seq_account_id AND _DimFinancialAccount.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimVersion AS _DimVersion ON _DimVersion.VersionKey = 'Actual'WHERE utl_transaction.invoiced = 'Y' AND (utl_transaction.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_transaction_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR inv_invoice_detail.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR ar_invoice.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_pp_schedule.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR ppScheduleType.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _productKey.Meta_HasChanged = 1);

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;