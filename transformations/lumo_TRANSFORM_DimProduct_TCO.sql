CREATE PROCEDURE lumo.TRANSFORM_DimProduct_TCO
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

	INSERT INTO lumo.DimProduct (
		DimProduct.ProductKey,
		DimProduct.ProductName,
		DimProduct.ProductDesc,
		DimProduct.ProductType,
		DimProduct.FixedTariffAdjustPercentage,
		DimProduct.VariableTariffAdjustPercentage)
	  SELECT
		CAST( utl_total_customer_offering.tco_id AS nvarchar(30)),
		CAST( utl_total_customer_offering.tco_desc AS nvarchar(100)),
		CAST( utl_total_customer_offering.tco_desc AS nvarchar(100)),
		/* utl_total_customer_offering.tco_id */ 'TCO',
		COALESCE( utl_total_customer_offering.fixed_tariff_adjust_percent , 100) / 100,
		COALESCE( utl_total_customer_offering.variable_tariff_adjust_percent ,100) / 100
	  FROM lumo.utl_total_customer_offering WHERE utl_total_customer_offering.Meta_LatestUpdate_TaskExecutionInstanceId  > @LatestSuccessfulTaskExecutionInstanceID AND utl_total_customer_offering.tco_id != 1;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;