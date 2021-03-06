CREATE PROCEDURE lumo.TRANSFORM_FactBasicMeterRead
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

	;WITH pricePlan AS (SELECT utl_account_price_plan.seq_product_item_id, utl_price_plan.price_plan_id, utl_price_plan.price_plan_code, utl_price_plan.green_percent, CASE WHEN utl_account_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_price_category.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID THEN 1 ELSE 0 END AS Meta_HasChanged, row_number() OVER (PARTITION BY utl_account_price_plan.seq_product_item_id ORDER BY utl_account_price_plan.start_date DESC) AS recency FROM /* Staging */ lumo.utl_account_price_plan INNER JOIN /* Staging */ lumo.utl_price_plan ON utl_price_plan.price_plan_id = utl_account_price_plan.price_plan_id LEFT JOIN /* Staging */ lumo.utl_price_category ON utl_price_category.price_category_id = utl_price_plan.price_category_id WHERE (utl_account_price_plan.end_date IS NULL OR utl_account_price_plan.end_date > GETDATE ()) AND utl_account_price_plan.start_date < GETDATE ()) , productKey AS (SELECT nc_product_item.seq_product_item_id, CASE WHEN nc_product_item.tco_id <> 1 THEN CAST (nc_product_item.tco_id AS nvarchar (100)) WHEN utl_contract_term.contract_term_desc = 'Lumo Express'OR utl_contract_term.contract_term_desc = 'Lumo Express 2012' THEN 'Lumo Express'WHEN utl_contract_term.contract_term_desc = 'Lumo Velocity' THEN 'Lumo Velocity'WHEN utl_contract_term.contract_term_desc = 'Lumo Virgin Staff' THEN 'Lumo Virgin Staff'WHEN utl_contract_term.contract_term_desc = 'Lumo Movers' THEN 'Lumo Movers'WHEN utl_contract_term.contract_term_desc = 'Lumo Basic' THEN 'Lumo Basic'WHEN _pricePlan.green_percent = '0.1' THEN 'Lumo Life 10'WHEN _pricePlan.green_percent = '1' THEN 'Lumo Life 100'WHEN LEFT (_pricePlan.price_plan_code, 3) IN ('OCC', 'STD') THEN 'Lumo Options'ELSE 'Lumo Advantage'END AS ProductKey, CASE WHEN nc_product_item.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_contract_term.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _pricePlan.Meta_HasChanged = 1 THEN 1 ELSE 0 END AS Meta_HasChanged FROM /* Staging */ lumo.nc_product_item LEFT JOIN /* Staging */ lumo.utl_contract_term ON utl_contract_term.contract_term_id = nc_product_item.contract_term_id LEFT JOIN pricePlan AS _pricePlan ON _pricePlan.seq_product_item_id = nc_product_item.seq_product_item_id AND _pricePlan.recency = 1)
	INSERT INTO lumo.FactBasicMeterRead (
		FactBasicMeterRead.AccountId,
		FactBasicMeterRead.ServiceId,
		FactBasicMeterRead.ProductId,
		FactBasicMeterRead.MeterRegisterId,
		FactBasicMeterRead.BasicMeterReadKey,
		FactBasicMeterRead.ReadType,
		FactBasicMeterRead.ReadSubtype,
		FactBasicMeterRead.ReadValue,
		FactBasicMeterRead.ReadDateId,
		FactBasicMeterRead.EstimatedRead,
		FactBasicMeterRead.ReadPeriod,
		FactBasicMeterRead.QualityMethod,
		FactBasicMeterRead.AddFactor)
	  SELECT
		COALESCE( _DimAccount.AccountId ,-1),
		COALESCE( _DimService.ServiceId ,-1),
		COALESCE( _DimProduct.ProductId ,-1),
		COALESCE( _DimMeterRegister.MeterRegisterId ,-1),
		utl_meter_read.meter_read_id,
		CAST( utl_read_type.read_type_desc AS nvarchar(100)),
		CAST( utl_read_sub_type.read_sub_type_desc AS nvarchar(100)),
		COALESCE( utl_meter_read.meter_read , 0.0),
		CONVERT (nchar (8) , COALESCE (  utl_meter_read.read_date , '9999-12-31') , 112),
		CAST(CASE utl_meter_read.estimated_read WHEN 'Y' THEN N'Yes' ELSE N'No ' END AS nchar(3)),
		COALESCE( utl_meter_read.period_id ,-1),
		CAST( utl_meter_read.quality_method AS nvarchar(20)),
		COALESCE( utl_meter_read.add_factor ,0)
	  FROM /* Staging */ lumo.utl_meter_read INNER JOIN /* Staging */ lumo.utl_read_type ON utl_read_type.read_type_id = utl_meter_read.read_type_id INNER JOIN /* Staging */ lumo.utl_read_sub_type ON utl_read_sub_type.read_sub_type_id = utl_meter_read.read_sub_type_id INNER JOIN /* Staging */ lumo.nc_product_item ON nc_product_item.seq_product_item_id = utl_meter_read.seq_product_item_id INNER JOIN /* Staging */ lumo.nc_product ON nc_product.seq_product_id = nc_product_item.seq_product_id LEFT JOIN /* Dimensional */ lumo.DimAccount AS _DimAccount ON _DimAccount.AccountKey = nc_product.seq_party_id AND _DimAccount.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimService AS _DimService ON _DimService.ServiceKey = CAST(nc_product_item.site_id AS int) AND _DimService.Meta_IsCurrent = 1 LEFT JOIN productKey AS _productKey ON _productKey.seq_product_item_id = nc_product_item.seq_product_item_id LEFT JOIN /* Dimensional */ lumo.DimProduct AS _DimProduct ON _DimProduct.ProductKey = _productKey.ProductKey AND _DimProduct.Meta_IsCurrent = 1 INNER JOIN /* Dimensional */ lumo.DimMeterRegister AS _DimMeterRegister ON _DimMeterRegister.MeterRegisterKey = utl_meter_read.meter_id AND _DimMeterRegister.Meta_IsCurrent = 1 WHERE utl_meter_read.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_read_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_read_sub_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;