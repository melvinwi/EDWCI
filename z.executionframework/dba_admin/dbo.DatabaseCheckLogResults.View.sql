USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DatabaseCheckLogResults]
AS
SELECT
	[log_record_no]
	,[database_name]
	,[check_type]
	,[start_time]
	,[end_time]
	,[result]
	,DATEDIFF(ss, start_time, CASE WHEN end_time IS NULL THEN GETDATE() ELSE end_time END) AS elapsed
FROM [dba_admin].[dbo].[DatabaseCheckLog] (NOLOCK)
;
GO
