USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Views].[vTransmissionNodeDailyLoadHistorical]
AS
SELECT -- DimTransmissionNode
       DimTransmissionNode.TransmissionNodeIdentity,
       DimTransmissionNode.TransmissionNodeName,
       DimTransmissionNode.TransmissionNodeState,
       DimTransmissionNode.TransmissionNodeNetwork,
       DimTransmissionNode.TransmissionNodeServiceType,
       DimTransmissionNode.TransmissionNodeLossFactor,
       -- FactTransmissionNodeDailyLoad
       CONVERT(DATE, CAST(FactTransmissionNodeDailyLoad.SettlementDateId AS NCHAR(8)), 112) AS SettlementDate,
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
       FactTransmissionNodeDailyLoad.TransmissionLossFactor
FROM   DW_Dimensional.DW.FactTransmissionNodeDailyLoad
LEFT   JOIN DW_Dimensional.DW.DimTransmissionNode ON DimTransmissionNode.TransmissionNodeId = FactTransmissionNodeDailyLoad.TransmissionNodeId;

GO
