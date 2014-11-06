USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CompleteApplicationExecutionInstance]
  @ApplicationExecutionInstanceID INT 
AS

  /*
  Schema            :   dbo
  Object            :   CompleteApplicationExecutionInstance
  Author            :   Jon Giles
  Created Date      :   long long ago
  Description       :   Updates ApplicationExecutionInstance Status

  Change  History   : 
  Author  Date          Description of Change
  JG      31.10.2014    Added section: If any tasks failed set the status to 'Failed'
  <YOUR ROW HERE>     
   */

  DECLARE @Status NCHAR(1)
  
  --Default to 'Successful' ExecutionInstance
  SET @Status = 'S'
  --/

  --Any task that were initialized but not attempted set them to unattempted
  UPDATE dbo.TaskExecutionInstance
  SET StatusCode = 'U'
    , StatusUpdateDateTime = GETDATE()
  WHERE ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
    AND StatusCode = 'I'
  --/

  --If the application aborted set the status to 'Failed'
  IF  ( SELECT ExecutionAborted 
        FROM dbo.ApplicationExecutionInstance
        WHERE ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
      ) = '1'
  BEGIN
    SET @Status = 'F' 
  END
  
  --If any tasks failed set the status to 'Failed' 
  IF EXISTS ( SELECT 1
              FROM dbo.TaskExecutionInstance
              WHERE ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
                AND StatusCode = 'F'
            )
  BEGIN
    SET @Status = 'F' 
  END
  --/

  --Update ApplicationExecutionInstance Status
  UPDATE dbo.ApplicationExecutionInstance
  SET EndDateTime = GETDATE()
    , StatusCode = @Status
  WHERE ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
  --/
GO
