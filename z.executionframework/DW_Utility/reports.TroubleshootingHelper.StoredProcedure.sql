USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [reports].[TroubleshootingHelper]
AS

  /*
  Schema            :   reports
  Object            :   TroubleshootingHelper
  Author            :   Jon Giles
  Created Date      :   31.10.2014
  Description       :   Provides useful commands for investigating errors and failures

  Change  History   : 
  Author  Date          Description of Change
  JG      31.10.2014    Created
  JG      12.11.2014    Added TaskId section
  JG      14.11.2014    Added TaskExecutionParameterLog
  <YOUR ROW HERE>     

  USAGE:
    EXEC [DW_Utility].[reports].[TroubleshootingHelper]
   */

PRINT
' 
  USE DW_Utility
  
  --Check Application history
  SELECT * FROM dbo.ApplicationExecutionInstance ORDER BY StartDateTime DESC

  EXEC [reports].[GetApplicationExecutionOverview] @ApplicationExecutionInstanceId = NULL

  EXEC [reports].[GetTaskHistory] @TaskId = 
  --/

  --Check Task Logs and Configuration
  DECLARE @TaskExecutionInstanceID INT = NULL
  SELECT * FROM log.TaskExecutionError WHERE TaskExecutionInstanceID = @TaskExecutionInstanceID
  SELECT * FROM log.TaskExecutionVariableLog WHERE TaskExecutionInstanceID = @TaskExecutionInstanceID
  SELECT * FROM log.TaskExecutionParameterLog WHERE TaskExecutionInstanceID = @TaskExecutionInstanceID

  DECLARE @TaskId INT = NULL
  SELECT * FROM config.Task WHERE TaskId = @TaskId
  SELECT * FROM config.TaskParameter WHERE TaskId = @TaskId
  --/

  --Miscellanous
    --EXEC  DW_Utility.dbo.RevertStagingTableLSN @SchemaName = NULL, @TableName = NULL, @LSN_State = NULL, @TaskExecutionInstanceID = NULL, @Debug = 1
  --/
'
GO
