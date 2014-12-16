USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateTaskExecutionStatus]
	  @TaskExecutionID INT
  ,	@StatusCode NCHAR(1)
AS
	DECLARE @LogDtTime DATETIME2(2) = GETDATE()

	UPDATE dbo.TaskExecutionInstance
	SET StatusCode            = @StatusCode
    , StatusUpdateDateTime  = @LogDtTime
		, EndDateTime           = @LogDtTime --20141114 - Added
	WHERE TaskExecutionInstanceID = @TaskExecutionID
GO
