CREATE VIEW Views.vServiceDailyLoad
AS
SELECT -- DimService
       DimServiceCurrent.ServiceType,
       DimServiceCurrent.LossFactor,
       DimServiceCurrent.EstimatedDailyConsumption,
       DimServiceCurrent.MeteringType,
       DimServiceCurrent.ResidentialSuburb,
       DimServiceCurrent.ResidentialPostcode,
       DimServiceCurrent.ResidentialState,
       DimServiceCurrent.NextScheduledReadDate,
       DimServiceCurrent.FRMPDate,
       DimServiceCurrent.Threshold,
       DimServiceCurrent.FirstImportRegisterDate,
       DimServiceCurrent.SiteStatus,
       DimServiceCurrent.SiteStatusType,
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
LEFT   JOIN DW_Dimensional.DW.DimService AS DimServiceCurrent ON DimServiceCurrent.ServiceKey = DimService.ServiceKey AND DimServiceCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimTransmissionNode ON DimTransmissionNode.TransmissionNodeId = FactServiceDailyLoad.TransmissionNodeId;