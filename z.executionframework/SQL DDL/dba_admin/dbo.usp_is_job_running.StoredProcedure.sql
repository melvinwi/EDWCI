USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_is_job_running]
(
       @job_name sysname
     , @is_running bit = null output
)
as

-- Lumo Energy | Database Administration
-- Is SQL Server Agent job running?
--
-- 2010-02-11 Paul.Storm        Initial Release for SQL Server 2005 +
-- 2010-10-14 Darren.Pilkington Scraped from www to work on all versions of SQL Server and modified
--                    http://www.siccolo.com/Articles/SQLScripts/how-to-create-sql-to-sql-job-execution-status.html
--                    (C) 2006 Greg Dubinovsky 
-- 2010-10-15 Darren.Pilkington Corrected return parameter name
-- 2012-10-23 Darren.Pilkington Lumo Release, will only work on 2005 or newer
--

/*
	Is the execution status for the jobs. 
	Value Description 
	0 Returns only those jobs that are not idle or suspended.  
RET 1	1 Executing. 
RET 1	2 Waiting for thread. 
RET 1	3 Between retries. 
RET 0	4 Idle. 
RET 1	5 Suspended. 
RET 1	7 Performing completion actions 
*/

declare	@job_id UNIQUEIDENTIFIER 
	, @is_sysadmin INT
	, @job_owner   sysname

select @job_id = job_id from msdb..sysjobs_view where name = @job_name 
select @is_sysadmin = ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0)
select @job_owner = SUSER_SNAME()

CREATE TABLE #xp_results (job_id                UNIQUEIDENTIFIER NOT NULL,
                            last_run_date         INT              NOT NULL,
                            last_run_time         INT              NOT NULL,
                            next_run_date         INT              NOT NULL,
                            next_run_time         INT              NOT NULL,
                            next_run_schedule_id  INT              NOT NULL,
                            requested_to_run      INT              NOT NULL, -- BOOL
                            request_source        INT              NOT NULL,
                            request_source_id     sysname          COLLATE database_default NULL,
                            running               INT              NOT NULL, -- BOOL
                            current_step          INT              NOT NULL,
                            current_retry_attempt INT              NOT NULL,
                            job_state             INT              NOT NULL)


	    INSERT INTO #xp_results
	    EXECUTE master.dbo.xp_sqlagent_enum_jobs @is_sysadmin, @job_owner, @job_id

set @is_running = (select case job_state WHEN 4 THEN 0 ELSE 1 END from #xp_results)

drop table #xp_results

set nocount off

GO
