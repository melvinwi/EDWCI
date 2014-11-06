USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Views].[vUnitTypeHistorical]
AS SELECT ISNULL(NULLIF(UnitTypeName,''),'{Unknown}') AS UnitTypeName,
          MultiplicationFactorToBase,
          Meta_IsCurrent,
          Meta_EffectiveStartDate,
          Meta_EffectiveEndDate
   FROM   DW_Dimensional.DW.DimUnitType


GO
