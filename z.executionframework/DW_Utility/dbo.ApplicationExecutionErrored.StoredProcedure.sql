USE [DW_Utility]
GO
/****** Object:  StoredProcedure [dbo].[ApplicationExecutionErrored]    Script Date: 16/10/2014 7:18:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ApplicationExecutionErrored]
	@ApplicationExecutionID int,
	@ErrorCode int,
	@ErrorDescription ntext,
	@SourceName nvarchar(255)
AS
	UPDATE dbo.ApplicationExecutionInstance
	SET
		EndDateTime = getdate(),
		StatusCode = 'F'
	WHERE ApplicationExecutionInstanceID = @ApplicationExecutionID
	
	INSERT INTO log.ApplicationExecutionError
	(
		ApplicationExecutionInstanceID,
		ErrorCode,
		ErrorDescription,
		ErrorDateTime,
		SourceName	
	)
	VALUES
	(
		@ApplicationExecutionID,
		@ErrorCode,
		@ErrorDescription,
		getdate(),
		@SourceName
	)
GO
