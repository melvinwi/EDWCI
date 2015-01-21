CREATE VIEW [Views].[vServiceDailyLoadHistorical]
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
LEFT   JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactServiceDailyLoad.ServiceId
LEFT   JOIN DW_Dimensional.DW.DimTransmissionNode ON DimTransmissionNode.TransmissionNodeId = FactServiceDailyLoad.TransmissionNodeId;
GO

