USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Views].[vTransmissionNodeDailyLoad]
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
INNER  JOIN (SELECT FactTransmissionNodeDailyLoad.TransmissionNodeId,
                    FactTransmissionNodeDailyLoad.SettlementDateId,
                    MAX(SettlementRun) AS MaxSettlementRun
             FROM   DW_Dimensional.DW.FactTransmissionNodeDailyLoad
             GROUP  BY FactTransmissionNodeDailyLoad.TransmissionNodeId,
                       FactTransmissionNodeDailyLoad.SettlementDateId) t ON t.TransmissionNodeId = FactTransmissionNodeDailyLoad.TransmissionNodeId AND t.SettlementDateId = FactTransmissionNodeDailyLoad.SettlementDateId AND t.MaxSettlementRun = FactTransmissionNodeDailyLoad.SettlementRun
LEFT   JOIN DW_Dimensional.DW.DimTransmissionNode ON DimTransmissionNode.TransmissionNodeId = FactTransmissionNodeDailyLoad.TransmissionNodeId;


GO
