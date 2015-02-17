USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [log].[LogTaskRowCount]
	                    @TaskExecutionInstanceID  INT     NULL
	                  , @ExtractRowCount          INT     NULL
	                  , @InsertRowCount           INT     NULL
	                  , @UpdateRowCount           INT     NULL
	                  , @DeleteRowCount           INT     NULL
	                  , @ErrorRowCount            INT	    NULL
AS

  /*
  Schema            : log
  Object            : LogTaskRowCount
  Author            : 
  Created Date      : <long long ago>
  Description       : Log Row Counts for Task Exectution Instance

  Change  History   : 
  Author  Date          Description of Change
  JG      26.08.2014    Set all parameters to be nullable
  <YOUR ROW HERE>     
  

  Usage:
    EXEC [log].[LogTaskRowCount]
          @TaskExecutionInstanceID = 0
        , @ExtractRowCount         = 0
        , @InsertRowCount          = 0
        , @UpdateRowCount          = 0
        , @DeleteRowCount          = NULL
        , @ErrorRowCount           = NULL
  */

	UPDATE  dbo.TaskExecutionInstance
	SET     ExtractRowCount = @ExtractRowCount
		    , InsertRowCount  = @InsertRowCount 
		    , UpdateRowCount  = @UpdateRowCount 
		    , DeleteRowCount  = @DeleteRowCount 
		    , ErrorRowCount   = @ErrorRowCount  
	WHERE   TaskExecutionInstanceID = @TaskExecutionInstanceID
GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [log].[LogTaskRowCount]
	                    @TaskExecutionInstanceID  INT     NULL
	                  , @ExtractRowCount          INT     NULL
	                  , @InsertRowCount           INT     NULL
	                  , @UpdateRowCount           INT     NULL
	                  , @DeleteRowCount           INT     NULL
	                  , @ErrorRowCount            INT	    NULL
AS

  /*
  Schema            : log
  Object            : LogTaskRowCount
  Author            : 
  Created Date      : <long long ago>
  Description       : Log Row Counts for Task Exectution Instance

  Change  History   : 
  Author  Date          Description of Change
  JG      26.08.2014    Set all parameters to be nullable
  <YOUR ROW HERE>     
  

  Usage:
    EXEC [log].[LogTaskRowCount]
          @TaskExecutionInstanceID = 0
        , @ExtractRowCount         = 0
        , @InsertRowCount          = 0
        , @UpdateRowCount          = 0
        , @DeleteRowCount          = NULL
        , @ErrorRowCount           = NULL
  */

	UPDATE  dbo.TaskExecutionInstance
	SET     ExtractRowCount = @ExtractRowCount
		    , InsertRowCount  = @InsertRowCount 
		    , UpdateRowCount  = @UpdateRowCount 
		    , DeleteRowCount  = @DeleteRowCount 
		    , ErrorRowCount   = @ErrorRowCount  
	WHERE   TaskExecutionInstanceID = @TaskExecutionInstanceID

GO
