CREATE PROCEDURE lumo.TRANSFORM_FactServiceMeterRegister
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

	INSERT INTO lumo.FactServiceMeterRegister (
		FactServiceMeterRegister.ServiceId,
		FactServiceMeterRegister.MeterRegisterId,
		FactServiceMeterRegister.RegisterRelationshipCounter)
	  SELECT
		_DimService.ServiceId,
		_DimMeterRegister.MeterRegisterId,
		/* utl_meter.meter_id */ 1
	  FROM /* Staging */ lumo.utl_meter INNER JOIN /* Dimensional */ lumo.DimService AS _DimService ON _DimService.ServiceKey = CAST(utl_meter.site_id AS int) AND _DimService.Meta_IsCurrent = 1 INNER JOIN /* Dimensional */ lumo.DimMeterRegister AS _DimMeterRegister ON _DimMeterRegister.MeterRegisterKey = CAST(utl_meter.meter_id AS int) AND _DimMeterRegister.Meta_IsCurrent = 1 WHERE (utl_meter.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _DimService.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _DimMeterRegister.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID);

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;