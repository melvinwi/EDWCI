CREATE PROCEDURE lumo.TRANSFORM_FactPricePlanRate_Usage_Gas
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

	;WITH applicablePricePlans AS (SELECT MAX (utl_pp_schedule.sched_id) AS sched_id, utl_pp_schedule.price_plan_id FROM /* Staging */ lumo.utl_pp_schedule WHERE utl_pp_schedule.sched_type_id = 12 GROUP BY utl_pp_schedule.price_plan_id)
	INSERT INTO lumo.FactPricePlanRate (
		FactPricePlanRate.PricePlanId,
		FactPricePlanRate.UnitTypeId,
		FactPricePlanRate.PricePlanRateKey,
		FactPricePlanRate.RateStartDateId,
		FactPricePlanRate.RateEndDateId,
		FactPricePlanRate.StepStart,
		FactPricePlanRate.StepEnd,
		FactPricePlanRate.Rate,
		FactPricePlanRate.MinimumCharge,
		FactPricePlanRate.RateType,
		FactPricePlanRate.InvoiceDescription)
	  SELECT
		_DimPricePlan.PricePlanId,
		/* utl_pp_schedule_rate.sched_rate_id */ -1,
		N'USAGE.' + CAST ( utl_pp_schedule_rate.sched_rate_id AS nvarchar(10)) + N'.G',
		CONVERT (nchar (8) , COALESCE ( utl_pp_schedule_rate.start_date , '9999-12-31') , 112),
		CONVERT (nchar (8) , COALESCE ( utl_pp_schedule_rate.end_date , '9999-12-31') , 112),
		COALESCE ( utl_pp_schedule_rate.band_start , 0.00),
		COALESCE ( utl_pp_schedule_rate.band_end , 999999999) ,
		COALESCE ( utl_pp_schedule_rate.unit_rate , 0.00),
		COALESCE ( utl_pp_schedule_rate.minimum_charge , 0.00),
		CAST ( utl_pp_schedule_type.sched_type_desc AS nvarchar (100)),
		CAST ( utl_pp_schedule_rate.invoice_desc AS nvarchar (100))
	  FROM /* Staging */ lumo.utl_pp_schedule INNER JOIN applicablePricePlans AS _applicablePricePlans ON _applicablePricePlans.sched_id = utl_pp_schedule.sched_id INNER JOIN /* Staging */ lumo.utl_pp_schedule_rate ON utl_pp_schedule_rate.sched_id = utl_pp_schedule.sched_id INNER JOIN /* Dimensional */ lumo.DimPricePlan AS _DimPricePlan ON _DimPricePlan.PricePlanKey = N'USAGE.' + CAST ( utl_pp_schedule.price_plan_id AS nvarchar(10)) + N'.G' AND _DimPricePlan.Meta_IsCurrent = 1 INNER JOIN /* Dimensional */ lumo.DimUnitType AS _DimUnitType ON _DimUnitType.UnitTypeName = N'Days'AND _DimUnitType.Meta_IsCurrent = 1 INNER JOIN /* Staging */ lumo.utl_pp_schedule_type ON utl_pp_schedule_type.sched_type_id = utl_pp_schedule.sched_type_id WHERE utl_pp_schedule.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_pp_schedule_rate.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _DimPricePlan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;