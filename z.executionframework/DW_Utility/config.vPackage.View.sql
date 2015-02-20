USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [config].[vPackage] as
  /*
  Schema            : config
  Object            : vPackage
  Author            : Jon Giles
  Created Date      : 01.10.2014
  Description       : A view of config.packages, with additional info

  Change  History   : 
  Author  Date          Description of Change
  JG      01.10.2014    Created
  {YOUR ROW HERE}     

  Usage:
    SELECT * FROM [config].[vPackage]
  */

 WITH  TaskPackages AS 
        ( SELECT    PackageId
                  , COUNT(*)                                                          AS TaskCount
                  , SUM(CASE WHEN IsActive = 1 AND IsDisabled = 0 THEN 1 ELSE 0 END)  AS ActiveEnabledTaskCount
          FROM      config.Task
          GROUP BY  PackageId
        )

  SELECT          P.PackageID
                , P.FolderName 
                , P.ProjectName
                , P.PackageName
                , P.PackagePath
                , P.IsDisabled                                              AS PackageIsDisabled
                , CASE WHEN vPiS.PackagePath IS NOT NULL THEN 1 ELSE 0 END  AS PackageIsInCatalog
                , ISNULL(T.TaskCount, 0)                                    AS TaskCount
                , ISNULL(T.ActiveEnabledTaskCount, 0)                       AS ActiveEnabledTaskCount
  FROM            config.Package                          AS P
  LEFT OUTER JOIN config.vPackagesInSSISDB                AS vPiS
                  ON  vPiS.FolderName   = P.FolderName 
                  AND vPiS.ProjectName  = P.ProjectName
                  AND vPiS.PackageName  = P.PackageName
                  AND vPiS.PackagePath  = P.PackagePath
  LEFT OUTER JOIN TaskPackages                            AS T
                  ON  T.PackageID       = P.PackageID



GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [config].[vPackage] as
  /*
  Schema            : config
  Object            : vPackage
  Author            : Jon Giles
  Created Date      : 01.10.2014
  Description       : A view of config.packages, with additional info

  Change  History   : 
  Author  Date          Description of Change
  JG      01.10.2014    Created
  {YOUR ROW HERE}     

  Usage:
    SELECT * FROM [config].[vPackage]
  */

 WITH  TaskPackages AS 
        ( SELECT    PackageId
                  , COUNT(*)                                                          AS TaskCount
                  , SUM(CASE WHEN IsActive = 1 AND IsDisabled = 0 THEN 1 ELSE 0 END)  AS ActiveEnabledTaskCount
          FROM      config.Task
          GROUP BY  PackageId
        )

  SELECT          P.PackageID
                , P.FolderName 
                , P.ProjectName
                , P.PackageName
                , P.PackagePath
                , P.IsDisabled                                              AS PackageIsDisabled
                , CASE WHEN vPiS.PackagePath IS NOT NULL THEN 1 ELSE 0 END  AS PackageIsInCatalog
                , ISNULL(T.TaskCount, 0)                                    AS TaskCount
                , ISNULL(T.ActiveEnabledTaskCount, 0)                       AS ActiveEnabledTaskCount
  FROM            config.Package                          AS P
  LEFT OUTER JOIN config.vPackagesInSSISDB                AS vPiS
                  ON  vPiS.FolderName   = P.FolderName 
                  AND vPiS.ProjectName  = P.ProjectName
                  AND vPiS.PackageName  = P.PackageName
                  AND vPiS.PackagePath  = P.PackagePath
  LEFT OUTER JOIN TaskPackages                            AS T
                  ON  T.PackageID       = P.PackageID

GO
