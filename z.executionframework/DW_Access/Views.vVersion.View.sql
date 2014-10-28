USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Views].[vVersion]
AS SELECT ISNULL(NULLIF(VersionName,''),'{Unknown}') AS VersionName
   FROM   DW_Dimensional.DW.DimVersion


GO
