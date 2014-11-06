USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Views].[vUnitType]
AS SELECT ISNULL(NULLIF(UnitTypeName,''),'{Unknown}') AS UnitTypeName,
          MultiplicationFactorToBase
   FROM   DW_Dimensional.DW.DimUnitType
   WHERE  Meta_IsCurrent = 1;


GO
