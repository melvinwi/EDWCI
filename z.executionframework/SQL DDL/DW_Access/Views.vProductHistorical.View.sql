USE [DW_Access]
GO
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
