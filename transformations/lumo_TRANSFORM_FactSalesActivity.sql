CREATE PROCEDURE lumo.TRANSFORM_FactSalesActivity
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

	;WITH crmElementHierarchy AS (SELECT crm_element_hierarchy.element_id, crm_element_hierarchy.element_struct_code, crm_element_hierarchy.parent_id, crm_element_hierarchy.Meta_LatestUpdate_TaskExecutionInstanceId, row_number() OVER (PARTITION BY crm_element_hierarchy.element_id ORDER BY crm_element_hierarchy.start_date1 DESC) AS recency FROM /* Staging */ lumo.crm_element_hierarchy), pricePlan AS (SELECT utl_account_price_plan.seq_product_item_id, utl_price_plan.price_plan_id, utl_price_plan.price_plan_code, utl_price_plan.green_percent, CASE WHEN utl_account_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_price_category.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID THEN 1 ELSE 0 END AS Meta_HasChanged, row_number() OVER (PARTITION BY utl_account_price_plan.seq_product_item_id ORDER BY utl_account_price_plan.start_date DESC) AS recency FROM /* Staging */ lumo.utl_account_price_plan INNER JOIN /* Staging */ lumo.utl_price_plan ON utl_price_plan.price_plan_id = utl_account_price_plan.price_plan_id LEFT JOIN /* Staging */ lumo.utl_price_category ON utl_price_category.price_category_id = utl_price_plan.price_category_id WHERE (utl_account_price_plan.end_date IS NULL OR utl_account_price_plan.end_date > GETDATE ()) AND utl_account_price_plan.start_date < GETDATE ()), productKey AS (SELECT nc_product_item.seq_product_item_id, _pricePlan.price_plan_id, CASE WHEN nc_product_item.tco_id <> 1 THEN CAST (nc_product_item.tco_id AS nvarchar (100)) WHEN utl_contract_term.contract_term_desc = 'Lumo Express' OR utl_contract_term.contract_term_desc = 'Lumo Express 2012' THEN 'Lumo Express' WHEN utl_contract_term.contract_term_desc = 'Lumo Velocity' THEN 'Lumo Velocity' WHEN utl_contract_term.contract_term_desc = 'Lumo Virgin Staff' THEN 'Lumo Virgin Staff' WHEN utl_contract_term.contract_term_desc = 'Lumo Movers' THEN 'Lumo Movers' WHEN utl_contract_term.contract_term_desc = 'Lumo Basic' THEN 'Lumo Basic' WHEN _pricePlan.green_percent = '0.1' THEN 'Lumo Life 10' WHEN _pricePlan.green_percent = '1' THEN 'Lumo Life 100' WHEN LEFT (_pricePlan.price_plan_code, 3) IN ('OCC', 'STD') THEN 'Lumo Options'ELSE 'Lumo Advantage' END AS ProductKey, CASE WHEN nc_product_item.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_contract_term.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _pricePlan.Meta_HasChanged = 1 THEN 1 ELSE 0 END AS Meta_HasChanged FROM /* Staging */ lumo.nc_product_item LEFT JOIN /* Staging */ lumo.utl_contract_term ON utl_contract_term.contract_term_id = nc_product_item.contract_term_id LEFT JOIN pricePlan AS _pricePlan ON _pricePlan.seq_product_item_id = nc_product_item.seq_product_item_id AND _pricePlan.recency = 1)
	INSERT INTO lumo.FactSalesActivity (
		FactSalesActivity.AccountId,
		FactSalesActivity.ServiceId,
		FactSalesActivity.ProductId,
		FactSalesActivity.PricePlanId,
		FactSalesActivity.RepresentativeId,
		FactSalesActivity.OrganisationId,
		FactSalesActivity.SalesActivityType,
		FactSalesActivity.SalesActivityDateId,
		FactSalesActivity.SalesActivityTime,
		FactSalesActivity.SalesActivityKey)
	  SELECT
		COALESCE( _DimAccount.AccountId , -1),
		COALESCE( _DimService.ServiceId , -1),
		COALESCE( _DimProduct.ProductId , -1),
		COALESCE( _DimPricePlan.PricePlanId , -1),
		COALESCE( _DimRepresentative.RepresentativeId , -1),
		COALESCE( _DimOrganisation.OrganisationId , -1),
		nc_involvement_type.involve_type_desc,
		CONVERT(NCHAR(8), nc_sales_involvement.sales_complete , 112),
		CAST( nc_sales_involvement.sales_complete AS TIME),
		CAST( nc_sales_involvement.seq_party_id AS NVARCHAR(10)) + '.' + CAST(nc_sales_involvement.seq_involve_type_id AS NVARCHAR(10)) + '.' + CAST(nc_sales_involvement.seq_product_id AS NVARCHAR(10)) + '.' + CAST(nc_sales_involvement.seq_product_item_id AS NVARCHAR(10)) + '.' + CONVERT(NCHAR(23), nc_sales_involvement.sales_complete, 126)
	  FROM /* Staging */ lumo.nc_sales_involvement INNER JOIN /* Staging */ lumo.nc_involvement_type ON nc_involvement_type.seq_involve_type_id = nc_sales_involvement.seq_involve_type_id LEFT JOIN /* Staging */ lumo.nc_product ON nc_product.seq_product_id = nc_sales_involvement.seq_product_id LEFT JOIN /* Dimensional */ lumo.DimAccount AS _DimAccount ON _DimAccount.AccountKey = nc_product.seq_party_id AND _DimAccount.Meta_IsCurrent = 1 LEFT JOIN /* Staging */ lumo.nc_product_item ON nc_product_item.seq_product_item_id = nc_sales_involvement.seq_product_item_id LEFT JOIN /* Dimensional */ lumo.DimService AS _DimService ON _DimService.ServiceKey = CAST(nc_product_item.site_id AS int) AND _DimService.Meta_IsCurrent = 1 LEFT JOIN productKey AS _productKey ON _productKey.seq_product_item_id = nc_product_item.seq_product_item_id LEFT JOIN /* Dimensional */ lumo.DimProduct AS _DimProduct ON _DimProduct.ProductKey = _productKey.ProductKey AND _DimProduct.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimPricePlan AS _DimPricePlan ON _DimPricePlan.PricePlanKey = N'DAILY.' + CAST(_productKey.price_plan_id AS nvarchar(20)) AND _DimPricePlan.Meta_IsCurrent = 1 LEFT JOIN crmElementHierarchy AS _crmElementHierarchy ON _crmElementHierarchy.element_id = nc_sales_involvement.seq_party_id AND _crmElementHierarchy.recency = 1 LEFT JOIN /* Dimensional */ lumo.DimRepresentative AS _DimRepresentative ON _DimRepresentative.RepresentativeKey = CASE WHEN _crmElementHierarchy.element_struct_code IN ('SALES', 'STAFF') THEN _crmElementHierarchy.element_id END AND _DimRepresentative.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimOrganisation AS _DimOrganisation ON _DimOrganisation.OrganisationKey = CASE WHEN _crmElementHierarchy.element_struct_code IN ('CLIENT', 'SALES', 'STAFF') THEN _crmElementHierarchy.parent_id WHEN _crmElementHierarchy.element_struct_code IN ('COMPANY', 'DEPARTMENT', 'GROUP', 'SALESDEPT', 'SALESGRP') THEN _crmElementHierarchy.element_id END AND _DimOrganisation.Meta_IsCurrent = 1 WHERE nc_sales_involvement.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR nc_involvement_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;