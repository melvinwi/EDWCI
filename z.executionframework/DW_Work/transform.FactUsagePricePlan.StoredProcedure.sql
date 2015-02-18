USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [transform].[FactUsagePricePlan]
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

    WITH pricePlan
        AS (SELECT utl_account_price_plan.seq_product_item_id,
                   utl_price_plan.price_plan_id,
                   utl_price_plan.price_plan_code,
                   utl_price_plan.green_percent,
                   CASE
                   WHEN utl_account_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
                     OR utl_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
                     OR utl_price_category.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID THEN 1
                       ELSE 0
                   END AS Meta_HasChanged,
                   ROW_NUMBER () OVER (PARTITION BY utl_account_price_plan.seq_product_item_id ORDER BY utl_account_price_plan.start_date DESC) AS recency
              FROM
                   DW_Staging.orion.utl_account_price_plan INNER JOIN DW_Staging.orion.utl_price_plan
                   ON utl_price_plan.price_plan_id = utl_account_price_plan.price_plan_id
                                                           LEFT JOIN DW_Staging.orion.utl_price_category
                   ON utl_price_category.price_category_id = utl_price_plan.price_category_id
              WHERE (utl_account_price_plan.end_date IS NULL
                  OR utl_account_price_plan.end_date > GETDATE ()) 
                AND utl_account_price_plan.start_date < GETDATE ()) , productKey
        AS (SELECT nc_product_item.seq_product_item_id,
                   CASE
                   WHEN nc_product_item.tco_id <> 1 THEN CAST (nc_product_item.tco_id AS nvarchar (100)) 
                   WHEN utl_contract_term.contract_term_desc = 'Lumo Express'
                     OR utl_contract_term.contract_term_desc = 'Lumo Express 2012' THEN N'Lumo Express'
                   WHEN utl_contract_term.contract_term_desc = 'Lumo Velocity' THEN N'Lumo Velocity'
                   WHEN utl_contract_term.contract_term_desc = 'Lumo Virgin Staff' THEN N'Lumo Virgin Staff'
                   WHEN utl_contract_term.contract_term_desc = 'Lumo Movers' THEN N'Lumo Movers'
                   WHEN utl_contract_term.contract_term_desc = 'Lumo Basic' THEN N'Lumo Basic'
                   WHEN _pricePlan.green_percent = '0.1' THEN N'Lumo Life 10'
                   WHEN _pricePlan.green_percent = '1' THEN N'Lumo Life 100'
                   WHEN LEFT (_pricePlan.price_plan_code, 3) IN ('OCC', 'STD') THEN N'Lumo Options'
                       ELSE N'Lumo Advantage'
                   END AS ProductKey,
                   CASE
                   WHEN nc_product_item.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
                     OR utl_contract_term.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
                     OR _pricePlan.Meta_HasChanged = 1 THEN 1
                       ELSE 0
                   END AS Meta_HasChanged
              FROM
                   DW_Staging.orion.nc_product_item LEFT JOIN DW_Staging.orion.utl_contract_term
                   ON utl_contract_term.contract_term_id = nc_product_item.contract_term_id
                                                    LEFT JOIN pricePlan AS _pricePlan
                   ON _pricePlan.seq_product_item_id = nc_product_item.seq_product_item_id
                  AND _pricePlan.recency = 1) 
        INSERT INTO temp.FactUsagePricePlan (
        FactUsagePricePlan.AccountId,
        FactUsagePricePlan.ServiceId,
        FactUsagePricePlan.ProductId,
        FactUsagePricePlan.PricePlanId,
        FactUsagePricePlan.MeterRegisterId,
        FactUsagePricePlan.ContractFRMPDateId,
        FactUsagePricePlan.ContractTerminatedDateId,
        FactUsagePricePlan.ContractStatus,
        FactUsagePricePlan.UsagePricePlanStartDateId,
        FactUsagePricePlan.UsagePricePlanEndDateId,
        FactUsagePricePlan.UsagePricePlanKey) 
        SELECT
        _DimAccount.AccountId,
        _DimService.ServiceId,
        COALESCE ( _DimProduct.ProductId, -1) ,
        COALESCE ( _DimPricePlan.PricePlanId, -1) ,
        _DimMeterRegister.MeterRegisterId,
        CONVERT (nchar (8) , COALESCE ( nc_product_item.frmp_date , '9999-12-31') , 112) ,
        CASE
        WHEN utl_account_status.accnt_status_class_id = 1 THEN
        CONVERT (nchar (8) , COALESCE ( nc_product_item.date_terminated , nc_product_item.accnt_status_date, '9999-12-31') , 112) 
        WHEN  utl_account_status.accnt_status_class_id = 2 THEN 99991231
            ELSE CONVERT (nchar (8) , COALESCE ( nc_product_item.date_terminated , '9999-12-31') , 112) 
        END,
        CAST (CASE utl_account_status.accnt_status_class_id
              WHEN 2 THEN N'Open'
              WHEN 3 THEN N'Pending'
              WHEN 4 THEN N'Error'
                  ELSE    N'Closed'
              END AS nchar (10)) ,
        CONVERT (nchar (8) , COALESCE ( utl_accnt_meter_price_plan.start_date , '9999-12-31') , 112) ,
        CONVERT (nchar (8) , COALESCE ( utl_accnt_meter_price_plan.end_date , '9999-12-31') , 112) ,
        CAST(utl_accnt_meter_price_plan.accnt_meter_price_plan_id AS nvarchar(10))
          FROM
               DW_Staging.orion.utl_accnt_meter_price_plan INNER JOIN DW_Staging.orion.nc_product_item
               ON nc_product_item.seq_product_item_id = utl_accnt_meter_price_plan.seq_product_item_id
                                                           INNER JOIN DW_Staging.orion.nc_product
               ON nc_product.seq_product_id = nc_product_item.seq_product_id
                                                           INNER JOIN DW_Dimensional.DW.DimAccount AS _DimAccount
               ON _DimAccount.AccountKey = nc_product.seq_party_id
              AND _DimAccount.Meta_IsCurrent = 1
                                                           INNER JOIN DW_Dimensional.DW.DimService AS _DimService
               ON _DimService.ServiceKey = CAST (nc_product_item.site_id AS int) 
              AND _DimService.Meta_IsCurrent = 1
                                                           INNER JOIN productKey AS _productKey
               ON _productKey.seq_product_item_id = nc_product_item.seq_product_item_id
                                                           LEFT JOIN DW_Dimensional.DW.DimProduct AS _DimProduct
               ON _DimProduct.ProductKey = _productKey.ProductKey
              AND _DimProduct.Meta_IsCurrent = 1
                                                           LEFT JOIN DW_Dimensional.DW.DimPricePlan AS _DimPricePlan
               ON _DimPricePlan.PricePlanKey = N'USAGE.' + CAST (utl_accnt_meter_price_plan.pp_simple_sched_id AS nvarchar (10)) 
              AND _DimPricePlan.Meta_IsCurrent = 1
                                                           INNER JOIN DW_Dimensional.DW.DimMeterRegister AS _DimMeterRegister
               ON _DimMeterRegister.MeterRegisterKey = utl_accnt_meter_price_plan.meter_id
              AND _DimMeterRegister.Meta_IsCurrent = 1
                                                           LEFT JOIN DW_Staging.orion.utl_account_status
               ON utl_account_status.accnt_status_id = nc_product_item.accnt_status_id
          WHERE (utl_accnt_meter_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR nc_product.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR nc_product_item.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _productKey.Meta_HasChanged = 1
             OR utl_account_status.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _DimAccount.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _DimService.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _DimProduct.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _DimPricePlan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _DimMeterRegister.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID);

    SELECT 0 AS ExtractRowCount,
           @@ROWCOUNT AS InsertRowCount,
           0 AS UpdateRowCount,
           0 AS DeleteRowCount,
           0 AS ErrorRowCount;

END;




GO
USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [transform].[FactUsagePricePlan]
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

    WITH pricePlan
        AS (SELECT utl_account_price_plan.seq_product_item_id,
                   utl_price_plan.price_plan_id,
                   utl_price_plan.price_plan_code,
                   utl_price_plan.green_percent,
                   CASE
                   WHEN utl_account_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
                     OR utl_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
                     OR utl_price_category.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID THEN 1
                       ELSE 0
                   END AS Meta_HasChanged,
                   ROW_NUMBER () OVER (PARTITION BY utl_account_price_plan.seq_product_item_id ORDER BY utl_account_price_plan.start_date DESC) AS recency
              FROM
                   DW_Staging.orion.utl_account_price_plan INNER JOIN DW_Staging.orion.utl_price_plan
                   ON utl_price_plan.price_plan_id = utl_account_price_plan.price_plan_id
                                                           LEFT JOIN DW_Staging.orion.utl_price_category
                   ON utl_price_category.price_category_id = utl_price_plan.price_category_id
              WHERE (utl_account_price_plan.end_date IS NULL
                  OR utl_account_price_plan.end_date > GETDATE ()) 
                AND utl_account_price_plan.start_date < GETDATE ()) , productKey
        AS (SELECT nc_product_item.seq_product_item_id,
                   CASE
                   WHEN nc_product_item.tco_id <> 1 THEN CAST (nc_product_item.tco_id AS nvarchar (100)) 
                   WHEN utl_contract_term.contract_term_desc = 'Lumo Express'
                     OR utl_contract_term.contract_term_desc = 'Lumo Express 2012' THEN N'Lumo Express'
                   WHEN utl_contract_term.contract_term_desc = 'Lumo Velocity' THEN N'Lumo Velocity'
                   WHEN utl_contract_term.contract_term_desc = 'Lumo Virgin Staff' THEN N'Lumo Virgin Staff'
                   WHEN utl_contract_term.contract_term_desc = 'Lumo Movers' THEN N'Lumo Movers'
                   WHEN utl_contract_term.contract_term_desc = 'Lumo Basic' THEN N'Lumo Basic'
                   WHEN _pricePlan.green_percent = '0.1' THEN N'Lumo Life 10'
                   WHEN _pricePlan.green_percent = '1' THEN N'Lumo Life 100'
                   WHEN LEFT (_pricePlan.price_plan_code, 3) IN ('OCC', 'STD') THEN N'Lumo Options'
                       ELSE N'Lumo Advantage'
                   END AS ProductKey,
                   CASE
                   WHEN nc_product_item.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
                     OR utl_contract_term.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
                     OR _pricePlan.Meta_HasChanged = 1 THEN 1
                       ELSE 0
                   END AS Meta_HasChanged
              FROM
                   DW_Staging.orion.nc_product_item LEFT JOIN DW_Staging.orion.utl_contract_term
                   ON utl_contract_term.contract_term_id = nc_product_item.contract_term_id
                                                    LEFT JOIN pricePlan AS _pricePlan
                   ON _pricePlan.seq_product_item_id = nc_product_item.seq_product_item_id
                  AND _pricePlan.recency = 1) 
        INSERT INTO temp.FactUsagePricePlan (
        FactUsagePricePlan.AccountId,
        FactUsagePricePlan.ServiceId,
        FactUsagePricePlan.ProductId,
        FactUsagePricePlan.PricePlanId,
        FactUsagePricePlan.MeterRegisterId,
        FactUsagePricePlan.ContractFRMPDateId,
        FactUsagePricePlan.ContractTerminatedDateId,
        FactUsagePricePlan.ContractStatus,
        FactUsagePricePlan.UsagePricePlanStartDateId,
        FactUsagePricePlan.UsagePricePlanEndDateId,
        FactUsagePricePlan.UsagePricePlanKey) 
        SELECT
        _DimAccount.AccountId,
        _DimService.ServiceId,
        COALESCE ( _DimProduct.ProductId, -1) ,
        COALESCE ( _DimPricePlan.PricePlanId, -1) ,
        _DimMeterRegister.MeterRegisterId,
        CONVERT (nchar (8) , COALESCE ( nc_product_item.frmp_date , '9999-12-31') , 112) ,
        CASE utl_account_status.accnt_status_class_id
        WHEN 1 THEN
        CONVERT (nchar (8) , COALESCE ( nc_product_item.date_terminated , nc_product_item.accnt_status_date, '9999-12-31') , 112) 
        WHEN 2 THEN 99991231
            ELSE CONVERT (nchar (8) , COALESCE ( nc_product_item.date_terminated , '9999-12-31') , 112) 
        END,
        CAST (CASE utl_account_status.accnt_status_class_id
              WHEN 2 THEN N'Open'
              WHEN 3 THEN N'Pending'
              WHEN 4 THEN N'Error'
                  ELSE    N'Closed'
              END AS nchar (10)) ,
        CONVERT (nchar (8) , COALESCE ( utl_accnt_meter_price_plan.start_date , '9999-12-31') , 112) ,
        CASE utl_account_status.accnt_status_class_id
        WHEN 1 THEN
        CONVERT (nchar (8) , COALESCE ( utl_accnt_meter_price_plan.end_date, nc_product_item.date_terminated , nc_product_item.accnt_status_date, '9999-12-31') , 112) 
        WHEN 2 THEN
	   CONVERT (nchar (8) , COALESCE ( utl_accnt_meter_price_plan.end_date , '9999-12-31') , 112)
            ELSE CONVERT (nchar (8) , COALESCE ( utl_accnt_meter_price_plan.end_date, nc_product_item.date_terminated , '9999-12-31') , 112) 
        END,
        CAST(utl_accnt_meter_price_plan.accnt_meter_price_plan_id AS nvarchar(10))
          FROM
               DW_Staging.orion.utl_accnt_meter_price_plan INNER JOIN DW_Staging.orion.nc_product_item
               ON nc_product_item.seq_product_item_id = utl_accnt_meter_price_plan.seq_product_item_id
                                                           INNER JOIN DW_Staging.orion.nc_product
               ON nc_product.seq_product_id = nc_product_item.seq_product_id
                                                           INNER JOIN DW_Dimensional.DW.DimAccount AS _DimAccount
               ON _DimAccount.AccountKey = nc_product.seq_party_id
              AND _DimAccount.Meta_IsCurrent = 1
                                                           INNER JOIN DW_Dimensional.DW.DimService AS _DimService
               ON _DimService.ServiceKey = CAST (nc_product_item.site_id AS int) 
              AND _DimService.Meta_IsCurrent = 1
                                                           INNER JOIN productKey AS _productKey
               ON _productKey.seq_product_item_id = nc_product_item.seq_product_item_id
                                                           LEFT JOIN DW_Dimensional.DW.DimProduct AS _DimProduct
               ON _DimProduct.ProductKey = _productKey.ProductKey
              AND _DimProduct.Meta_IsCurrent = 1
                                                           LEFT JOIN DW_Dimensional.DW.DimPricePlan AS _DimPricePlan
               ON _DimPricePlan.PricePlanKey = N'USAGE.' + CAST (utl_accnt_meter_price_plan.pp_simple_sched_id AS nvarchar (10)) 
              AND _DimPricePlan.Meta_IsCurrent = 1
                                                           INNER JOIN DW_Dimensional.DW.DimMeterRegister AS _DimMeterRegister
               ON _DimMeterRegister.MeterRegisterKey = utl_accnt_meter_price_plan.meter_id
              AND _DimMeterRegister.Meta_IsCurrent = 1
                                                           LEFT JOIN DW_Staging.orion.utl_account_status
               ON utl_account_status.accnt_status_id = nc_product_item.accnt_status_id
          WHERE (utl_accnt_meter_price_plan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR nc_product.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR nc_product_item.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _productKey.Meta_HasChanged = 1
             OR utl_account_status.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _DimAccount.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _DimService.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _DimProduct.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _DimPricePlan.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
             OR _DimMeterRegister.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID);

    SELECT 0 AS ExtractRowCount,
           @@ROWCOUNT AS InsertRowCount,
           0 AS UpdateRowCount,
           0 AS DeleteRowCount,
           0 AS ErrorRowCount;

END;

GO
