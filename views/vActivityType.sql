CREATE VIEW Views.vActivityType
AS
SELECT DimActivityType.ActivityTypeCode,
       ISNULL(NULLIF(DimActivityType.ActivityTypeDesc, ''), '{Unknown}') AS ActivityTypeDesc
FROM   DW_Dimensional.DW.DimActivityType
WHERE  DimActivityType.Meta_IsCurrent = 1;