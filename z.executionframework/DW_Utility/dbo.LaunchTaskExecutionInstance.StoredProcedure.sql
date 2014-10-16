USE [DW_Utility]
GO
/****** Object:  StoredProcedure [dbo].[LaunchTaskExecutionInstance]    Script Date: 16/10/2014 7:18:30 PM ******/
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
