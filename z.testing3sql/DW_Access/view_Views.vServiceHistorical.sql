USE [DW_Access]
GO

/****** Object:  View [Views].[vServiceHistorical]    Script Date: 2/09/2014 12:15:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Views].[vServiceHistorical]
AS SELECT        ISNULL(NULLIF(MarketIdentifier,''),'{Unknown}') AS MarketIdentifier,
                 ISNULL(NULLIF(ServiceType,''),'{Unknown}') AS ServiceType,
			  Meta_IsCurrent,
			  Meta_EffectiveStartDate,
			  Meta_EffectiveEndDate
     FROM DW_Dimensional.DW.DimService;
	

GO

