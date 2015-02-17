USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [config].[PopulatePackage] AS

--
INSERT INTO config.package  ( FolderName
                            , ProjectName
                            , PackageName
                            , PackagePath 
                            )
SELECT  FolderName    AS FolderName 
      , ProjectName   AS ProjectName
      , PackageName   AS PackageName
      , PackagePath   AS PackagePath
FROM    config.vPackagesInSSISDB
WHERE   NOT (   FolderName  =   'DW'      --We don't want to add the ETL Framework packages
            AND ProjectName	=   'ETL_Framework' 
            AND PackagePath IN  ( 'Application.dtsx'
                                , 'Task.dtsx'
                                , 'TaskFactory.dtsx'
                                )
            )
        AND ProjectName	IN  ( 'DW'        --We only want to add packages in these projects
                            , 'ETL_Framework'
                            )
EXCEPT
SELECT  FolderName
      , ProjectName
      , PackageName
      , PackagePath
FROM    config.package
--/
GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [config].[PopulatePackage] AS

/*
USAGE:
  EXEC [config].[PopulatePackage]  
*/

--
INSERT INTO config.package  ( FolderName
                            , ProjectName
                            , PackageName
                            , PackagePath 
                            )


OUTPUT  INSERTED.PackageID
      , INSERTED.PackagePath
      , INSERTED.PackageName
      , INSERTED.ProjectName
      , INSERTED.FolderName
      , INSERTED.IsDisabled

SELECT  FolderName    AS FolderName 
      , ProjectName   AS ProjectName
      , PackageName   AS PackageName
      , PackagePath   AS PackagePath
FROM    config.vPackagesInSSISDB
WHERE   NOT (   FolderName  =   'DW'      --We don't want to add the ETL Framework packages
            AND ProjectName	=   'ETL_Framework' 
            AND PackagePath IN  ( 'Application.dtsx'
                                , 'Task.dtsx'
                                , 'TaskFactory.dtsx'
                                )
            )
        AND ProjectName	IN  ( 'DW'        --We only want to add packages in these projects
                            , 'ETL_Framework'
                            )
EXCEPT
SELECT  FolderName
      , ProjectName
      , PackageName
      , PackagePath
FROM    config.package
--/

GO
