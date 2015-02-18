USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [config].[DisableInvalidTaskParameters] AS

/*
Usage:
  EXEC [config].[DisableInvalidTaskParameters] 
*/


--
UPDATE    tp
SET       tp.IsDisabled = 1 --SELECT *

FROM            [config].TaskParameter                  AS tp
INNER JOIN      [config].[Task]                         AS t
                ON  t.TaskID = tp.TaskID
INNER JOIN      [config].[Package]                      AS p
                ON  p.PackageID   = t.PackageID
LEFT OUTER JOIN [config].[vPackageParametersInSSISDB]   AS v
                ON  tp.ParameterName = v.ParameterName
                AND p.FolderName  = v.FolderName
                AND p.ProjectName = v.ProjectName
                AND p.PackageName = v.PackageName


WHERE     tp.IsDisabled   <> 1
  AND     v.ParameterName IS NULL
--/

GO
