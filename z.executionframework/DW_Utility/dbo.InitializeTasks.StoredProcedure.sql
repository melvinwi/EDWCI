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
    AND p.IsDisabled      = '0'
	ORDER BY  t.ExecutionOrder ASC
          , t.TaskName ASC
GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InitializeTasks]
	  @ApplicationExecutionInstanceID INT
  , @RecoveringApplicationExecutionInstanceID INT NULL
AS

  /*
  Schema            :   dbo
  Object            :   InitializeTasks
  Author            :   Jon Giles
  Created Date      :   long long ago
  Description       :   Insert TaskExecutionInstance records

  Change  History   : 
  Author  Date          Description of Change
  JG      20.01.2015    Modified to initialise fresh task execution instance records in recovery scenarios (previously, the existing records were reused)
  <YOUR ROW HERE>      

  Usage:
    EXEC dbo.InitializeTasks 12345, -1
  */

	SET NOCOUNT ON;
	
	DECLARE @ApplicationID int
	DECLARE @ErrorMessage nvarchar(255)
	
	IF EXISTS ( SELECT  'x'
		          FROM    dbo.TaskExecutionInstance
		          WHERE   ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
		        )
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
        , 'I' -- Status Code for Initialised
	      , getdate() --select *
	FROM        config.Task               AS  t
	INNER JOIN  config.Package            AS  p 
              ON  t.PackageID = p.PackageID
  LEFT OUTER JOIN dbo.TaskExecutionInstance AS  tei
              ON  tei.TaskID = t.TaskID
              AND tei.ApplicationExecutionInstanceID = @RecoveringApplicationExecutionInstanceID
              AND tei.RecoveryActionCode  =   'R'
              AND tei.StatusCode          <>  'S'
	WHERE t.ApplicationID   = @ApplicationID 
	  AND t.IsActive        = '1'
	  AND t.IsDisabled      = '0'
    AND p.IsDisabled      = '0'
    AND (   ISNULL(@RecoveringApplicationExecutionInstanceID, -1) <= 0
        OR  tei.ApplicationExecutionInstanceID IS NOT NULL  --If @RecoveringApplicationExecutionInstanceID has a positive value, restrict inserts to failed and recoverable tasks
        )
	ORDER BY  t.ExecutionOrder ASC
          , t.TaskName ASC
GO
