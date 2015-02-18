USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [reports].[CheckCurrentExecutions] as

SELECT  
es.session_id, es.host_name, es.login_name   
, er.status, DB_NAME(er.database_id) AS DatabaseName   
, SUBSTRING (qt.text,(er.statement_start_offset/2) + 1,  
  ((CASE WHEN er.statement_end_offset = -1  
  THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2  
  ELSE er.statement_end_offset 
  END - er.statement_start_offset)/2) + 1) AS [Individual Query]  
, qt.text AS [Parent Query]  
, es.program_name, er.start_time, qp.query_plan 
, er.wait_type, er.total_elapsed_time, er.cpu_time, er.logical_reads 
, er.blocking_session_id, er.open_transaction_count, er.last_wait_type 
, er.percent_complete 
FROM sys.dm_exec_requests AS er 
INNER JOIN sys.dm_exec_sessions AS es ON es.session_id = er.session_id 
CROSS APPLY sys.dm_exec_sql_text( er.sql_handle) AS qt 
CROSS APPLY sys.dm_exec_query_plan(er.plan_handle) qp 
WHERE es.is_user_process=1  
AND es.session_Id NOT IN (@@SPID) 
ORDER BY es.session_id


GO
