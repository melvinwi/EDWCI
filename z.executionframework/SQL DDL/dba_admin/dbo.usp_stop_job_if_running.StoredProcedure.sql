USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_stop_job_if_running]
	 @jobName SYSNAME
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

EXEC dba_admin.dbo.usp_is_job_running @job_name = @jobName, @is_running = @isRunning OUTPUT;

IF @isRunning = 1
BEGIN
	EXEC msdb.dbo.sp_stop_job @job_name = @jobName;
END
GO
