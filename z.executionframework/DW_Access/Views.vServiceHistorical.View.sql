USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [Views].[vServiceHistorical]
AS SELECT        ISNULL(NULLIF(MarketIdentifier,''),'{Unknown}') AS MarketIdentifier,
                 ISNULL(NULLIF(ServiceType,''),'{Unknown}') AS ServiceType,
			  LossFactor,
			  EstimatedDailyConsumption,
			  ISNULL(NULLIF(MeteringType,''),'{Unk}') AS MeteringType,
			  ISNULL(NULLIF(ResidentialSuburb,''),'{Unknown}') AS ResidentialSuburb,
			  ISNULL(NULLIF(ResidentialPostcode,''),'{U}') AS ResidentialPostcode,
			  ISNULL(NULLIF(ResidentialState,''),'{U}') AS ResidentialState,
			  FRMPDate,
			  Meta_IsCurrent,
			  Meta_EffectiveStartDate,
			  Meta_EffectiveEndDate
     FROM DW_Dimensional.DW.DimService
	WHERE ServiceId > 0;
	



GO
