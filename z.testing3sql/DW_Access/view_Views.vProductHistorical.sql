USE [DW_Access]
GO

/****** Object:  View [Views].[vProductHistorical]    Script Date: 2/09/2014 12:15:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [Views].[vProductHistorical]
AS SELECT        ISNULL(NULLIF(ProductName,''),'{Unknown}') AS ProductName,
                 ISNULL(NULLIF(ProductDesc,''),'{Unknown}') AS ProductDesc,
			  ISNULL(NULLIF(ProductType,''),'{Unk}') AS ProductType,
			  Meta_IsCurrent,
			  Meta_EffectiveStartDate,
			  Meta_EffectiveEndDate
     FROM DW_Dimensional.DW.DimProduct;
	

GO

