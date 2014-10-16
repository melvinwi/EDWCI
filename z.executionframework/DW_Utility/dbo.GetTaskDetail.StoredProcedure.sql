USE [DW_Utility]
GO
/****** Object:  StoredProcedure [dbo].[GetTaskDetail]    Script Date: 16/10/2014 7:18:30 PM ******/
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
