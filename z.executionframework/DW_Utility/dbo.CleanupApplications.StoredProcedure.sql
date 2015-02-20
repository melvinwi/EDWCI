USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[CleanupApplications] AS

/*
Schema            :   dbo
Object            :   CleanUpApplications
Author            :   Jon Giles
Created Date      :   27.01.2015
Description       :   Aborts ApplicationExecutionInstances that have the status 'running', but are not running.

Change  History   : 
Author  Date          Description of Change
<YOUR ROW HERE>     

USAGE
  EXEC [dbo].[CleanUpApplications]
*/

--Declare Parameters
DECLARE	@job_id       UNIQUEIDENTIFIER 
	    , @is_sysadmin  INT
	    , @job_owner    SYSNAME
      , @ApplicationExecutionInstanceID INT
      , @RN_Id INT = 0

DECLARE @ApplicationExecutionsToAbort     TABLE
        ( ApplicationExecutionInstanceID  INT
        , RN                              INT IDENTITY(1,1)
        )

SELECT @is_sysadmin = ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0)
SELECT @job_owner   = SUSER_SNAME()
--/

--Create and populate job-info table
IF OBJECT_ID('tempdb..#xp_results') IS NOT NULL
BEGIN
  DROP TABLE #xp_results 
END 

CREATE TABLE #xp_results  ( job_id                UNIQUEIDENTIFIER NOT NULL
                          , last_run_date         INT              NOT NULL
                          , last_run_time         INT              NOT NULL
                          , next_run_date         INT              NOT NULL
                          , next_run_time         INT              NOT NULL
                          , next_run_schedule_id  INT              NOT NULL
                          , requested_to_run      INT              NOT NULL -- BOOL
                          , request_source        INT              NOT NULL
                          , request_source_id     sysname          COLLATE database_default NULL
                          , running               INT              NOT NULL -- BOOL
                          , current_step          INT              NOT NULL
                          , current_retry_attempt INT              NOT NULL
                          , job_state             INT              NOT NULL
                          )

INSERT INTO #xp_results
EXECUTE MASTER.dbo.xp_sqlagent_enum_jobs @is_sysadmin, @job_owner, @job_id
--/

--Get job statuses and compare with the ApplicationExecutionInstance table
;WITH Jobs AS ( SELECT    
                  SUBSTRING(js.command, PATINDEX('%\"ApplicationID(Int32)\"";%', js.command) + 26, PATINDEX('% /Par "\"$%', SUBSTRING(js.command, PATINDEX('%\"ApplicationID(Int32)\"";%', js.command) + 27, 20))) AS ApplicationId
                , ISNULL(x.running, 0) AS IsRunning
                FROM        [msdb].[dbo].[sysjobsteps]        AS js
                LEFT JOIN   #xp_results                       AS x
                            ON  x.job_id = js.job_id
                            AND x.current_step = js.step_id
                    WHERE   js.command LIKE '/ISSERVER "\"\SSISDB\DW\ETL_Framework\Application.dtsx\"%'
              )
  , Jobs2 AS  ( SELECT  ApplicationId
                      , IsRunning 
                      , ROW_NUMBER() OVER(PARTITION BY ApplicationId ORDER BY IsRunning DESC) AS Precedence
                FROM    Jobs
              )
INSERT INTO @ApplicationExecutionsToAbort ( ApplicationExecutionInstanceID )
SELECT      AEI.ApplicationExecutionInstanceID
FROM        dbo.ApplicationExecutionInstance  AS AEI
INNER JOIN  Jobs2
            ON  Jobs2.ApplicationId = AEI.ApplicationId
    WHERE   AEI.StatusCode    = 'R' --Running
      AND   Jobs2.IsRunning   = 0
      AND   Jobs2.Precedence  = 1
  
SET @RN_Id = @@ROWCOUNT
--/

--Abort all applications that are incorrectly marked as running
WHILE @RN_Id >= 1
  BEGIN

    SELECT  @ApplicationExecutionInstanceID = ApplicationExecutionInstanceID
    FROM    @ApplicationExecutionsToAbort
    WHERE   RN = @RN_Id

    EXEC dbo.AbortApplicationExecution @ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID

    SET @RN_Id = @RN_Id - 1

  END
--/

--tidy up
DROP TABLE #xp_results
--/
GO
