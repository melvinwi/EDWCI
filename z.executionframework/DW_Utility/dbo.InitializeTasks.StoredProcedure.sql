USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InitializeTasks]
	@ApplicationExecutionInstanceID int
AS
	SET NOCOUNT ON;
	
	DECLARE @ApplicationID int
	DECLARE @ErrorMessage nvarchar(255)
	
	IF  ( SELECT  COUNT(*)
		    FROM    dbo.TaskExecutionInstance
		    WHERE   ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
		  ) > 0
	BEGIN
		SET @ErrorMessage = 'Tasks cannot be intialized more than once (Application ExecutionInstance ID: ' +
			CONVERT(nvarchar(50), @ApplicationExecutionInstanceID) + ').'
		RAISERROR(@ErrorMessage, 10, 1)
		
		RETURN
	END
	
	
	SELECT  @ApplicationID = ApplicationID
	FROM    dbo.ApplicationExecutionInstance
	WHERE   ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
	
	INSERT INTO dbo.TaskExecutionInstance
	      ( ApplicationExecutionInstanceID
	      , TaskID
        , TaskName
	      , PrecedentTaskIds
	      , ExecuteAsync
	      , FailureActionCode
	      , RecoveryActionCode
	      , ParallelChannel
	      , ExecutionOrder
        , PackageName
        , ProjectName
        , FolderName
        , PackagePath
	      , StatusCode
	      , StatusUpdateDateTime
	      )	
	SELECT  @ApplicationExecutionInstanceID
		    , t.TaskID
        , t.TaskName
		    , t.PrecedentTaskIds	
		    , t.ExecuteAsync
		    , t.FailureActionCode
		    , t.RecoveryActionCode
		    , t.ParallelChannel
		    , t.ExecutionOrder
		    , p.PackageName
        , p.ProjectName
        , p.FolderName
        , p.PackagePath
        , 'I' -- Status Code for Pending
		    , getdate()
	FROM        config.Task t
	INNER JOIN  config.Package p 
        ON    t.PackageID = p.PackageID
	WHERE t.ApplicationID   = @ApplicationID 
	  AND t.IsActive        = '1'
	  AND t.IsDisabled      = '0'
	ORDER BY  t.ExecutionOrder ASC
          , t.TaskName ASC
GO
