CREATE PROCEDURE lumo.TRANSFORM_FactServiceDailyLoad
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

	;WITH dimService AS (SELECT DimService.ServiceId, LEFT(DimService.MarketIdentifier, 10) AS MarketIdentifier, ROW_NUMBER() OVER (PARTITION BY LEFT(DimService.MarketIdentifier, 10) ORDER BY DimService.Meta_EffectiveStartDate DESC) AS recency FROM /* Dimensional */ [schema].DimService WHERE DimService.ServiceType = N'Electricity'), dimTransmissionNode AS (SELECT DimTransmissionNode.TransmissionNodeId, DimTransmissionNode.TransmissionNodeIdentity, ROW_NUMBER() OVER (PARTITION BY DimTransmissionNode.TransmissionNodeIdentity ORDER BY DimTransmissionNode.TransmissionNodeKey DESC) AS recency FROM /* Dimensional */ lumo.DimTransmissionNode)
	INSERT INTO lumo.FactServiceDailyLoad (
		FactServiceDailyLoad.ServiceId,
		FactServiceDailyLoad.TransmissionNodeId,
		FactServiceDailyLoad.TransmissionNodeIdentity,
		FactServiceDailyLoad.MarketIdentifier,
		FactServiceDailyLoad.SettlementDateId,
		FactServiceDailyLoad.SettlementCase,
		FactServiceDailyLoad.DatastreamType,
		FactServiceDailyLoad.ReadType,
		FactServiceDailyLoad.TotalEnergy,
		FactServiceDailyLoad.ServiceDailyLoadKey)
	  SELECT
		COALESCE( _dimService.ServiceId , -1),
		COALESCE( _dimTransmissionNode.TransmissionNodeId , -1),
		Level2_CSVData.TNI,
		Level2_CSVData.NMI,
		CONVERT(NCHAR(8), ISNULL( Level2_CSVData.SettlementDate , '9999-12-31'), 112),
		Level2_Transaction.SettlementCase,
		CASE Level2_CSVData.DataType WHEN 'I' THEN 'Interval' WHEN 'C' THEN 'Basic' WHEN 'P' THEN 'Profile Data' WHEN '1' THEN 'Non-Market Active Import' WHEN '2' THEN 'Non-Market Active' WHEN '3' THEN 'Non-Market Reactive Import' WHEN '4' THEN 'Non-Market Reactive' END,
		CASE Level2_CSVData.MSATS_Est WHEN 'Y' THEN 'Estimate' ELSE 'Actual' END,
		Level2_CSVData.Total_Energy,
		CAST( Level2_Transaction.SettlementCase AS VARCHAR(10)) + '.' + Level2_CSVData.NMI + '.' + CAST(Level2_CSVData.SeqNo AS VARCHAR(10))
	  FROM /* Staging */ lumo.Level2_CSVData INNER JOIN /* Staging */ lumo.Level2_Transaction ON Level2_Transaction.transactionID = Level2_CSVData.transactionID LEFT JOIN dimService AS _dimService ON _dimService.MarketIdentifier = Level2_CSVData.NMI AND _dimService.recency = 1 LEFT JOIN dimTransmissionNode AS _dimTransmissionNode ON _dimTransmissionNode.TransmissionNodeIdentity = Level2_CSVData.TNI AND _dimTransmissionNode.recency = 1 WHERE Level2_CSVData.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;