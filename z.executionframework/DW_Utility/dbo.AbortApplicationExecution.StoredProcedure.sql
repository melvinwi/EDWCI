USE [DW_Utility]
GO
/****** Object:  StoredProcedure [dbo].[AbortApplicationExecution]    Script Date: 16/10/2014 7:18:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AbortApplicationExecution]
	@ApplicationExecutionInstanceID int
AS
	UPDATE dbo.ApplicationExecutionInstance
	SET
		ExecutionAborted = '1',
		StatusCode = 'F'
	WHERE ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID

GO
