USE [DW_Utility]
GO
/****** Object:  StoredProcedure [dbo].[ExecuteSSISCatalogPackage]    Script Date: 16/10/2014 7:18:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ExecuteSSISCatalogPackage] 
        @TaskExecutionInstanceID	INT
AS

 /*
  Schema          : dbo
  Object          : ExecuteSSISCatalogPackage
  Author          : Jon Giles
  Created Date    : 11.08.2014
  Description     : Executes an SSIS package within the context of the ETL Framework

  Change History  : 
  Author  Date        Description of Change
  JG      11/08/2014  Created based on  http://thinknook.com/execute-ssis-via-stored-procedure-ssis-2012-2012-08-13/
                                    and http://geekswithblogs.net/LifeLongTechie/archive/2012/11/14/time-to-stop-using-ldquoexecute-package-taskrdquondash-a-way-to.aspx
  JG      13/08/2014  Added cursor to set parameters, given the TaskId.
  JG      12/09/2014  Added section: If execution doesn't succeed, raise error
  JG      26/09/2014  Added TRY CATCH logic 
                      Raised error severity from 10 to 16 (to properly propagate the error).
  <YOUR ROW HERE>
  
  Usage:
    EXEC dbo.ExecuteSSISCatalogPackage @TaskExecutionInstanceID = 705


  Contents:
   1) Derive package parameters
   2) Create Execution record in SSISDB, and return an @Execution_Id
   3) Set execution to be synchronous
   4) Set any additional parameters (driven by the TaskId)
   5) Execute Package
   6) Error handling
  */

--
BEGIN TRY

  --Derive package parameters
  DECLARE @PackageName  NVARCHAR(256)
        , @FolderName   NVARCHAR(256)
        , @ProjectName  NVARCHAR(520)
        , @Reference_Id BIT
        , @Exec_Id      BIGINT
        , @TaskId       INT

  DECLARE @ErrorMessage NVARCHAR(4000)

  SELECT  @PackageName  =   PackageName
        ,	@FolderName   =   FolderName
        , @ProjectName  =   ProjectName
        , @TaskId       =   TaskId
  FROM    dbo.TaskExecutionInstance
  WHERE   TaskExecutionInstanceID = @TaskExecutionInstanceID
  --/

  --Create Execution record in SSISDB, and return an @Execution_Id
  EXEC    [SSISDB].[catalog].[create_execution]
          @Package_Name     =   @PackageName        --SSIS package name                     TABLE:  SELECT * FROM [SSISDB].internal.packages
        , @Folder_Name      =   @FolderName         --Folder were the package lives         TABLE:  SELECT * FROM [SSISDB].internal.folders
        , @Project_Name     =   @ProjectName        --Project name where SSIS package lives TABLE:  SELECT * FROM [SSISDB].internal.projects
        , @Use32bitruntime  =   FALSE 
        , @Reference_Id     =   NULL                --Environment reference, if null then no environment configuration is applied.
        , @Execution_Id     =   @Exec_Id OUTPUT;    --The parameter is outputed and contains the execution_id of your SSIS execution context.
  --/

  --Set execution to be synchronous. 
    --(Default SSIS-2012 behaviour is to execute asynchronously but, within the ETL framework, the asynchronous aspect is managed by the Application/TaskFactory/Task nesting.)
  EXEC    [SSISDB].[catalog].[set_execution_parameter_value]
          @execution_id     =   @Exec_Id
        , @object_type      =   50
        , @parameter_name   =   N'SYNCHRONIZED'
        , @parameter_value  =   1;  -- true
  --/

  --Set TaskExecutionInstanceID Parameter
  EXEC    [SSISDB].[catalog].[set_execution_parameter_value]
          @execution_id     =   @Exec_Id
        , @object_type      =   30
        , @parameter_name   =   N'TaskExecutionInstanceID' 
        , @parameter_value  =   @TaskExecutionInstanceID;
  --/
  
  --Set any additional parameters (as per the TaskId)
  DECLARE @ParameterName    NVARCHAR(128)
        , @ParameterValue   SQL_VARIANT  
        , @ObjectTypeId     SMALLINT     

  DECLARE @TaskParameter_Cursor CURSOR;

  SET @TaskParameter_Cursor = CURSOR FOR
      SELECT    [ParameterName]  
              , CAST([ParameterValue] AS NVARCHAR(128)) AS [ParameterValue]
              , [ObjectTypeId] 
      FROM      [config].[TaskParameter] 
      WHERE     [TaskId]      =   @TaskId
        AND     [IsDisabled]  <>  1
      ORDER BY  TaskParameterID

  OPEN  @TaskParameter_Cursor
      FETCH NEXT FROM @TaskParameter_Cursor INTO  @ParameterName  
                                                , @ParameterValue 
                                                , @ObjectTypeId     

  WHILE @@FETCH_STATUS = 0
    BEGIN
      EXEC  [SSISDB].[catalog].[set_execution_parameter_value]
            @execution_id     = @Exec_Id
          , @Object_Type      = @ObjectTypeId
          , @Parameter_Name   = @ParameterName
          , @Parameter_Value  = @ParameterValue

      FETCH NEXT FROM @TaskParameter_Cursor INTO  @ParameterName  
                                                , @ParameterValue 
                                                , @ObjectTypeId      
    END

  CLOSE @TaskParameter_Cursor
  DEALLOCATE @TaskParameter_Cursor
  --/

  --Execute Package
  EXEC [SSISDB].[catalog].[start_execution] @exec_id
  --/

  --If execution didn't succeed, raise error
  IF NOT EXISTS ( SELECT TOP 1 1
                  FROM  [SSISDB].[internal].[operations]
                  WHERE [operation_id] = @exec_id
                    AND [status] IN (7, 9)  --statuses:
                )                           --1: created
                                            --2: running
                                            --3: cancelled
                                            --4: failed
                                            --5: pending
                                            --6: ended unexpectedly
                                            --7: succeeded
                                            --8: stopping
                                            --9: completed
    BEGIN
      SET @ErrorMessage = N'DW_Utility.dbo.ExecuteSSISCatalogPackage Failed - TaskExecutionInstanceID: ' + CAST(@TaskExecutionInstanceID AS VARCHAR(10)) 
                        + N' , SSISDB operation_id: ' + ISNULL(CAST(@exec_id AS VARCHAR(10)), N'NULL')
                        + ISNULL(N' , Useful SQL: SELECT * FROM SSISDB.catalog.event_messages WHERE operation_id = ' + CAST(@exec_id AS VARCHAR(10)) 
                        + ' AND message_type IN (120, 130) ORDER BY message_time DESC', N'')
      
      RAISERROR (@ErrorMessage, 16, 1)
    END
  --/

END TRY
--/

--
BEGIN CATCH

  --Add Error Messages to DW_Utility.log.TaskExecutionError
  INSERT INTO [log].[TaskExecutionError]
        ( [TaskExecutionInstanceID]
        , [ErrorCode]
        , [ErrorDescription]
        , [ErrorDateTime]
        , [SourceName]
        )
  SELECT    @TaskExecutionInstanceID
          , message_code
          , [message]
          , message_time
          , N'DW_Utility.dbo.ExecuteSSISCatalogPackage ; ' + ISNULL(execution_path, N'NULL') 
            + ' ; SSISDB.operation_id:' + CAST(@exec_id AS VARCHAR(10)) + ';'
  FROM      ssisdb.[catalog].event_messages
  WHERE     operation_id  = @exec_id
    AND     message_type IN (120, 130) --(OnError, OnTaskFailed)
  ORDER BY  event_message_id
  --/

  --RethrowError
  EXEC dbo.RethrowError
  --/

END CATCH
--/
GO
