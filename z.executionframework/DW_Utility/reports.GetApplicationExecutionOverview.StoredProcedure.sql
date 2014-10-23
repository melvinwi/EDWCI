USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [reports].[GetApplicationExecutionOverview]
	@ApplicationExecutionInstanceID INT NULL
AS

  /*
  Schema            :   reports
  Object            :   GetApplicationExecutionOverview
  Author            :   Jon Giles
  Created Date      :   01.08.2014
  Description       :   Returns one row per task for a given Application Execution Instance (default is most recent)

  Change  History   : 
  Author  Date          Description of Change
  JG      21.09.2014    Added ISNULL() wrapper to ExecutionTime calculation
                        Removed Package GUIDs from result set
  JG      02.10.2014    Added PrecedentTaskIds
  <YOUR ROW HERE>     
  
  Usage:
    EXEC [reports].[GetApplicationExecutionOverview] NULL
    --SELECT * FROM dbo.ApplicationExecutionInstance ORDER BY StartDateTime DESC

  */

IF @ApplicationExecutionInstanceID IS NULL
BEGIN
  SET @ApplicationExecutionInstanceID 
      = ( SELECT TOP 1 ApplicationExecutionInstanceID
          FROM      dbo.ApplicationExecutionInstance
          ORDER BY  StartDateTime DESC
        )
END

	SELECT      l.TaskExecutionInstanceID
		        , l.TaskID
		        --, l.TaskPackageExecutionID
		        --, l.TaskPackageID
		        , a.SSISExecutionID
		        , t.TaskName
		        , l.PackageName
		        , l.StartDateTime
		        , CASE  WHEN DATEDIFF(ms, l.StartDateTime, l.EndDateTime) < 0 THEN NULL 
                      ELSE l.EndDateTime 
              END               AS EndDateTime
            , CASE  WHEN DATEDIFF(ms, l.StartDateTime, l.EndDateTime) < 0 THEN NULL   --Don't calculate duration if EndDateTime is earlier than StartDateTime
                      ELSE                    CAST( DATEDIFF(ms, l.StartDateTime, ISNULL(l.EndDateTime, GETDATE())) / 60000      AS VARCHAR(50))     --minutes
                        + ':' + RIGHT('00'  + CAST((DATEDIFF(ms, l.StartDateTime, ISNULL(l.EndDateTime, GETDATE())) / 1000) % 60 AS VARCHAR(50)), 2) --seconds
                        + ':' + RIGHT('000' + CAST( DATEDIFF(ms, l.StartDateTime, ISNULL(l.EndDateTime, GETDATE()))              AS VARCHAR(50)), 3) --milliseconds
		          END               AS Duration_MinSecMS
		        , s.CodeDescription AS StatusCodeDescription
		        , f.CodeDescription AS FailureActionCodeDescription
		        , r.CodeDescription AS RecoveryActionCodeDescription
		        , l.ParallelChannel
		        , l.ExecutionOrder
            , l.PrecedentTaskIds
		        , l.ExtractRowCount
		        , l.InsertRowCount
		        , l.UpdateRowCount
		        , l.DeleteRowCount
		        , l.ErrorRowCount --select *
	FROM            dbo.TaskExecutionInstance         AS l
	INNER JOIN      dbo.ApplicationExecutionInstance  AS a 
                  ON  l.ApplicationExecutionInstanceID = a.ApplicationExecutionInstanceID
	INNER JOIN      config.Task                       AS t 
                  ON  t.TaskID = l.TaskID
	LEFT OUTER JOIN config.FrameworkCodes             AS f 
                  ON  l.FailureActionCode = f.FrameworkCode 
                  AND f.CodeType          = 'Failure Action'
	LEFT OUTER JOIN config.FrameworkCodes             AS r 
                  ON  l.RecoveryActionCode  = r.FrameworkCode 
                  AND r.CodeType            = 'Recovery Mode'
	LEFT OUTER JOIN config.FrameworkCodes             AS s 
                  ON  l.StatusCode = s.FrameworkCode 
                  AND s.CodeType='Task Status'
	WHERE       l.ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
	ORDER BY    ISNULL(l.StartDateTime, '99991231')
            , l.ExecutionOrder
            , l.ParallelChannel

GO
