USE [DW_Utility]
GO
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
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AbortApplicationExecution]
	@ApplicationExecutionInstanceID int
AS

/*
EXEC [dbo].[AbortApplicationExecution] @ApplicationExecutionInstanceID = 530
*/

	UPDATE  dbo.ApplicationExecutionInstance
	SET     ExecutionAborted = '1'
        , StatusCode = 'F'
	WHERE ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID

  --Tidy up ExecutionInstance tables
  EXEC [dbo].[CompleteApplicationExecutionInstance] @ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
  --/
GO
