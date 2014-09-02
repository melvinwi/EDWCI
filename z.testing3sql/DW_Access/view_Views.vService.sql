USE [DW_Access]
GO

/****** Object:  View [Views].[vService]    Script Date: 2/09/2014 12:15:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Views].[vService]
AS SELECT        ISNULL(NULLIF(MarketIdentifier,''),'{Unknown}') AS MarketIdentifier,
                 ISNULL(NULLIF(ServiceType,''),'{Unknown}') AS ServiceType
     FROM DW_Dimensional.DW.DimService
     WHERE Meta_IsCurrent = 1;
	

GO

