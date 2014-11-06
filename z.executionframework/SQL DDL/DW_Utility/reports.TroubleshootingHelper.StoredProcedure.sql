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
  <YOUR ROW HERE>     
   */

PRINT
' 
  USE DW_Utility
  
  SELECT * FROM dbo.ApplicationExecutionInstance ORDER BY StartDateTime DESC

  EXEC [reports].[GetApplicationExecutionOverview] NULL

  DECLARE @TaskExecutionInstanceID INT = NULL
  SELECT * FROM log.TaskExecutionError WHERE TaskExecutionInstanceID = @TaskExecutionInstanceID
  SELECT * FROM log.TaskExecutionVariableLog WHERE TaskExecutionInstanceID = @TaskExecutionInstanceID

  EXEC  DW_Utility.dbo.RevertStagingTableLSN @SchemaName = NULL, @TableName = NULL, @LSN_State = NULL, @TaskExecutionInstanceID = NULL, @Debug = 1
'
GO
