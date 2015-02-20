USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [reports].[GetApplicationsOverview]

AS
/*
Usage:
  EXEC [reports].[GetApplicationsOverview] 
*/

	WITH cte AS
	(
		SELECT  a.ApplicationID
			    , a.ApplicationName
			    , l.StartDateTime                                                                 AS LastStartDateTime
			    , l.EndDateTime                                                                   AS LastEndDateTime
			    , CAST(DATEDIFF(n, l.StartDateTime, l.EndDateTime) AS varchar(50)) 
            + ':' 
            + RIGHT('0' + CAST(DATEDIFF(s, l.StartDateTime, l.EndDateTime) AS varchar(50)), 2) 
            + ':' 
            +	CAST(DATEDIFF(ms, l.StartDateTime, l.EndDateTime) AS varchar(50))             AS LastExecutionTime
			    , CASE WHEN (l.ExecutionAborted = '0') THEN 'False' ELSE 'True' END               AS LastExecutionAborted
			    , f.CodeDescription                                                               AS LastStatusCodeDescription
			    --, s.NextScheduleRunDateTime
			    , ROW_NUMBER() OVER (PARTITION BY l.ApplicationID ORDER BY l.StartDateTime DESC)  AS ExecutionRank
		FROM dbo.ApplicationExecutionInstance AS l
		--OUTER APPLY (
		--	SELECT    s.ApplicationID
		--		      , MIN(s.NextRunDateTime)      AS NextScheduleRunDateTime
		--	FROM      config.ApplicationSchedule  AS s
		--	WHERE     s.ApplicationID = l.ApplicationID
		--	GROUP BY  s.ApplicationID		
		--) s
		INNER JOIN  config.[Application]      AS a 
            ON  l.ApplicationID = a.ApplicationID
		INNER JOIN  config.FrameworkCodes     AS f 
            ON  f.FrameworkCode = l.StatusCode 
            AND f.CodeType      = 'Run Status'
		WHERE       a.IsDisabled    = '0'
	)

	SELECT    ApplicationID
		      , ApplicationName
		      , LastStartDateTime
		      , LastEndDateTime
		      , LastExecutionTime
		      , LastExecutionAborted
		      , LastStatusCodeDescription
		      --, NextScheduleRunDateTime
	FROM      cte
	WHERE     ExecutionRank = 1
	ORDER BY  ApplicationName
GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [reports].[GetApplicationsOverview]

AS
/*
Usage:
  EXEC [reports].[GetApplicationsOverview] 
*/

	WITH cte AS
	(
		SELECT  a.ApplicationID
			    , a.ApplicationName
			    , l.StartDateTime                                                                 AS LastStartDateTime
			    , l.EndDateTime                                                                   AS LastEndDateTime
			    , CAST(DATEDIFF(n, l.StartDateTime, l.EndDateTime) AS varchar(50)) 
            + ':' 
            + RIGHT('0' + CAST(DATEDIFF(s, l.StartDateTime, l.EndDateTime) AS varchar(50)), 2) 
            + ':' 
            +	CAST(DATEDIFF(ms, l.StartDateTime, l.EndDateTime) AS varchar(50))             AS LastExecutionTime
			    , CASE WHEN (l.ExecutionAborted = '0') THEN 'False' ELSE 'True' END               AS LastExecutionAborted
			    , f.CodeDescription                                                               AS LastStatusCodeDescription
			    --, s.NextScheduleRunDateTime
			    , ROW_NUMBER() OVER (PARTITION BY l.ApplicationID ORDER BY l.StartDateTime DESC)  AS ExecutionRank
		FROM dbo.ApplicationExecutionInstance AS l
		--OUTER APPLY (
		--	SELECT    s.ApplicationID
		--		      , MIN(s.NextRunDateTime)      AS NextScheduleRunDateTime
		--	FROM      config.ApplicationSchedule  AS s
		--	WHERE     s.ApplicationID = l.ApplicationID
		--	GROUP BY  s.ApplicationID		
		--) s
		INNER JOIN  config.[Application]      AS a 
            ON  l.ApplicationID = a.ApplicationID
		INNER JOIN  config.FrameworkCodes     AS f 
            ON  f.FrameworkCode = l.StatusCode 
            AND f.CodeType      = 'Status'
		WHERE       a.IsDisabled    = '0'
	)

	SELECT    ApplicationID
		      , ApplicationName
		      , LastStartDateTime
		      , LastEndDateTime
		      , LastExecutionTime
		      , LastExecutionAborted
		      , LastStatusCodeDescription
		      --, NextScheduleRunDateTime
	FROM      cte
	WHERE     ExecutionRank = 1
	ORDER BY  ApplicationName

GO
