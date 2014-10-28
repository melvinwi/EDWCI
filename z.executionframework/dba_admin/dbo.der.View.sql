USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[der]
as
select
	dateadd(ms,estimated_completion_time,getdate()) as "est_completion_time",
	percent_complete,
	session_id, start_time, status, command, wait_type, wait_time
from sys.dm_exec_requests
where session_id > 50;
GO
