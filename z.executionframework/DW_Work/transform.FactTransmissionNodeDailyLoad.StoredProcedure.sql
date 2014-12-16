USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [transform].[FactTransmissionNodeDailyLoad]
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

	;WITH dimTransmissionNode AS (SELECT DimTransmissionNode.TransmissionNodeId, DimTransmissionNode.TransmissionNodeIdentity, ROW_NUMBER() OVER (PARTITION BY DimTransmissionNode.TransmissionNodeIdentity ORDER BY DimTransmissionNode.TransmissionNodeKey DESC) AS recency FROM DW_Dimensional.DW.DimTransmissionNode)
	INSERT INTO temp.FactTransmissionNodeDailyLoad (
		FactTransmissionNodeDailyLoad.TransmissionNodeId,
		FactTransmissionNodeDailyLoad.SettlementDateId,
		FactTransmissionNodeDailyLoad.SettlementRun,
		FactTransmissionNodeDailyLoad.Region,
		FactTransmissionNodeDailyLoad.ImportGrossEnergy,
		FactTransmissionNodeDailyLoad.ExportGrossEnergy,
		FactTransmissionNodeDailyLoad.ImportNetEnergy,
		FactTransmissionNodeDailyLoad.ExportNetEnergy,
		FactTransmissionNodeDailyLoad.ImportReactivePower,
		FactTransmissionNodeDailyLoad.ExportReactivePower,
		FactTransmissionNodeDailyLoad.SettlementAmount,
		FactTransmissionNodeDailyLoad.MeterRun,
		FactTransmissionNodeDailyLoad.MeteringDataAgent,
		FactTransmissionNodeDailyLoad.TransmissionNodeDailyLoadKey)
	  SELECT
		COALESCE( _dimTransmissionNode.TransmissionNodeId , 1),
		CONVERT(NCHAR(8), Settlement_CPDATA.SettlementDate , 112),
		Settlement_CPDATA.VersionNo,
		MAX(ISNULL( Settlement_CPDATA.RegionId , '')),
		SUM(ISNULL( Settlement_CPDATA.IgEnergy , 0.0)),
		SUM(ISNULL( Settlement_CPDATA.XgEnergy , 0.0)),
		SUM(ISNULL( Settlement_CPDATA.InEnergy , 0.0)),
		SUM(ISNULL( Settlement_CPDATA.XnEnergy , 0.0)),
		SUM(ISNULL( Settlement_CPDATA.Ipower , 0.0)),
		SUM(ISNULL( Settlement_CPDATA.Xpower , 0.0)),
		SUM(ISNULL( Settlement_CPDATA.EP , 0.0)),
		MAX(ISNULL( Settlement_CPDATA.MeterRunNo , 0)),
		MAX(ISNULL( Settlement_CPDATA.MDA , '')),
		CONVERT(NCHAR(8), Settlement_CPDATA.SettlementDate , 112) + '.' + CAST(Settlement_CPDATA.VersionNo AS NVARCHAR(10)) + '.' + Settlement_CPDATA.ParticipantId + '.' + Settlement_CPDATA.TcpId + '.' + Settlement_CPDATA.MDA
	  FROM DW_Staging.AEMO.Settlement_CPDATA LEFT JOIN dimTransmissionNode AS _dimTransmissionNode ON _dimTransmissionNode.TransmissionNodeIdentity = Settlement_CPDATA.TcpId AND _dimTransmissionNode.recency = 1 WHERE Settlement_CPDATA.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID GROUP BY Settlement_CPDATA.SettlementDate, Settlement_CPDATA.VersionNo, Settlement_CPDATA.ParticipantId, Settlement_CPDATA.TcpId, Settlement_CPDATA.MDA, _dimTransmissionNode.TransmissionNodeId;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;

GO
