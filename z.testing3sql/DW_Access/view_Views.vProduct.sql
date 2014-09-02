USE [DW_Access]
GO

/****** Object:  View [Views].[vProduct]    Script Date: 2/09/2014 12:15:18 PM ******/
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

