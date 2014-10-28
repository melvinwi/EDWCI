USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DatabaseCheckVLDBInfo]
AS
SELECT 
	[database_name],
	[object_name],
	AVG(DATEDIFF(ss,start_time,end_time)) AS avg_seconds,
	MAX(end_time) AS last_checked
  FROM [dba_admin].[dbo].[DatabaseCheckVLDBLog]
  GROUP BY [database_name],[object_name];


GO
