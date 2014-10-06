CREATE PROCEDURE lumo.TRANSFORM_DimPricePlan
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

	;WITH value_code AS (SELECT value_code.price_plan_code, value_code.variation_from_market, value_code.Meta_LatestUpdate_TaskExecutionInstanceId, row_number() OVER (PARTITION BY value_code.price_plan_code ORDER BY value_code.Meta_LatestUpdate_TaskExecutionInstanceId DESC) AS recency FROM /* Staging */ lumo.value_code)
	INSERT INTO lumo.DimPricePlan (
		DimPricePlan.PricePlanKey,
		DimPricePlan.PricePlanCode,
		DimPricePlan.PricePlanValueRatio)
	  SELECT
		utl_price_plan.price_plan_id,
		utl_price_plan.price_plan_code,
		_value_code.variation_from_market
	  FROM /* Staging */ lumo.utl_price_plan LEFT JOIN value_code AS _value_code ON _value_code.price_plan_code = utl_price_plan.price_plan_code AND _value_code.recency = 1 WHERE utl_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _value_code.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;