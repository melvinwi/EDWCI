USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Views].[vServiceDailyLoad]
AS
SELECT -- DimService
       DimService.ServiceType,
       DimService.LossFactor,
       DimService.EstimatedDailyConsumption,
       DimService.MeteringType,
       DimService.ResidentialSuburb,
       DimService.ResidentialPostcode,
       DimService.ResidentialState,
       DimService.NextScheduledReadDate,
       DimService.FRMPDate,
       DimService.Threshold,
       DimService.FirstImportRegisterDate,
       DimService.SiteStatus,
       DimService.SiteStatusType,
       -- DimTransmissionNode
       DimTransmissionNode.TransmissionNodeName,
       DimTransmissionNode.TransmissionNodeState,
       DimTransmissionNode.TransmissionNodeNetwork,
       DimTransmissionNode.TransmissionNodeServiceType,
       DimTransmissionNode.TransmissionNodeLossFactor,
       -- FactServiceDailyLoad
       FactServiceDailyLoad.TransmissionNodeIdentity,
       FactServiceDailyLoad.MarketIdentifier,
       CONVERT(DATE, CAST(FactServiceDailyLoad.SettlementDateId AS NCHAR(8)), 112) AS SettlementDate,
       FactServiceDailyLoad.SettlementCase,
       FactServiceDailyLoad.DatastreamType,
       FactServiceDailyLoad.ReadType,
       FactServiceDailyLoad.TotalEnergy
FROM   DW_Dimensional.DW.FactServiceDailyLoad
INNER  JOIN (SELECT FactServiceDailyLoad.MarketIdentifier,
                    FactServiceDailyLoad.SettlementDateId,
                    MAX(SettlementCase) AS MaxSettlementCase
             FROM   DW_Dimensional.DW.FactServiceDailyLoad
             GROUP  BY FactServiceDailyLoad.MarketIdentifier,
                       FactServiceDailyLoad.SettlementDateId) t ON t.MarketIdentifier = FactServiceDailyLoad.MarketIdentifier AND t.SettlementDateId = FactServiceDailyLoad.SettlementDateId AND t.MaxSettlementCase = FactServiceDailyLoad.SettlementCase
LEFT   JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactServiceDailyLoad.ServiceId
LEFT   JOIN DW_Dimensional.DW.DimTransmissionNode ON DimTransmissionNode.TransmissionNodeId = FactServiceDailyLoad.TransmissionNodeId;
GO
