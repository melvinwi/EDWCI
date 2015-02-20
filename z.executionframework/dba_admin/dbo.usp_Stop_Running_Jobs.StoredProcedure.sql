USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Stop_Running_Jobs]  @JobName	VARCHAR(200)
AS 
DECLARE @RunStatus VARCHAR(1)
DECLARE @Timerunning  NUMERIC(4)

SELECT  @Timerunning=( DateDiff(ss, sja.start_execution_date , getdate()) /60 ) from  msdb.dbo.sysjobactivity SJA 
 INNER JOIN msdb.dbo.sysjobs J  ON J.job_id =sja.job_id 
 WHERE J.name =@JobName  AND  
 sja.start_execution_date IS NOT NULL AND 
    sja.stop_execution_date IS  NULL
	PRINT @Timerunning
 If @Timerunning > 10
	PRINT 'Time Exceeded'
    --EXEC msdb.dbo.sp_stop_job @job_name = 'Database Maintenance - Database Statistics Update_DW_Staging'
 Else Print ' Its okay'
 
 

GO
