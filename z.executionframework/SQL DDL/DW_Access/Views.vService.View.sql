USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [Views].[vService]
AS 
WITH activeService AS 
(SELECT DISTINCT DimService.ServiceKey
  FROM [DW_Dimensional].[DW].[FactContract]
  INNER JOIN [DW_Dimensional].[DW].[DimService]
  ON DimService.ServiceId = FactContract.ServiceId
  WHERE FactContract.ContractStatus <> 'Closed')
SELECT           ISNULL(NULLIF(DimService.MarketIdentifier,''),'{Unknown}') AS MarketIdentifier,
                 ISNULL(NULLIF(DimService.ServiceType,''),'{Unknown}') AS ServiceType,
			  DimService.LossFactor,
			  DimService.EstimatedDailyConsumption,
			  ISNULL(NULLIF(DimService.MeteringType,''),'{Unk}') AS MeteringType,
			  ISNULL(NULLIF(DimService.ResidentialSuburb,''),'{Unknown}') AS ResidentialSuburb,
			  ISNULL(NULLIF(DimService.ResidentialPostcode,''),'{U}') AS ResidentialPostcode,
			  ISNULL(NULLIF(DimService.ResidentialState,''),'{U}') AS ResidentialState,
			  DimService.NextScheduledReadDate,
			  DimService.FRMPDate,
			  CASE WHEN activeService.ServiceKey IS NOT NULL
			  THEN 'Active'
			  ELSE 'Inactive'
			  END AS ServiceStatus,
			  CASE WHEN activeService.ServiceKey IS NOT NULL
			  THEN ISNULL(DATEDIFF(day,DimService.FRMPDate,GETDATE()),0)
			  ELSE 0
			  END AS LatestSiteTenure
     FROM DW_Dimensional.DW.DimService
	LEFT JOIN activeService
	ON activeService.ServiceKey = DimService.ServiceKey
     WHERE DimService.Meta_IsCurrent = 1
	AND ServiceId > 0;
	






GO
