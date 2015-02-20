USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_stop_job_if_running]
	 @jobName SYSNAME,@executionTimeCheck Char(1)
AS 

-- Lumo Energy | Database Administration
-- Stop SQL Server agent job if running
--
-- 2010-02-11 Paul.Storm        Initial Release
-- 2012-10-23 Darren.Pilkington Lumo Release, will only work on 2005 or newer
--
-- calls usp_is_job_running to determine if job is running.
-- If it is, calls system proc msdb.dbo.sp_stop_job
--

DECLARE @isRunning BIT;
IF @executionTimeCheck ='N' 
	BEGIN 
		EXEC dba_admin.dbo.usp_is_job_running @job_name = @jobName,@is_running = @isRunning OUTPUT;

		IF @isRunning = 1 
			BEGIN
				EXEC msdb.dbo.sp_stop_job @job_name = @jobName;
			END
	END 
	--PRINT  'IN  N'
IF @executionTimeCheck ='Y' 
	BEGIN
		DECLARE @RunStatus VARCHAR(1)
		DECLARE @Timerunning  NUMERIC(4)

		SELECT  @Timerunning=( DateDiff(ss, sja.start_execution_date , getdate()) /60 ) from  msdb.dbo.sysjobactivity SJA 
		 INNER JOIN msdb.dbo.sysjobs J  ON J.job_id =sja.job_id 
		 WHERE J.name =@JobName  AND  
		 sja.start_execution_date IS NOT NULL AND 
			sja.stop_execution_date IS  NULL
			PRINT @Timerunning
		 If @Timerunning > 180
			--PRINT 'Time Exceeded'
			EXEC msdb.dbo.sp_stop_job @job_name = @jobName
		  

END 
GO
