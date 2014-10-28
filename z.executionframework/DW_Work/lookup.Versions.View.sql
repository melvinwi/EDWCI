USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [lookup].[Versions]
AS
SELECT 'Actual' AS VersionKey, 'Actual' AS VersionName UNION ALL
SELECT 'Budget' AS VersionKey, 'Budget' AS VersionName UNION ALL
Select 'Forecast' AS VersionKey, 'Forecast' AS VersionName


GO
