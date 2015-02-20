USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [config].[vPackagesInSSISDB] as 

  SELECT      fo.name COLLATE Latin1_General_CI_AS AS FolderName 
            , pr.name COLLATE Latin1_General_CI_AS AS ProjectName
            , pa.name COLLATE Latin1_General_CI_AS AS PackageName --PackageName and PackagePath should always be the same. If not, update the packages.
            , pa.name COLLATE Latin1_General_CI_AS AS PackagePath
  FROM        [SSISDB].[catalog].[folders]  AS fo
  INNER JOIN  [SSISDB].[catalog].[projects] AS pr
          ON  fo.folder_id = pr.folder_id
  INNER JOIN  [SSISDB].[catalog].[packages] AS pa
          ON  pa.project_id = pr.project_id


GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [config].[vPackagesInSSISDB] as 

  SELECT      fo.name COLLATE Latin1_General_CI_AS AS FolderName 
            , pr.name COLLATE Latin1_General_CI_AS AS ProjectName
            , pa.name COLLATE Latin1_General_CI_AS AS PackageName --PackageName and PackagePath should always be the same. If not, update the packages.
            , pa.name COLLATE Latin1_General_CI_AS AS PackagePath
  FROM        [SSISDB].[catalog].[folders]  AS fo
  INNER JOIN  [SSISDB].[catalog].[projects] AS pr
          ON  fo.folder_id = pr.folder_id
  INNER JOIN  [SSISDB].[catalog].[packages] AS pa
          ON  pa.project_id = pr.project_id

GO
