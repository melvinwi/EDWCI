USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [config].[AddApplicationPackageTask]
          @App_ApplicationName        NVARCHAR(100) 
        , @App_RecoveryActionCode     NCHAR(1) 
        , @App_AllowParallelExecution NCHAR(1) 
        , @App_ParallelChannels       TINYINT
        , @App_IsDisabled             TINYINT

        , @Pac_PackagePath            VARCHAR (1035)
        , @Pac_PackageName            VARCHAR (256)
        , @Pac_ProjectName            VARCHAR (520)
        , @Pac_FolderName             VARCHAR (1035)
        , @Pac_IsDisabled             BIT

        , @Task_TaskName              NVARCHAR(255) 
        , @Task_ParallelChannel       INT                      
        , @Task_ExecutionOrder        INT                      
        , @Task_PrecedentTaskIds      NVARCHAR(1000)
        , @Task_ExecuteAsync          BIT           
        , @Task_FailureActionCode     NCHAR(1)      
        , @Task_RecoveryActionCode    NCHAR(1)      
        , @Task_IsActive              BIT           
        , @Task_IsDisabled            BIT           
  AS                                  
                                      
  /*
  Usage:
    EXEC config.AddApplicationPackageTask
           --SELECT TOP 100 * FROM config.Application
          @App_ApplicationName        = N'DW_Staging - Time Of Use'
        , @App_RecoveryActionCode     = N'N'
        , @App_AllowParallelExecution = 0
        , @App_ParallelChannels       = 1
        , @App_IsDisabled             = 0
          --SELECT TOP 100 * FROM config.Package ORDER BY PackageId DESC
        , @Pac_PackagePath            = N'XML - Import - AEMO - Level2SettlementReconciliation.dtsx'   
        , @Pac_PackageName            = N'XML - Import - AEMO - Level2SettlementReconciliation.dtsx'
        , @Pac_ProjectName            = N'DW'
        , @Pac_FolderName             = N'DW'
        , @Pac_IsDisabled             = 0
          --SELECT TOP 100 * FROM config.Task ORDER BY TaskId DESC
        , @Task_TaskName              = N'XML - Import - AEMO - Level2SettlementReconciliation' 
        , @Task_ParallelChannel       = 1
        , @Task_ExecutionOrder        = 100
        , @Task_PrecedentTaskIds      = NULL
        , @Task_ExecuteAsync          = 0
        , @Task_FailureActionCode     = N'C'
        , @Task_RecoveryActionCode    = N'N'
        , @Task_IsActive              = 1
        , @Task_IsDisabled            = 0

  */                                          

  --Declare additional parameters
  DECLARE @ApplicationId                      INT
        , @TaskId                             INT
        , @PackageId                          INT
  --/
  
  --Upsert Application
  SELECT  @ApplicationId = ApplicationId 
  FROM    config.[Application] 
  WHERE   ApplicationName = @App_ApplicationName

  EXEC [config].[procSetApplication]  @ApplicationID          = @ApplicationId
	                                  , @ApplicationName        = @App_ApplicationName
	                                  , @RecoveryActionCode     = @App_RecoveryActionCode
	                                  , @AllowParallelExecution = @App_AllowParallelExecution
	                                  , @ParallelChannels       = @App_ParallelChannels
	                                  , @IsDisabled             = @App_IsDisabled
  
  SELECT  @ApplicationId = ApplicationId 
  FROM    config.[Application] 
  WHERE   ApplicationName = @App_ApplicationName
  --/

  --Upsert Package
  PRINT 'EXEC config.PopulatePackage'
  EXEC config.PopulatePackage

  SELECT  @PackageId = PackageId 
  FROM    config.[Package] 
  WHERE   PackageName = @Pac_PackageName

  EXEC  [config].[procSetPackage]
      @PackageId    = @PackageId    
    , @PackagePath  = @Pac_PackagePath  
    , @PackageName  = @Pac_PackageName  
    , @ProjectName  = @Pac_ProjectName  
    , @FolderName   = @Pac_FolderName   
    , @IsDisabled   = @Pac_IsDisabled  

  SELECT  @PackageId = PackageId 
  FROM    config.[Package] 
  WHERE   PackageName = @Pac_PackageName     
  --/
  
  --Upsert Task
  SELECT  @TaskId = TaskId 
  FROM    config.Task 
  WHERE   TaskName = @Task_TaskName

  EXEC config.procSetTask @TaskId             = @TaskId
                        , @TaskName           = @Task_TaskName             
                        , @ApplicationId      = @ApplicationId
                        , @PackageId          = @PackageId
                        , @ParallelChannel    = @Task_ParallelChannel      
                        , @ExecutionOrder     = @Task_ExecutionOrder       
                        , @PrecedentTaskIds   = @Task_PrecedentTaskIds     
                        , @ExecuteAsync       = @Task_ExecuteAsync         
                        , @FailureActionCode  = @Task_FailureActionCode    
                        , @RecoveryActionCode = @Task_RecoveryActionCode   
                        , @IsActive           = @Task_IsActive             
                        , @IsDisabled         = @Task_IsDisabled           

  SELECT  @TaskId = TaskId 
  FROM    config.Task 
  WHERE   TaskName = @Task_TaskName
  --/

  --
  PRINT 'EXEC config.PopulateTaskParameter'
  EXEC config.PopulateTaskParameter

  SELECT  
  'EXEC  [config].[procSetTaskParameter] @TaskParameterID  = ' + CAST(TaskParameterID as nvarchar(10))    + ' 
 , @TaskID = ' + CAST(TaskID as nvarchar(10))                      + ' 
 , @ParameterName = ''' + ParameterName                          + ''' 
 , @ParameterValue = ''' + CAST(ParameterValue as nvarchar(100)) + ''' 
 , @ObjectType = ''' + ObjectType                                + ''' 
 , @IsDisabled = ' + CASE WHEN IsDisabled = 1 then '1' ELSE '0' END
  FROM  config.TaskParameter
  WHERE TaskId = @TaskId
  --/
GO
