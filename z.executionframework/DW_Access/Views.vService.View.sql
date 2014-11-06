USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [Views].[vService]
AS SELECT        ISNULL(NULLIF(MarketIdentifier,''),'{Unknown}') AS MarketIdentifier,
                 ISNULL(NULLIF(ServiceType,''),'{Unknown}') AS ServiceType,
			  LossFactor,
			  EstimatedDailyConsumption,
			  ISNULL(NULLIF(MeteringType,''),'{Unk}') AS MeteringType,
			  ISNULL(NULLIF(ResidentialSuburb,''),'{Unknown}') AS ResidentialSuburb,
			  ISNULL(NULLIF(ResidentialPostcode,''),'{U}') AS ResidentialPostcode,
			  ISNULL(NULLIF(ResidentialState,''),'{U}') AS ResidentialState,
			  FRMPDate
     FROM DW_Dimensional.DW.DimService
     WHERE Meta_IsCurrent = 1
	AND ServiceId > 0;
	



GO
