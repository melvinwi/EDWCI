USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [reports].[GetApplicationHistory]
(
	@ApplicationID int
)
AS
	SELECT  l.ApplicationExecutionInstanceID
		    , l.SSISExecutionID
		    , f.CodeDescription                   AS StatusCodeDescription
		    , r.CodeDescription                   AS RecoveryActionCodeDescription
		    , l.ApplicationName
		    , l.StartDateTime
		    , l.EndDateTime
		    , CAST(DATEDIFF(n, l.StartDateTime, l.EndDateTime) AS varchar(50)) 
          + ':' 
          + RIGHT('0' + CAST(DATEDIFF(s, l.StartDateTime, l.EndDateTime) AS varchar(50)), 2) 
          + ':' 
          + CAST(DATEDIFF(ms, l.StartDateTime, l.EndDateTime) AS varchar(50))           AS ExecutionTime
		    , CASE WHEN (l.ExecutionAborted = '0') THEN 'False' ELSE 'True' END             AS ExecutionAborted
	      --, CASE WHEN (l.ApplicationScheduleID IS NULL) THEN 'False' ELSE 'True' END AS ScheduledExecution
	FROM        dbo.ApplicationExecutionInstance l
	INNER JOIN  config.[Application]            AS a 
          ON  l.ApplicationID = a.ApplicationID
	INNER JOIN  config.FrameworkCodes           AS f 
          ON  f.FrameworkCode = l.StatusCode 
          AND f.CodeType='Run Status'
	INNER JOIN  config.FrameworkCodes           AS r 
          ON  r.FrameworkCode = l.RecoveryActionCode 
          AND r.CodeType='Recovery Mode'
	WHERE l.ApplicationID = @ApplicationID
	AND a.IsDisabled='0'
	ORDER BY l.StartDateTime DESC
GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [reports].[GetApplicationHistory]
(
	@ApplicationID int
)
AS
	SELECT  l.ApplicationExecutionInstanceID
		    , l.SSISExecutionID
		    , f.CodeDescription                   AS StatusCodeDescription
		    , r.CodeDescription                   AS RecoveryActionCodeDescription
		    , l.ApplicationName
		    , l.StartDateTime
		    , l.EndDateTime
		    , CAST(DATEDIFF(n, l.StartDateTime, l.EndDateTime) AS varchar(50)) 
          + ':' 
          + RIGHT('0' + CAST(DATEDIFF(s, l.StartDateTime, l.EndDateTime) AS varchar(50)), 2) 
          + ':' 
          + CAST(DATEDIFF(ms, l.StartDateTime, l.EndDateTime) AS varchar(50))           AS ExecutionTime
		    , CASE WHEN (l.ExecutionAborted = '0') THEN 'False' ELSE 'True' END             AS ExecutionAborted
	      --, CASE WHEN (l.ApplicationScheduleID IS NULL) THEN 'False' ELSE 'True' END AS ScheduledExecution
	FROM        dbo.ApplicationExecutionInstance l
	INNER JOIN  config.[Application]            AS a 
          ON  l.ApplicationID = a.ApplicationID
	INNER JOIN  config.FrameworkCodes           AS f 
          ON  f.FrameworkCode = l.StatusCode 
          AND f.CodeType='Status'
	INNER JOIN  config.FrameworkCodes           AS r 
          ON  r.FrameworkCode = l.RecoveryActionCode 
          AND r.CodeType='Recovery Mode'
	WHERE l.ApplicationID = @ApplicationID
	AND a.IsDisabled='0'
	ORDER BY l.StartDateTime DESC

GO
