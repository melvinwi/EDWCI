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
  JG      14.11.2014    Changed section: If any tasks failed set the status to 'Failed' to: If any tasks not successful, set the status to 'Failed' 
  <YOUR ROW HERE>     
   */

  
  --Default to 'Successful' ExecutionInstance
  DECLARE @Status NCHAR(1) = 'S'
  --/

  --If any tasks that were initialized but not attempted, set them to unattempted
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

  OR  --If any tasks not successful, set the status to 'Failed' 
    EXISTS ( SELECT 1
              FROM dbo.TaskExecutionInstance
              WHERE ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
                AND StatusCode <> 'S' --IN ('E', 'F', 'U', 'P')
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
  JG      14.11.2014    Changed section: If any tasks failed set the status to 'Failed' to: If any tasks not successful, set the status to 'Failed' 
  JG      28.01.2015    Added code 'W' to section: If any tasks are in progress, set them to aborted.
  <YOUR ROW HERE>     

  USAGE
    EXEC [dbo].[CompleteApplicationExecutionInstance] @ApplicationExecutionInstanceID = 508

   */

  
  --Default to 'Successful' ExecutionInstance
  DECLARE @Status NCHAR(1) = 'S'
  --/

  --If any tasks were initialized but not attempted, set them to unattempted
  UPDATE dbo.TaskExecutionInstance
  SET StatusCode = 'U'
    , StatusUpdateDateTime = GETDATE()
  WHERE ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
    AND StatusCode = 'I'
  --/
  
  --If any tasks are in progress, set them to aborted
  UPDATE dbo.TaskExecutionInstance
  SET StatusCode = 'A'
    , StatusUpdateDateTime = GETDATE()
  WHERE ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
    AND StatusCode IN ('R', 'W')
  --/

  --If the application aborted set the status to 'Failed'
  IF  ( SELECT ExecutionAborted 
        FROM dbo.ApplicationExecutionInstance
        WHERE ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
      ) = '1'

  OR  --If any tasks were not successful, set the status to 'Failed' 
    EXISTS ( SELECT 1
              FROM dbo.TaskExecutionInstance
              WHERE ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
                AND StatusCode <> 'S' --IN ('E', 'F', 'U', 'P')
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
