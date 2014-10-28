USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Views].[vProduct]
AS SELECT        ISNULL(NULLIF(ProductName,''),'{Unknown}') AS ProductName,
                 ISNULL(NULLIF(ProductDesc,''),'{Unknown}') AS ProductDesc,
			  ISNULL(NULLIF(ProductType,''),'{Unk}') AS ProductType
     FROM DW_Dimensional.DW.DimProduct
     WHERE Meta_IsCurrent = 1;
	

GO
