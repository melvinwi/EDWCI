USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTaskDetail]
	@TaskExecutionInstanceID int
AS

	SELECT
		ApplicationExecutionInstanceID,
		PackageName,
		PackagePath,
		FailureActionCode,
		ExecuteAsync
	FROM dbo.TaskExecutionInstance
	WHERE TaskExecutionInstanceID = @TaskExecutionInstanceID
GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTaskDetail]
	@TaskExecutionInstanceID INT
AS

/*
USAGE:
  EXEC [dbo].[GetTaskDetail] 39972
*/

	SELECT  ApplicationExecutionInstanceID
    		, PackageName
		    , PackagePath
		    , FailureActionCode
		    , ExecuteAsync
        , CASE WHEN NULLIF(PrecedentTaskIds, '') IS NULL THEN 1 ELSE 0 END AS PrecedentStatus
        , CAST(CASE WHEN StatusCode = N'A' THEN 1 ELSE 0 END AS BIT) AS TaskAborted
	FROM    dbo.TaskExecutionInstance
	WHERE   TaskExecutionInstanceID = @TaskExecutionInstanceID

GO
