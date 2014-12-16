USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_MonitorSQLAgentJobs] 
AS 
    SET NOCOUNT ON;

-- Tatts Group | Database Administration
-- SQL Agent Job Monitoring
--
-- 2011-04-11 DUANEW Initial version of the script
--
-- This stored procedure checks for nominated SQL Server Agent jobs running longer that the specified threshold.
--

/*
Declare the local variables
*/

	-- Local variables for the CURSOR        
	DECLARE
		@job_id [uniqueidentifier],
		@name [sysname],
		@status [char](1),
		@notify_appteam [varchar](200),
		@execution_threshold [int],
		@alert_freq [int],
		@max_number_of_alerts [int],
		@alert_count [int],
		@last_alert [datetime];

	-- Other variables
	DECLARE
		@history_retention int, 
		@retention_date datetime,
		@instance_id [int],
		@elapsed_time [int],
		@email_profile_name [varchar] (50),
		@subject_heading [varchar] (200),
		@email_message [varchar] (200),
		@DATABASE_VERSION INT;


	SET @email_profile_name = 'DBA Mail Profile'


	-- Verify the database version.
	--IF CONVERT(sysname, SERVERPROPERTY(N'ProductVersion')) LIKE N'10%'
	--BEGIN
	--	SET @DATABASE_VERSION = 2008
	--END
	--ELSE IF CONVERT(sysname, SERVERPROPERTY(N'ProductVersion')) LIKE N'9%'
	--BEGIN
	--	SET @DATABASE_VERSION = 2005
	--END
	--ELSE BEGIN
	--	SELECT N'This version is only for SQL Server 2005 or 2008'
	--	RETURN
	--END
	
	--SELECT CONVERT(sysname, SERVERPROPERTY(N'ProductVersion')) LIKE N'10%'


	/*
	To save having to manually add individual jobs to the Job_Monitoring table,
	automatically populate the [job_monitoring] table with a list of all "new" jobs.
	Set the [status] to Blank (to indicate that there is no monotoring) for any newly 
	added entries.
	*/
	PRINT 'Populating the JobMonitor table with any newly created jobs ';

	INSERT INTO [JobMonitor] 
		SELECT
		[job_id],		-- [job_id]
		[name],			-- [name]
		' ',			-- [status] 
		NULL,			-- [execution_threshold]
		NULL,			-- [notify_appteam] 
		NULL,			-- [alert_freq]
		NULL,			-- [max_number_of_alerts]
		NULL,			-- [alert_count]
		NULL,			-- [last_alert]
		CURRENT_TIMESTAMP,	-- [modified_date]
		'Initial Entry'		-- [modified_by]
		FROM msdb.dbo.sysjobs
		WHERE [job_id] NOT IN (SELECT [job_id] FROM [JobMonitor])
	
	/*
	To avoid any confusion around people believing that a SQL Agent job (that no longer exists) is still
	monitored, change the [JobMonitor] status of any "removed" SQL Agent Jobs to "R" 
	*/
	UPDATE [JobMonitor] SET [status] = 'R'
	WHERE [job_id] NOT IN (SELECT [job_id] FROM msdb.dbo.sysjobs)
	
	/*	
	Purge History records older than the specified retention period
	*/
	SELECT @history_retention = convert(int,[parameter_value]) FROM [SystemParameters]
	WHERE [parameter_name] = 'JOBHISTORY_RETENTION'
	
	SELECT @retention_date = DATEADD(day,-@history_retention,CURRENT_TIMESTAMP)

	PRINT 'Purging JobHistory records older than the Cutoff Date of ' + CONVERT(VARCHAR(10),@retention_date ,121);

	DELETE FROM [JobHistory] 
	WHERE [run_datetime] < @retention_date

	/*
	Loop through the JobMonitor entries picking up only those that are to be monitored
	*/
	DECLARE jobmonitor_cursor CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR 
		SELECT
		[job_id],
		[name],
		[status],
		[execution_threshold],
		[notify_appteam],
		ISNULL([alert_freq], 60),				-- Use the default of 60 minutes if not specified
		ISNULL([max_number_of_alerts], 5),		-- Use the default of 5 alerts if not specified
		ISNULL([alert_count], 0),				-- Use the default of 0 alerts if not specified
		ISNULL([last_alert], '2000-01-01 00:00:00')
	FROM [dbo].[JobMonitor]
	WHERE [status] = 'M'						-- Only the "Monitored" jobs
	AND [notify_appteam] IS NOT NULL			-- Email for App Team must be specified
	AND [execution_threshold] IS NOT NULL		-- Must have an execution threshold defined
	ORDER BY [job_id];

	OPEN jobmonitor_cursor;

	FETCH NEXT FROM jobmonitor_cursor 
	INTO @job_id, @name, @status, @execution_threshold, @notify_appteam, @alert_freq, @max_number_of_alerts, @alert_count, @last_alert;

	WHILE @@FETCH_STATUS = 0
	BEGIN

		/*
		Record history of any "completed" job entries since this Monitoring SPR was last run.
		*/
		PRINT 'Inserting completed job entries into the JobHistory table';
	
		-- Get the maximum instance_id from the [JobHistory] for the [job_id]
		SELECT @instance_id = ISNULL(MAX([instance_id]), 0)
		FROM [JobHistory]
		WHERE [job_id] = @job_id
		
		-- Insert any log entries which have a higher instance_id into the [JobHistory] table
		-- but only those entries with the [step_name] of '(Job outcome)'
		INSERT INTO [JobHistory] 
		SELECT instance_id, job_id, job_name, run_datetime, run_duration, run_status
		FROM (
				SELECT instance_id, job_id, job_name, run_datetime, 
				SUBSTRING(run_duration, 1, 2) + ':' + SUBSTRING(run_duration, 3, 2) + ':' +
				SUBSTRING(run_duration, 5, 2) AS run_duration, run_status
				FROM (
						SELECT DISTINCT
								h.instance_id AS instance_id,
								j.job_id AS job_id,
								j.name AS job_name, 
								run_datetime = CONVERT(DATETIME, RTRIM(run_date)) +  
									(run_time * 9 + run_time % 10000 * 6 + run_time % 100 * 10) / 216e4,
								run_duration = RIGHT('000000' + CONVERT(VARCHAR(6), run_duration), 6),
								CASE h.run_status 
									WHEN 0 THEN 'Failed'
									WHEN 1 THEN 'Succeeded'
									WHEN 2 THEN 'Retry'
									WHEN 3 THEN 'Canceled'
									ELSE 'Unknown'
								END AS run_status
						FROM msdb..sysjobhistory h
						INNER JOIN msdb..sysjobs j
						ON h.job_id = j.job_id
						WHERE j.job_id = @job_id
						AND step_name = '(Job outcome)'
						) t
				) t
		WHERE [job_id] = @job_id
		AND [instance_id] > @instance_id
		AND [run_datetime] > @retention_date		-- No need for entries older than than the retention period
		
		
		/*
		Check if there is a job currently running which has exceeded the execution threshold and has a matching [job_id]
		*/
		PRINT 'Checking for long running jobs';
		
		SET @elapsed_time = 0
		
		SELECT @elapsed_time = ISNULL(DATEDIFF(mi, activity.start_execution_date, CURRENT_TIMESTAMP), 0) 
		FROM msdb.dbo.sysjobs_view job 
		INNER JOIN msdb.dbo.sysjobactivity activity ON (job.job_id = activity.job_id) 
		WHERE activity.run_Requested_date IS NOT NULL
		AND activity.stop_execution_date IS NULL
		AND job.job_id = @job_id
			
		-- Has the jobs elapsed time exceeded the execution threshold	
		IF @elapsed_time > @execution_threshold
		BEGIN
			-- Is the time (in minutes) since the [last_alert] was raised greater than the [alert_freq]?
			IF DATEDIFF(mi, @last_alert, CURRENT_TIMESTAMP) > @alert_freq
			BEGIN	
				-- Is the number of alerts sent previously less than the [max_number_of_alerts] threshold
				IF @alert_count < @max_number_of_alerts 
				BEGIN						
					-- Raise an alert to the application team 
					PRINT 'Raising an alert for job "'+RTRIM(@name)+'" ';

					SET @subject_heading = RTRIM(CONVERT(VARCHAR (100), SERVERPROPERTY('servername')))+ ' - Job Execution Threshold Exceeded'

					SET @email_message = 'SQL Instance:  ' + RTRIM(CONVERT(VARCHAR (100), SERVERPROPERTY('servername'))) + Char(13) + Char(10) + 
					'Job Name:  '+RTRIM(@name) + Char(13) + Char(10) +
					'Status:  Job has exceeded the execution threshold of "' + RTRIM(CONVERT(CHAR(4), @execution_threshold)) + '" minutes.  The job has been running for "'+RTRIM(CONVERT(CHAR(4), @elapsed_time))+'" minutes.  '

					-- DB Mail to [notify_appteam]
					EXEC msdb.dbo.sp_send_dbmail @profile_name = @email_profile_name, @recipients = @notify_appteam, @body = @email_message, @subject = @subject_heading
													
					-- Update the [last_alert] value with the current date/time
					UPDATE [JobMonitor] SET [last_alert] = CURRENT_TIMESTAMP, [alert_count] = [alert_count] + 1
					WHERE [job_id] = @job_id	
				END
			END
		END
		ELSE
		BEGIN
			-- Reset the [alert_count]
			UPDATE [JobMonitor] SET [alert_count] = 0
			WHERE [job_id] = @job_id	
		END
	
		FETCH NEXT FROM jobmonitor_cursor  
		INTO @job_id, @name, @status, @execution_threshold, @notify_appteam, @alert_freq, @max_number_of_alerts, @alert_count, @last_alert;
	END
	
	CLOSE jobmonitor_cursor ;
	DEALLOCATE jobmonitor_cursor ;


GO
