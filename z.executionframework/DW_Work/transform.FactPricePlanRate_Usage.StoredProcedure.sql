USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [transform].[FactPricePlanRate_Usage]
@TaskExecutionInstanceID int
,
@LatestSuccessfulTaskExecutionInstanceID int
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
    
    -- No steps
        INSERT INTO temp.FactPricePlanRate (
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
        COALESCE ( _DimUnitType.UnitTypeId, -1),
        N'USAGE.' + CAST ( utl_pp_simple_schedule_rate.pp_simple_sched_id AS nvarchar(20)) + '.' + CONVERT (nchar (8) , COALESCE ( utl_pp_simple_schedule_rate.start_date , '9999-12-31') , 112) + '.0',
        CONVERT (nchar (8) , COALESCE ( utl_pp_simple_schedule_rate.start_date , '9999-12-31') , 112) ,
        CONVERT (nchar (8) , COALESCE ( utl_pp_simple_schedule_rate.end_date , '9999-12-31') , 112) ,
        0.00,
        999999999,
        utl_pp_simple_schedule_rate.price_step0,
        COALESCE (utl_pp_simple_schedule_rate.minimum_charge_per_day, 0.00) ,
        CAST ( utl_pp_schedule_type.sched_type_desc AS nvarchar (100)) ,
        CAST ( utl_pp_simple_schedule.invoice_desc AS nvarchar (100)) 
          FROM
               DW_Staging.orion.utl_pp_simple_schedule INNER JOIN DW_Staging.orion.utl_pp_simple_schedule_rate
               ON utl_pp_simple_schedule_rate.pp_simple_sched_id = utl_pp_simple_schedule.pp_simple_sched_id
											 INNER JOIN DW_Staging.orion.utl_pp_schedule_type
               ON utl_pp_simple_schedule.sched_type_id = utl_pp_schedule_type.sched_type_id
                                                INNER JOIN DW_Dimensional.DW.DimPricePlan AS _DimPricePlan
               ON _DimPricePlan.PricePlanKey = N'USAGE.' + CAST ( utl_pp_simple_schedule.pp_simple_sched_id AS nvarchar(20))
              AND _DimPricePlan.Meta_IsCurrent = 1
                                                LEFT JOIN DW_Dimensional.DW.DimUnitType AS _DimUnitType
               ON _DimUnitType.UnitTypeName = CASE utl_pp_schedule_type.seq_product_type_id WHEN '2' THEN N'Kilowatt Hours'
                  ELSE NULL END
              AND _DimUnitType.Meta_IsCurrent = 1
          WHERE utl_pp_simple_schedule_rate.price_step0 IS NOT NULL AND		
		(utl_pp_simple_schedule.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR utl_pp_simple_schedule_rate.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _DimPricePlan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID);


-- Step 1
	INSERT INTO temp.FactPricePlanRate (
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
        COALESCE ( _DimUnitType.UnitTypeId, -1),
        N'USAGE.' + CAST ( utl_pp_simple_schedule_rate.pp_simple_sched_id AS nvarchar(20)) + '.' + CONVERT (nchar (8) , COALESCE ( utl_pp_simple_schedule_rate.start_date , '9999-12-31') , 112) + '.1',
        CONVERT (nchar (8) , COALESCE ( utl_pp_simple_schedule_rate.start_date , '9999-12-31') , 112) ,
        CONVERT (nchar (8) , COALESCE ( utl_pp_simple_schedule_rate.end_date , '9999-12-31') , 112) ,
        0.00,
        COALESCE(units_step1,999999999),
        utl_pp_simple_schedule_rate.price_step1,
        COALESCE (utl_pp_simple_schedule_rate.minimum_charge_per_day, 0.00) ,
        CAST ( utl_pp_schedule_type.sched_type_desc AS nvarchar (100)) ,
        CAST ( utl_pp_simple_schedule.invoice_desc AS nvarchar (100)) 
          FROM
               DW_Staging.orion.utl_pp_simple_schedule INNER JOIN DW_Staging.orion.utl_pp_simple_schedule_rate
               ON utl_pp_simple_schedule_rate.pp_simple_sched_id = utl_pp_simple_schedule.pp_simple_sched_id
											 INNER JOIN DW_Staging.orion.utl_pp_schedule_type
               ON utl_pp_simple_schedule.sched_type_id = utl_pp_schedule_type.sched_type_id
                                                INNER JOIN DW_Dimensional.DW.DimPricePlan AS _DimPricePlan
               ON _DimPricePlan.PricePlanKey = N'USAGE.' + CAST ( utl_pp_simple_schedule.pp_simple_sched_id AS nvarchar(20))
              AND _DimPricePlan.Meta_IsCurrent = 1
                                                LEFT JOIN DW_Dimensional.DW.DimUnitType AS _DimUnitType
               ON _DimUnitType.UnitTypeName = CASE utl_pp_schedule_type.seq_product_type_id WHEN '2' THEN N'Kilowatt Hours'
                  ELSE NULL END
              AND _DimUnitType.Meta_IsCurrent = 1
          WHERE utl_pp_simple_schedule_rate.price_step1 IS NOT NULL AND		
		(utl_pp_simple_schedule.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR utl_pp_simple_schedule_rate.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _DimPricePlan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID);

-- Step 2
	INSERT INTO temp.FactPricePlanRate (
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
        COALESCE ( _DimUnitType.UnitTypeId, -1),
        N'USAGE.' + CAST ( utl_pp_simple_schedule_rate.pp_simple_sched_id AS nvarchar(20)) + '.' + CONVERT (nchar (8) , COALESCE ( utl_pp_simple_schedule_rate.start_date , '9999-12-31') , 112) + '.2',
        CONVERT (nchar (8) , COALESCE ( utl_pp_simple_schedule_rate.start_date , '9999-12-31') , 112) ,
        CONVERT (nchar (8) , COALESCE ( utl_pp_simple_schedule_rate.end_date , '9999-12-31') , 112) ,
        units_step1,
        CASE WHEN units_step2 IS NULL THEN 999999999 ELSE
	   units_step1+units_step2 END,
        utl_pp_simple_schedule_rate.price_step2,
        COALESCE (utl_pp_simple_schedule_rate.minimum_charge_per_day, 0.00) ,
        CAST ( utl_pp_schedule_type.sched_type_desc AS nvarchar (100)) ,
        CAST ( utl_pp_simple_schedule.invoice_desc AS nvarchar (100)) 
             FROM
               DW_Staging.orion.utl_pp_simple_schedule INNER JOIN DW_Staging.orion.utl_pp_simple_schedule_rate
               ON utl_pp_simple_schedule_rate.pp_simple_sched_id = utl_pp_simple_schedule.pp_simple_sched_id
											 INNER JOIN DW_Staging.orion.utl_pp_schedule_type
               ON utl_pp_simple_schedule.sched_type_id = utl_pp_schedule_type.sched_type_id
                                                INNER JOIN DW_Dimensional.DW.DimPricePlan AS _DimPricePlan
               ON _DimPricePlan.PricePlanKey = N'USAGE.' + CAST ( utl_pp_simple_schedule.pp_simple_sched_id AS nvarchar(20))
              AND _DimPricePlan.Meta_IsCurrent = 1
                                                LEFT JOIN DW_Dimensional.DW.DimUnitType AS _DimUnitType
               ON _DimUnitType.UnitTypeName = CASE utl_pp_schedule_type.seq_product_type_id WHEN '2' THEN N'Kilowatt Hours'
                  ELSE NULL END
              AND _DimUnitType.Meta_IsCurrent = 1
          WHERE utl_pp_simple_schedule_rate.price_step2 IS NOT NULL AND		
		(utl_pp_simple_schedule.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR utl_pp_simple_schedule_rate.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _DimPricePlan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID);




		   -- Step 3
	INSERT INTO temp.FactPricePlanRate (
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
        COALESCE ( _DimUnitType.UnitTypeId, -1),
        N'USAGE.' + CAST ( utl_pp_simple_schedule_rate.pp_simple_sched_id AS nvarchar(20)) + '.' + CONVERT (nchar (8) , COALESCE ( utl_pp_simple_schedule_rate.start_date , '9999-12-31') , 112) + '.3',
        CONVERT (nchar (8) , COALESCE ( utl_pp_simple_schedule_rate.start_date , '9999-12-31') , 112) ,
        CONVERT (nchar (8) , COALESCE ( utl_pp_simple_schedule_rate.end_date , '9999-12-31') , 112) ,
        units_step1+units_step2,
        CASE WHEN units_step3 IS NULL THEN 999999999 ELSE
	   units_step1+units_step2+units_step3 END,
        utl_pp_simple_schedule_rate.price_step3,
        COALESCE (utl_pp_simple_schedule_rate.minimum_charge_per_day, 0.00) ,
        CAST ( utl_pp_schedule_type.sched_type_desc AS nvarchar (100)) ,
        CAST ( utl_pp_simple_schedule.invoice_desc AS nvarchar (100)) 
           FROM
               DW_Staging.orion.utl_pp_simple_schedule INNER JOIN DW_Staging.orion.utl_pp_simple_schedule_rate
               ON utl_pp_simple_schedule_rate.pp_simple_sched_id = utl_pp_simple_schedule.pp_simple_sched_id
											 INNER JOIN DW_Staging.orion.utl_pp_schedule_type
               ON utl_pp_simple_schedule.sched_type_id = utl_pp_schedule_type.sched_type_id
                                                INNER JOIN DW_Dimensional.DW.DimPricePlan AS _DimPricePlan
               ON _DimPricePlan.PricePlanKey = N'USAGE.' + CAST ( utl_pp_simple_schedule.pp_simple_sched_id AS nvarchar(20))
              AND _DimPricePlan.Meta_IsCurrent = 1
                                                LEFT JOIN DW_Dimensional.DW.DimUnitType AS _DimUnitType
               ON _DimUnitType.UnitTypeName = CASE utl_pp_schedule_type.seq_product_type_id WHEN '2' THEN N'Kilowatt Hours'
                  ELSE NULL END
              AND _DimUnitType.Meta_IsCurrent = 1
          WHERE utl_pp_simple_schedule_rate.price_step3 IS NOT NULL AND		
		(utl_pp_simple_schedule.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR utl_pp_simple_schedule_rate.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _DimPricePlan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID);




		   		   -- Step 4
	INSERT INTO temp.FactPricePlanRate (
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
        COALESCE ( _DimUnitType.UnitTypeId, -1),
        N'USAGE.' + CAST ( utl_pp_simple_schedule_rate.pp_simple_sched_id AS nvarchar(20)) + '.' + CONVERT (nchar (8) , COALESCE ( utl_pp_simple_schedule_rate.start_date , '9999-12-31') , 112) + '.4',
        CONVERT (nchar (8) , COALESCE ( utl_pp_simple_schedule_rate.start_date , '9999-12-31') , 112) ,
        CONVERT (nchar (8) , COALESCE ( utl_pp_simple_schedule_rate.end_date , '9999-12-31') , 112) ,
        units_step1+units_step2+units_step3,
        CASE WHEN units_step4 IS NULL THEN 999999999 ELSE
	   units_step1+units_step2+units_step3+units_step4 END,
        utl_pp_simple_schedule_rate.price_step4,
        COALESCE (utl_pp_simple_schedule_rate.minimum_charge_per_day, 0.00) ,
        CAST ( utl_pp_schedule_type.sched_type_desc AS nvarchar (100)) ,
        CAST ( utl_pp_simple_schedule.invoice_desc AS nvarchar (100)) 
          FROM
               DW_Staging.orion.utl_pp_simple_schedule INNER JOIN DW_Staging.orion.utl_pp_simple_schedule_rate
               ON utl_pp_simple_schedule_rate.pp_simple_sched_id = utl_pp_simple_schedule.pp_simple_sched_id
											 INNER JOIN DW_Staging.orion.utl_pp_schedule_type
               ON utl_pp_simple_schedule.sched_type_id = utl_pp_schedule_type.sched_type_id
                                                INNER JOIN DW_Dimensional.DW.DimPricePlan AS _DimPricePlan
               ON _DimPricePlan.PricePlanKey = N'USAGE.' + CAST ( utl_pp_simple_schedule.pp_simple_sched_id AS nvarchar(20))
              AND _DimPricePlan.Meta_IsCurrent = 1
                                                LEFT JOIN DW_Dimensional.DW.DimUnitType AS _DimUnitType
               ON _DimUnitType.UnitTypeName = CASE utl_pp_schedule_type.seq_product_type_id WHEN '2' THEN N'Kilowatt Hours'
                  ELSE NULL END
              AND _DimUnitType.Meta_IsCurrent = 1
          WHERE utl_pp_simple_schedule_rate.price_step4 IS NOT NULL AND		
		(utl_pp_simple_schedule.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR utl_pp_simple_schedule_rate.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _DimPricePlan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID);



		   		   		   -- Step 5
	INSERT INTO temp.FactPricePlanRate (
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
        COALESCE ( _DimUnitType.UnitTypeId, -1),
        N'USAGE.' + CAST ( utl_pp_simple_schedule_rate.pp_simple_sched_id AS nvarchar(20)) + '.' + CONVERT (nchar (8) , COALESCE ( utl_pp_simple_schedule_rate.start_date , '9999-12-31') , 112) + '.5',
        CONVERT (nchar (8) , COALESCE ( utl_pp_simple_schedule_rate.start_date , '9999-12-31') , 112) ,
        CONVERT (nchar (8) , COALESCE ( utl_pp_simple_schedule_rate.end_date , '9999-12-31') , 112) ,
        units_step1+units_step2+units_step3+units_step4,
        999999999,
        utl_pp_simple_schedule_rate.price_step5,
        COALESCE (utl_pp_simple_schedule_rate.minimum_charge_per_day, 0.00) ,
        CAST ( utl_pp_schedule_type.sched_type_desc AS nvarchar (100)) ,
        CAST ( utl_pp_simple_schedule.invoice_desc AS nvarchar (100)) 
            FROM
               DW_Staging.orion.utl_pp_simple_schedule INNER JOIN DW_Staging.orion.utl_pp_simple_schedule_rate
               ON utl_pp_simple_schedule_rate.pp_simple_sched_id = utl_pp_simple_schedule.pp_simple_sched_id
											 INNER JOIN DW_Staging.orion.utl_pp_schedule_type
               ON utl_pp_simple_schedule.sched_type_id = utl_pp_schedule_type.sched_type_id
                                                INNER JOIN DW_Dimensional.DW.DimPricePlan AS _DimPricePlan
               ON _DimPricePlan.PricePlanKey = N'USAGE.' + CAST ( utl_pp_simple_schedule.pp_simple_sched_id AS nvarchar(20))
              AND _DimPricePlan.Meta_IsCurrent = 1
                                                LEFT JOIN DW_Dimensional.DW.DimUnitType AS _DimUnitType
               ON _DimUnitType.UnitTypeName = CASE utl_pp_schedule_type.seq_product_type_id WHEN '2' THEN N'Kilowatt Hours'
                  ELSE NULL END
              AND _DimUnitType.Meta_IsCurrent = 1
          WHERE utl_pp_simple_schedule_rate.price_step5 IS NOT NULL AND		
		(utl_pp_simple_schedule.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR utl_pp_simple_schedule_rate.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _DimPricePlan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID);




    SELECT 0 AS ExtractRowCount,
           @@ROWCOUNT AS InsertRowCount,
           0 AS UpdateRowCount,
           0 AS DeleteRowCount,
           0 AS ErrorRowCount;

END;



GO
