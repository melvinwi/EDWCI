USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VolumeSpaceDay]
AS
SELECT
	volume_name,
	MAX(capacity_bytes/1024) volume_size_kb,
	MIN(freespace_bytes/1024) volume_free_kb,
	MAX(capacity_bytes/1024) - MIN(freespace_bytes/1024) volume_used_kb,
	CAST((CAST(MIN(freespace_bytes/1024) AS FLOAT) / CAST(MAX(capacity_bytes/1024) AS FLOAT))*100 AS DECIMAL(10,2)) volume_free_pct,
	CAST(collection_time as DATE) collection_date
FROM [dba_admin].[dbo].[volumespace]
GROUP BY volume_name,CAST(collection_time as DATE);


GO
