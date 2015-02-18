USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IsApplicationAborted]
	@ApplicationExecutionInstanceID int
AS
	SELECT
		ExecutionAborted
	FROM dbo.ApplicationExecutionInstance
	WHERE ApplicationExecutionInstanceID=@ApplicationExecutionInstanceID
GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IsApplicationAborted]
	@ApplicationExecutionInstanceID int
AS
	SELECT
		ExecutionAborted
	FROM dbo.ApplicationExecutionInstance
	WHERE ApplicationExecutionInstanceID=@ApplicationExecutionInstanceID

GO
