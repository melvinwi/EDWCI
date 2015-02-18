USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [reports].[GetTaskFailureSummary]
  ( @StartDate  DATETIME2(0) = NULL
  , @EndDate    DATETIME2(0) = NULL
  )
AS
  
/*
USAGE:
  EXEC [reports].[GetTaskFailureSummary] @StartDate = '20141219', @EndDate = NULL
*/

  IF @StartDate IS NULL
  BEGIN
    SET @EndDate = DATEADD(dd, -31, GETDATE())
  END

  IF @EndDate IS NULL
  BEGIN
    SET @EndDate = GETDATE()
  END

  SELECT      T.TaskId
            , T.TaskName 
            , T.PackagePath
            , T.StatusCode
            , COUNT(*)                            AS  FailureCount
            , MIN(T.StartDateTime)                AS  Min_StartDateTime
            , MAX(T.EndDateTime)                  AS  Max_EndDateTime
            , CAST(DATEDIFF(MINUTE, MIN(T.StartDateTime), MAX(T.EndDateTime)) / 1440.0 AS DECIMAL(8,2)) 
                                                  AS  DateRange_DayCount
            , MIN(T.TaskExecutionInstanceID)      AS  Min_TaskExecutionInstanceID
            , MAX(T.TaskExecutionInstanceID)      AS  Max_TaskExecutionInstanceID  
  FROM        dbo.TaskExecutionInstance AS  T
  INNER JOIN  config.FrameworkCodes     AS  F 
          ON  F.FrameworkCode = T.StatusCode 
          AND F.CodeType = 'Status'
  WHERE       T.StatusCode    IN ('F', 'P')
          AND T.EndDateTime   >= @StartDate
          AND T.StartDateTime <= @EndDate
  GROUP BY    T.TaskId
            , T.TaskName 
            , T.PackagePath
            , T.StatusCode
  ORDER BY    T.StatusCode
            , T.TaskName


GO
