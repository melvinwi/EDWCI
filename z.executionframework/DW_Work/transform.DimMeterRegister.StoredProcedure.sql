USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [transform].[DimMeterRegister]
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

    INSERT INTO temp.DimMeterRegister (
    DimMeterRegister.MeterRegisterKey,
    DimMeterRegister.MeterMarketSerialNumber,
    DimMeterRegister.MeterSystemSerialNumber,
    DimMeterRegister.MeterServiceType,
    DimMeterRegister.RegisterBillingType,
    DimMeterRegister.RegisterBillingTypeCode,
    DimMeterRegister.RegisterClass,
    DimMeterRegister.RegisterCreationDate,
    DimMeterRegister.RegisterEstimatedDailyConsumption,
    DimMeterRegister.RegisterMarketIdentifier,
    DimMeterRegister.RegisterSystemIdentifer,
    DimMeterRegister.RegisterMultiplier,
    DimMeterRegister.RegisterNetworkTariffCode,
    DimMeterRegister.RegisterReadDirection,
    DimMeterRegister.RegisterStatus,
    DimMeterRegister.RegisterVirtualStartDate,
    DimMeterRegister.RegisterVirtualType) 
    SELECT
    CAST ( utl_meter.meter_id AS int) ,
    CAST (COALESCE ( utl_meter_header.meter_serial , utl_meter.market_meter_code, utl_meter_header.meter_code, utl_meter.meter_code) AS nvarchar (50)) ,
    CAST ( utl_meter.meter_code AS nvarchar (50)) ,
    CAST (CASE utl_meter_class.seq_product_type_id
          WHEN '1' THEN 'Internet'
          WHEN '2' THEN 'Electricity'
          WHEN '3' THEN 'Gas'
          WHEN '7' THEN 'Telco'
              ELSE NULL
          END AS nvarchar (11)) ,
    CAST ( utl_meter_type.meter_type_desc AS nvarchar (100)) ,
    CAST ( utl_meter_type.meter_type_code AS nchar (10)) ,
    CAST ( utl_meter_class.meter_class_desc AS nvarchar (40)) ,
    utl_meter.insert_datetime,
    utl_meter.est_daily_consumption,
    CAST (COALESCE ( utl_meter.market_meter_register , utl_meter.meter_register) AS nchar (10)) ,
    CAST ( utl_meter.meter_register AS nchar (10)) ,
    utl_meter.multiplier,
    CAST ( utl_meter.network_tariff_code AS nvarchar (20)) ,
    CAST (   
    CASE WHEN LEFT(utl_meter.market_meter_register,1) = 'B' THEN 'Import'
         WHEN LEFT(utl_meter.market_meter_register,1) = 'K' THEN 'Import'
	    WHEN utl_price_class.import = 'Y'                  THEN 'Import'
              ELSE 'Export'
          END AS nchar (6)) ,
    CAST (CASE utl_meter.meter_status_id
          WHEN 1 THEN 'Active'
          WHEN 2 THEN 'Inactive'
              ELSE NULL
          END AS nchar (8)) ,
    CASE
    WHEN utl_virtual_meter_type.virtual_meter_type_desc IS NOT NULL
    THEN utl_meter.vm_start_date END,
    CAST (CASE
          WHEN utl_virtual_meter_type.virtual_meter_type_desc IS NULL THEN 'Physical'
              ELSE CONCAT ('Virtual - ', utl_virtual_meter_type.virtual_meter_type_desc) 
          END AS nvarchar (20)) 
      FROM
           DW_Staging.orion.utl_meter LEFT JOIN DW_Staging.orion.utl_meter_header
           ON utl_meter_header.meter_header_id = utl_meter.meter_header_id
                                      INNER JOIN DW_Staging.orion.utl_meter_type
           ON utl_meter_type.meter_type_id = utl_meter.meter_type_id
		 						INNER JOIN DW_Staging.orion.utl_price_class
							 ON utl_price_class.price_class_id = utl_meter_type.price_class_id
                                      INNER JOIN DW_Staging.orion.utl_meter_class
           ON utl_meter_class.meter_class_id = utl_meter_type.meter_class_id
                                      LEFT JOIN DW_Staging.orion.utl_virtual_meter_type
           ON utl_virtual_meter_type.virtual_meter_type_id = utl_meter.virtual_meter_type_id
      WHERE utl_meter.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
        OR utl_meter_header.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
        OR utl_meter_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
        OR utl_meter_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
        OR utl_virtual_meter_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

    SELECT 0 AS ExtractRowCount,
           @@ROWCOUNT AS InsertRowCount,
           0 AS UpdateRowCount,
           0 AS DeleteRowCount,
           0 AS ErrorRowCount;

END;

GO
