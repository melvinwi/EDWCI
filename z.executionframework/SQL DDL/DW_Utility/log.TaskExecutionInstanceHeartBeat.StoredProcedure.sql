USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [log].[TaskExecutionInstanceHeartBeat]
	@TaskExecutionInstanceID int
AS
	UPDATE dbo.TaskExecutionInstance
	SET
		StatusUpdateDateTime = getdate()
	WHERE TaskExecutionInstanceID = @TaskExecutionInstanceID
	
	
		
		
GO
