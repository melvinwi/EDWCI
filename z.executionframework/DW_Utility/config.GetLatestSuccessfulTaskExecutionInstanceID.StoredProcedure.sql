USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [config].[GetLatestSuccessfulTaskExecutionInstanceID]
                @TaskExecutionInstanceID                  INT   NULL
              , @LatestSuccessfulTaskExecutionInstanceID  INT   NULL OUTPUT


AS

  /*
  Schema            :   config
  Object            :   GetLatestSuccessfulTaskExecutionInstanceID
  Author            :   Jon Giles
  Created Date      :   26.08.2014
  Description       :   Returns latest successful TaskExecutionInstanceID for the task
                        Created to support filtering of source data on [Meta_LatestUpdate_TaskExecutionInstanceId] thereby preventing repeat processing of unchanged data.)

  Change  History   : 
  Author  Date          Description of Change
  JG      26.08.2014    Created
  <YOUR ROW HERE>     
  
  Usage:
        DECLARE   @LatestSuccessfulTaskExecutionInstanceID  INT = NULL
        
        EXEC  DW_Utility.config.GetLatestSuccessfulTaskExecutionInstanceID
                  @TaskExecutionInstanceID                  = 133
                , @LatestSuccessfulTaskExecutionInstanceID  = @LatestSuccessfulTaskExecutionInstanceID OUTPUT

        SELECT    @LatestSuccessfulTaskExecutionInstanceID

  */

  SELECT      @LatestSuccessfulTaskExecutionInstanceID = ISNULL(MAX(TaskExecutionInstanceID), -1)

  FROM        dbo.TaskExecutionInstance   AS TEI
  INNER JOIN  config.FrameworkCodes       AS FC
        ON    FC.FrameworkCode    = TEI.StatusCode
        AND   FC.CodeType         = 'Task Status'
        AND   FC.CodeDescription  = 'Successful - Task'
  
  WHERE       TEI.TaskID          
                = ( SELECT TaskId 
                    FROM dbo.TaskExecutionInstance
                    WHERE TaskExecutionInstanceID = @TaskExecutionInstanceID
                  )
        AND   TEI.TaskExecutionInstanceID < @TaskExecutionInstanceID

GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [config].[GetLatestSuccessfulTaskExecutionInstanceID]
                @TaskExecutionInstanceID                  INT   NULL
              , @LatestSuccessfulTaskExecutionInstanceID  INT   NULL OUTPUT


AS

  /*
  Schema            :   config
  Object            :   GetLatestSuccessfulTaskExecutionInstanceID
  Author            :   Jon Giles
  Created Date      :   26.08.2014
  Description       :   Returns latest successful TaskExecutionInstanceID for the task
                        Created to support filtering of source data on [Meta_LatestUpdate_TaskExecutionInstanceId] thereby preventing repeat processing of unchanged data.)

  Change  History   : 
  Author  Date          Description of Change
  JG      26.08.2014    Created
  <YOUR ROW HERE>     
  
  Usage:
        DECLARE   @LatestSuccessfulTaskExecutionInstanceID  INT = NULL
        
        EXEC  DW_Utility.config.GetLatestSuccessfulTaskExecutionInstanceID
                  @TaskExecutionInstanceID                  = 133
                , @LatestSuccessfulTaskExecutionInstanceID  = @LatestSuccessfulTaskExecutionInstanceID OUTPUT

        SELECT    @LatestSuccessfulTaskExecutionInstanceID

  */

  SELECT      @LatestSuccessfulTaskExecutionInstanceID = ISNULL(MAX(TaskExecutionInstanceID), -1)

  FROM        dbo.TaskExecutionInstance   AS TEI
  INNER JOIN  config.FrameworkCodes       AS FC
        ON    FC.FrameworkCode    = TEI.StatusCode
        AND   FC.CodeType         = 'Status'
        AND   FC.CodeDescription  = 'Successful'
  
  WHERE       TEI.TaskID          
                = ( SELECT TaskId 
                    FROM dbo.TaskExecutionInstance
                    WHERE TaskExecutionInstanceID = @TaskExecutionInstanceID
                  )
        AND   TEI.TaskExecutionInstanceID < @TaskExecutionInstanceID
GO
