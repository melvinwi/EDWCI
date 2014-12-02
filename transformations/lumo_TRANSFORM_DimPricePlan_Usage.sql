CREATE PROCEDURE lumo.TRANSFORM_DimPricePlan_Usage
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

	; WITH ppRelationship AS (SELECT utl_pp_relationship.price_plan_id, utl_pp_relationship.pp_simple_sched_id, utl_pp_relationship.Meta_LatestUpdate_TaskExecutionInstanceId FROM /* Staging */ lumo.utl_pp_relationship WHERE utl_pp_relationship.pp_simple_sched_id IN (SELECT utl_pp_relationship.pp_simple_sched_id FROM /* Staging */ lumo.utl_pp_relationship GROUP BY utl_pp_relationship.pp_simple_sched_id HAVING COUNT (*) = 1)) , value_code AS (SELECT value_code.price_plan_code, value_code.variation_from_market, value_code.Meta_LatestUpdate_TaskExecutionInstanceId, ROW_NUMBER () OVER (PARTITION BY value_code.price_plan_code ORDER BY value_code.Meta_LatestUpdate_TaskExecutionInstanceId DESC) AS recency FROM /* Staging */ lumo.value_code)
	INSERT INTO lumo.DimPricePlan (
		DimPricePlan.PricePlanKey,
		DimPricePlan.PricePlanCode,
		DimPricePlan.PricePlanName,
		DimPricePlan.PricePlanDiscountPercentage,
		DimPricePlan.PricePlanValueRatio,
		DimPricePlan.PricePlanType,
		DimPricePlan.Bundled,
		DimPricePlan.ParentPricePlanCode)
	  SELECT
		N'USAGE.' + CAST( utl_pp_simple_schedule.pp_simple_sched_id AS nvarchar(20)),
		utl_pp_simple_schedule.pp_simple_sched_code,
		utl_pp_simple_schedule.pp_simple_sched_desc,
		utl_price_plan.discount_pct,
		_value_code.variation_from_market,
		/* utl_pp_simple_schedule.pp_simple_sched_id */ N'Usage',
		CASE utl_price_plan.bundled_flag WHEN 'Y' THEN N'Bundled' WHEN 'N' THEN N'Not Bundled' END,
		utl_price_plan.price_plan_code
	  FROM /* Staging */ lumo.utl_pp_simple_schedule LEFT JOIN ppRelationship AS _ppRelationship ON _ppRelationship.pp_simple_sched_id = utl_pp_simple_schedule.pp_simple_sched_id LEFT JOIN /* Staging */ lumo.utl_price_plan ON utl_price_plan.price_plan_id = _ppRelationship.price_plan_id LEFT JOIN value_code AS _value_code ON _value_code.price_plan_code = utl_price_plan.price_plan_code AND _value_code.recency = 1 WHERE utl_pp_simple_schedule.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _value_code.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _ppRelationship.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;