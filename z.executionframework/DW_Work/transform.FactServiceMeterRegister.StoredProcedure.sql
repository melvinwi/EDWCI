USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [transform].[FactServiceMeterRegister]
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
 
	INSERT INTO temp.FactServiceMeterRegister (
		FactServiceMeterRegister.ServiceId,
		FactServiceMeterRegister.MeterRegisterId,
		FactServiceMeterRegister.RegisterRelationshipCounter)
	  SELECT
		_DimService.ServiceId,
		_DimMeterRegister.MeterRegisterId,
		/* utl_meter.meter_id */ 1
	  FROM DW_Staging.orion.utl_meter INNER JOIN DW_Dimensional.DW.DimService AS _DimService ON _DimService.ServiceKey = CAST(utl_meter.site_id AS int) AND _DimService.Meta_IsCurrent = 1 INNER JOIN DW_Dimensional.DW.DimMeterRegister AS _DimMeterRegister ON _DimMeterRegister.MeterRegisterKey = CAST(utl_meter.meter_id AS int) AND _DimMeterRegister.Meta_IsCurrent = 1 WHERE (utl_meter.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _DimService.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _DimMeterRegister.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID);
 
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
CREATE PROCEDURE [transform].[FactServiceMeterRegister]
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
 
	INSERT INTO temp.FactServiceMeterRegister (
		FactServiceMeterRegister.ServiceId,
		FactServiceMeterRegister.MeterRegisterId,
		FactServiceMeterRegister.RegisterRelationshipCounter)
	  SELECT
		_DimService.ServiceId,
		_DimMeterRegister.MeterRegisterId,
		/* utl_meter.meter_id */ 1
	  FROM DW_Staging.orion.utl_meter INNER JOIN DW_Dimensional.DW.DimService AS _DimService ON _DimService.ServiceKey = CAST(utl_meter.site_id AS int) AND _DimService.Meta_IsCurrent = 1 INNER JOIN DW_Dimensional.DW.DimMeterRegister AS _DimMeterRegister ON _DimMeterRegister.MeterRegisterKey = CAST(utl_meter.meter_id AS int) AND _DimMeterRegister.Meta_IsCurrent = 1 WHERE (utl_meter.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _DimService.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _DimMeterRegister.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID);
 
SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;
 
END;

GO
