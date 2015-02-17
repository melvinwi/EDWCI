USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LaunchTaskExecutionInstance]
	@TaskExecutionInstanceID int,
	@PkgExecutionID nvarchar(50)
AS
	DECLARE @PackageExecutionID uniqueidentifier

	SET @PackageExecutionID = CAST(@PkgExecutionID AS uniqueidentifier)

	UPDATE dbo.TaskExecutionInstance
	SET
		StatusCode = 'R', -- Started Code
		PackageExecutionID = @PackageExecutionID,
		StatusUpdateDateTime = getdate(),
		StartDateTime = getdate()
	WHERE TaskExecutionInstanceID = @TaskExecutionInstanceID
	
	
		
		
GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LaunchTaskExecutionInstance]
	  @TaskExecutionInstanceID  INT
  ,	@PkgExecutionID           NVARCHAR(50)
AS
	DECLARE @PackageExecutionID UNIQUEIDENTIFIER  = CAST(@PkgExecutionID AS UNIQUEIDENTIFIER)
  DECLARE @LogDtTime DATETIME2(2)               = GETDATE()

	UPDATE dbo.TaskExecutionInstance
	SET PackageExecutionID    = @PackageExecutionID
		--, StartDateTime         = GETDATE()
	  , StatusCode            = N'W'
    , StatusUpdateDateTime  = @LogDtTime
	WHERE TaskExecutionInstanceID = @TaskExecutionInstanceID

GO
