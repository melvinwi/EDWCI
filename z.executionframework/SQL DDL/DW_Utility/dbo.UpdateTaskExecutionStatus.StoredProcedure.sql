USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateTaskExecutionStatus]
	@TaskExecutionID int,
	@StatusCode nchar(1)
AS
	UPDATE dbo.TaskExecutionInstance
	SET
		StatusCode = @StatusCode,
		StatusUpdateDateTime = getdate()
	WHERE TaskExecutionInstanceID = @TaskExecutionID
GO
