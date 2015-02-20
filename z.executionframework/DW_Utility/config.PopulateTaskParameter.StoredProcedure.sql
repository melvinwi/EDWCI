USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [config].[PopulateTaskParameter] AS

--
INSERT INTO config.TaskParameter  ( TaskID
                                  , ParameterName
                                  , ParameterValue
                                  , ObjectType
                                  --, ObjectTypeId
                                  , IsDisabled
                                  )
SELECT      t.TaskID
          --, v.PackageName
          , v.ParameterName
          , v.ParameterValue
          , v.ObjectType
          --, v.ObjectTypeId
          , 1                                           AS IsDisabled

FROM            [config].[vPackageParametersInSSISDB]   AS v
INNER JOIN      [config].[Package]                      AS p
                ON  p.FolderName  = v.FolderName
                AND p.ProjectName = v.ProjectName
                AND p.PackageName = v.PackageName
                AND p.IsDisabled  <> 1
INNER JOIN      [config].[Task]                         AS t
                ON  t.PackageID   = p.PackageID
                AND t.IsDisabled  <> 1
LEFT OUTER JOIN [config].TaskParameter                  AS tp
                ON  tp.TaskID = t.TaskID
                AND tp.ParameterName = v.ParameterName

WHERE     tp.ParameterName  IS NULL
      AND v.ParameterValue  IS NOT NULL
      AND v.ParameterName   NOT LIKE  'CM.Flat File - CSV.%'      --These parameters relate to several package-level flat-file connection managers, which we don't want to set dynamically.
      AND v.ParameterName   NOT IN  ( N'EnabledSSISLogging'       --This is standard for all packages. We typically don't want to set it at run time. 
                                    , N'FrameworkEnabled'         --This is standard for all packages. We typically don't want to set it at run time. 
                                    , N'HeartBeatInterval'        --This is standard for all packages. We typically don't want to set it at run time. 
                                    , N'TaskExecutionInstanceID'  --This is standard for all packages. We set it dynamically at each execution.
                                    )
ORDER BY  t.TaskID
        , v.ParameterName
--/


GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [config].[PopulateTaskParameter] AS

/*
Usage:
  EXEC [config].[PopulateTaskParameter]
*/

--
INSERT INTO config.TaskParameter  ( TaskID
                                  , ParameterName
                                  , ParameterValue
                                  , ObjectType
                                  --, ObjectTypeId
                                  , IsDisabled
                                  )

OUTPUT  INSERTED.TaskParameterID
      , INSERTED.TaskID
      , INSERTED.ParameterName
      , INSERTED.ParameterValue
      , INSERTED.ObjectType
      , INSERTED.ObjectTypeId
      , INSERTED.IsDisabled

SELECT      t.TaskID
          --, v.PackageName
          , v.ParameterName
          , v.ParameterValue
          , v.ObjectType
          --, v.ObjectTypeId
          , 1                                           AS IsDisabled

FROM            [config].[vPackageParametersInSSISDB]   AS v
INNER JOIN      [config].[Package]                      AS p
                ON  p.FolderName  = v.FolderName
                AND p.ProjectName = v.ProjectName
                AND p.PackageName = v.PackageName
                AND p.IsDisabled  <> 1
INNER JOIN      [config].[Task]                         AS t
                ON  t.PackageID   = p.PackageID
                AND t.IsDisabled  <> 1
LEFT OUTER JOIN [config].TaskParameter                  AS tp
                ON  tp.TaskID = t.TaskID
                AND tp.ParameterName = v.ParameterName

WHERE     tp.ParameterName  IS NULL
      AND v.ParameterValue  IS NOT NULL
      AND v.ParameterName   NOT LIKE  'CM.Flat File - CSV.%'      --These parameters relate to several package-level flat-file connection managers, which we don't want to set dynamically.
      AND v.ParameterName   NOT IN  ( N'EnabledSSISLogging'       --This is standard for all packages. We typically don't want to set it at run time. 
                                    , N'FrameworkEnabled'         --This is standard for all packages. We typically don't want to set it at run time. 
                                    , N'HeartBeatInterval'        --This is standard for all packages. We typically don't want to set it at run time. 
                                    , N'TaskExecutionInstanceID'  --This is standard for all packages. We set it dynamically at each execution.
                                    )
ORDER BY  t.TaskID
        , v.ParameterName
--/

GO
