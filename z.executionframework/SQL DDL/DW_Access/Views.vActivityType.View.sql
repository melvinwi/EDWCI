USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Views].[vActivityType]
AS
SELECT DimActivityType.ActivityTypeCode,
       ISNULL(NULLIF(DimActivityType.ActivityTypeDesc, ''), '{Unknown}') AS ActivityTypeDesc
FROM   DW_Dimensional.DW.DimActivityType
WHERE  DimActivityType.Meta_IsCurrent = 1;
GO
