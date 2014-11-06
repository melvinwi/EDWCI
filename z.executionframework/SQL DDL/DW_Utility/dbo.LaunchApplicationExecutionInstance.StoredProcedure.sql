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
