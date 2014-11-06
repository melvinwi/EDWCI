USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CompleteTaskExecutionInstance]
	  @TaskExecutionInstanceID INT
	, @TaskFailed BIT
AS
	DECLARE @LogDtTime DATETIME
	
	SET @LogDtTime = getdate()
	
	UPDATE dbo.TaskExecutionInstance
	SET StatusCode            = CASE WHEN (@TaskFailed = '0') THEN 'S' ELSE 'F' END
		, StatusUpdateDateTime  = @LogDtTime
		, EndDateTime           = @LogDtTime
	WHERE TaskExecutionInstanceID = @TaskExecutionInstanceID
	
	IF (@TaskFailed= '0')
	BEGIN
		UPDATE      t
		SET         LastRunDateTime = @LogDtTime
		FROM        config.Task               AS t
		INNER JOIN  dbo.TaskExecutionInstance AS l 
          ON    l.TaskID = t.TaskID
		WHERE       l.TaskExecutionInstanceID = @TaskExecutionInstanceID
	END
		
GO
