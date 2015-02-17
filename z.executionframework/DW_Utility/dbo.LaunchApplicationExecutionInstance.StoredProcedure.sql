USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LaunchApplicationExecutionInstance]
	  @ApplicationID INT
	, @SSISExecutionInstanceID BIGINT
	, @PkgExecutionID NVARCHAR(50)
AS

  /*
  Schema            :   dbo
  Object            :   LaunchApplicationExecutionInstance
  Author            :   Jon Giles
  Created Date      :   long long ago
  Description       :   Create / recover / execute an ApplicationExecutionInstance

  Change  History   : 
  Author  Date          Description of Change
  JG      31.10.2014    Added condition: if we are recovering an ApplicationExecutionInstance, it must contain failed tasks that are recoverable.
  <YOUR ROW HERE>     
  */

	SET NOCOUNT ON;
	
	DECLARE @ApplicationExecutionInstanceID INT
	DECLARE @out                            TABLE(ExecutionInstanceID INT)
	DECLARE @RecoveryActionCode             NCHAR(1)
	DECLARE @StatusCode                     NCHAR(1)
	DECLARE @ApplicationName                NVARCHAR(50)
	DECLARE @IsApplicationRecovery          BIT
	DECLARE @PackageExecutionID             UNIQUEIDENTIFIER  = CAST(@PkgExecutionID AS UNIQUEIDENTIFIER)

	--If we are running an initialized app, or if we are recovering an app (with tasks that can be recovered), set the relevant parameters
	SELECT  @ApplicationName = AE.ApplicationName
		    , @ApplicationExecutionInstanceID = AE.ApplicationExecutionInstanceID
		    , @StatusCode = AE.StatusCode
	FROM        dbo.ApplicationExecutionInstance  AS AE
  INNER JOIN  dbo.TaskExecutionInstance         AS TE
              ON TE.ApplicationExecutionInstanceID = AE.ApplicationExecutionInstanceID
	WHERE   AE.ApplicationID = @ApplicationID
	    AND (   AE.StatusCode = 'I'
	        OR  (   AE.StatusCode = 'F' 
              AND AE.RecoveryActionCode = 'R'
              AND TE.StatusCode = 'F' 
              AND TE.RecoveryActionCode = 'R'
              )
          )
  GROUP BY  AE.ApplicationName
          , AE.ApplicationExecutionInstanceID
          , AE.StatusCode
	--/
  
  --Create a new app execution instance, or begin executing the existing one:
	IF @ApplicationExecutionInstanceID IS NULL
	  BEGIN
		  --Get the application info
		  SELECT  @ApplicationName = ApplicationName
  	  		  , @RecoveryActionCode = RecoveryActionCode
		  FROM    config.[Application]
		  WHERE   ApplicationID = @ApplicationID
		
		  SET @IsApplicationRecovery = '0'
		
		  --Insert our app ExecutionInstance record and get the id		
		  INSERT INTO dbo.ApplicationExecutionInstance
		  (
			  ApplicationID,
			    --ApplicationScheduleID,
			  ApplicationName,
			  RecoveryActionCode,
			  SSISExecutionID,
			  PackageExecutionID,
			  StartDateTime,
			  StatusCode,
			  ExecutionAborted			
		  )
		  OUTPUT INSERTED.ApplicationExecutionInstanceID INTO @out
		  VALUES
		  (
			  @ApplicationID,
			    --@ApplicationScheduleID,
			  @ApplicationName,
			  @RecoveryActionCode,
			  @SSISExecutionInstanceID,
			  @PackageExecutionID,
			  getdate(),
			  'E',
			  '0'
		  )
		
		  SELECT @ApplicationExecutionInstanceID = ExecutionInstanceID FROM @out
      --/
	  END
	
  ELSE
	
    BEGIN
		  --This is either an initialised ExecutionInstance or one we are recovering		
		  IF @StatusCode = 'F' --We are recovering the app
		  BEGIN		
			  SET @IsApplicationRecovery = '1'
		  END
		
		  UPDATE dbo.ApplicationExecutionInstance
		  SET SSISExecutionID     = @SSISExecutionInstanceID
			  , PackageExecutionID  = @PackageExecutionID
			  , StartDateTime       = GETDATE()
			  , StatusCode          = 'E'
			  , ExecutionAborted    = '0'
		  WHERE   ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
      --/
	  END
  --/
	
  --Return outputs
	SELECT  @ApplicationExecutionInstanceID AS ApplicationExecutionInstanceID
        , @ApplicationName                AS ApplicationName              
        , @IsApplicationRecovery          AS IsApplicationRecovery
  --/
GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LaunchApplicationExecutionInstance]
	  @ApplicationID INT
	, @SSISExecutionInstanceID BIGINT
	, @PkgExecutionID NVARCHAR(50)
AS

  /*
  Schema            :   dbo
  Object            :   LaunchApplicationExecutionInstance
  Author            :   Jon Giles
  Created Date      :   long long ago
  Description       :   Create / recover / execute an ApplicationExecutionInstance

  Change  History   : 
  Author  Date          Description of Change
  JG      31.10.2014    Added condition: if we are recovering an ApplicationExecutionInstance, it must contain failed tasks that are recoverable.
  JG      08.01.2014    Changed TE.StatusCode condition from: = 'F' to: <> 'S'
  JG      20.01.2015    Modified to initialise fresh application execution instance records in recovery scenarios (previously, the existing records were reused)
  <YOUR ROW HERE>     

  Usage:
    EXEC dbo.LaunchApplicationExecutionInstance 11, 55555, N'FBE0AF00-51F7-4AE5-B94D-A8AF8A86EC22'
  */

	SET NOCOUNT ON;
	
	DECLARE @ApplicationExecutionInstanceID           INT
	DECLARE @RecoveryActionCode                       NCHAR(1)
	DECLARE @StatusCode                               NCHAR(1)
	DECLARE @ApplicationName                          NVARCHAR(50)
  DECLARE @PackageExecutionID                       UNIQUEIDENTIFIER  = CAST(@PkgExecutionID AS UNIQUEIDENTIFIER)
	DECLARE @RecoveringApplicationExecutionInstanceID INT
  DECLARE @TasksAreInitialised                      BIT = 0

	--Determine if we are running an initialised app or if we are recovering an app (with tasks that can be recovered), and set the relevant parameters
	SELECT  @ApplicationName = AE.ApplicationName
		    , @ApplicationExecutionInstanceID = AE.ApplicationExecutionInstanceID
		    , @StatusCode = AE.StatusCode
	FROM        dbo.ApplicationExecutionInstance  AS AE
  INNER JOIN  dbo.TaskExecutionInstance         AS TE
              ON TE.ApplicationExecutionInstanceID = AE.ApplicationExecutionInstanceID
	WHERE   AE.ApplicationID = @ApplicationID
	    AND (   AE.StatusCode = 'I'
	        OR  (   AE.StatusCode = 'F' 
              AND AE.RecoveryActionCode = 'R'
              AND TE.StatusCode <> 'S'        --Edited on: 08.01.2014
              AND TE.RecoveryActionCode = 'R'
              )
          )
  GROUP BY  AE.ApplicationName
          , AE.ApplicationExecutionInstanceID
          , AE.StatusCode
	--/
  
  --Get the application info
  SELECT  @ApplicationName = ApplicationName
  		  , @RecoveryActionCode = RecoveryActionCode
  FROM    config.[Application]
  WHERE   ApplicationID = @ApplicationID
  --/

  --If we are recovering a failed application, mark it as 'Recovery Initialised' to prevent further recoveries of this instance.
  IF  @ApplicationExecutionInstanceID IS NOT NULL 
      AND @StatusCode = 'F'
    BEGIN		
      SET @RecoveringApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
      
      UPDATE  dbo.ApplicationExecutionInstance
      SET     RecoveryActionCode = 'I' --NB. This is RecoveryActionCode, not Status Code
      WHERE   ApplicationExecutionInstanceID = @RecoveringApplicationExecutionInstanceID
    END
  --/
	
  --Create a new app execution instance, or indicate that the app and tasks have already been initialised
  IF ISNULL(@StatusCode, '') <> 'I' --application has not already been initialised
	  BEGIN
  	  --Insert our app ExecutionInstance record and get the id		
		  INSERT INTO dbo.ApplicationExecutionInstance
		  (
			  ApplicationID,
			  ApplicationName,
			  RecoveryActionCode,
			  SSISExecutionID,
			  PackageExecutionID,
			  StartDateTime,
			  StatusCode,
			  ExecutionAborted			
		  )
		  VALUES
		  (
			  @ApplicationID,
			  @ApplicationName,
			  @RecoveryActionCode,
			  @SSISExecutionInstanceID,
			  @PackageExecutionID,
			  getdate(),
			  'R',
			  0
		  )
		  SET @ApplicationExecutionInstanceID = SCOPE_IDENTITY()

    END
  ELSE
    BEGIN
      SET @TasksAreInitialised = 1
    END

  --Return outputs
	SELECT  @ApplicationExecutionInstanceID           AS ApplicationExecutionInstanceID
        , @ApplicationName                          AS ApplicationName              
        , @RecoveringApplicationExecutionInstanceID AS RecoveringApplicationExecutionInstanceID
        , @TasksAreInitialised                      AS TasksAreInitialised
  --/

GO
