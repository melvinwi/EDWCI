USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [config].[GetEnvironmentReferenceId]
                @ProjectName  NVARCHAR(256) NULL
              , @FolderName   NVARCHAR(256) NULL
              , @ReferenceId  BIGINT        NULL OUTPUT
AS
  /*
  Schema            :   config
  Object            :   GetEnvironmentReferenceId
  Author            :   Jon Giles
  Created Date      :   23.10.2014
  Description       :   Returns the environment ReferenceId for the environment-project reference, that pertains to the latest execution of a running Application.

  Change  History   : 
  Author  Date          Description of Change
  JG      23.10.2014    Created
  <YOUR ROW HERE>     
  
  Usage:
        DECLARE   @ReferenceId  BIGINT = NULL
        
        EXEC  DW_Utility.config.GetEnvironmentReferenceId
                  @ProjectName  = N'DW'
                , @FolderName   = N'DW'
                , @ReferenceId  = @ReferenceId OUTPUT

        SELECT    @ReferenceId

  */

  SELECT      TOP 1 @ReferenceId      = er.reference_id
  FROM        [SSISDB].[catalog].[environment_references] AS er
  INNER JOIN  [SSISDB].[catalog].[executions]             AS x
              ON  x.environment_name  = er.environment_name
  INNER JOIN  [SSISDB].[catalog].[environments]           AS e 
              ON  e.name              = er.environment_name
  INNER JOIN  [SSISDB].[catalog].[projects]               AS p 
              ON  p.project_id        = er.project_id
  INNER JOIN  [SSISDB].[catalog].[folders]                AS f
              ON  f.folder_id         = p.folder_id
  WHERE       er.reference_type       = 'R'
              AND x.package_name      = 'Application.dtsx'
              AND x.[status]          = 2   --running
              AND x.server_name       = @@servername
              AND x.operation_type    = 200
              AND x.object_type       = 20  --project-level parameter
              AND p.name              = @ProjectName
              AND f.name              = @FolderName
  ORDER BY    x.execution_id DESC



GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [config].[GetEnvironmentReferenceId]
                @ProjectName  NVARCHAR(256) NULL
              , @FolderName   NVARCHAR(256) NULL
              , @ReferenceId  BIGINT        NULL OUTPUT
AS
  /*
  Schema            :   config
  Object            :   GetEnvironmentReferenceId
  Author            :   Jon Giles
  Created Date      :   23.10.2014
  Description       :   Returns the environment ReferenceId for the environment-project reference, that pertains to the latest execution of a running Application.

  Change  History   : 
  Author  Date          Description of Change
  JG      23.10.2014    Created
  <YOUR ROW HERE>     
  
  Usage:
        DECLARE   @ReferenceId  BIGINT = NULL
        
        EXEC  DW_Utility.config.GetEnvironmentReferenceId
                  @ProjectName  = N'DW'
                , @FolderName   = N'DW'
                , @ReferenceId  = @ReferenceId OUTPUT

        SELECT    @ReferenceId

  */

  SELECT      TOP 1 @ReferenceId      = er.reference_id
  FROM        [SSISDB].[catalog].[environment_references] AS er
  INNER JOIN  [SSISDB].[catalog].[executions]             AS x
              ON  x.environment_name  = er.environment_name
  INNER JOIN  [SSISDB].[catalog].[environments]           AS e 
              ON  e.name              = er.environment_name
  INNER JOIN  [SSISDB].[catalog].[projects]               AS p 
              ON  p.project_id        = er.project_id
  INNER JOIN  [SSISDB].[catalog].[folders]                AS f
              ON  f.folder_id         = p.folder_id
  WHERE       er.reference_type       = 'R'
              AND x.package_name      = 'Application.dtsx'
              AND x.[status]          = 2   --running
              AND x.server_name       = @@servername
              AND x.operation_type    = 200
              AND x.object_type       = 20  --project-level parameter
              AND p.name              = @ProjectName
              AND f.name              = @FolderName
  ORDER BY    x.execution_id DESC

GO
