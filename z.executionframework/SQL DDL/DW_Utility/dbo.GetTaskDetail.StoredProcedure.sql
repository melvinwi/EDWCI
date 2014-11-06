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
