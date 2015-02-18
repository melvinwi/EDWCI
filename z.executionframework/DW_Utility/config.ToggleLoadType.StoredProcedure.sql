USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [config].[ToggleLoadType] @LoadType NVARCHAR(11) AS


/*
Usage:
  EXEC [config].[ToggleLoadType] N'Incremental'
  EXEC [config].[ToggleLoadType] N'Full'
*/

--
UPDATE      TP 
SET         TP.ParameterValue = @LoadType
          , TP.IsDisabled = 0   --SELECT tp.*
FROM		    [config].[TaskParameter]  AS TP 
INNER JOIN	[config].[Task]           AS T
			      ON T.TaskID = TP.TaskID
INNER JOIN  [config].[Package]        AS P
            ON  P.PackageID = T.PackageID
WHERE       P.PackagePath = N'ExecuteTransform.dtsx'
        AND TP.ParameterName = N'LoadType'
        AND T.IsActive = 1
        AND T.IsDisabled = 0
        AND P.IsDisabled = 0
        AND (   TP.ParameterValue <> @LoadType
            OR  TP.IsDisabled <> 0
            )
--/


GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [config].[ToggleLoadType] @LoadType NVARCHAR(11) AS


/*
Usage:
  EXEC [config].[ToggleLoadType] N'Incremental'
  EXEC [config].[ToggleLoadType] N'Full'
*/

--
UPDATE      TP 
SET         TP.ParameterValue = @LoadType
          , TP.IsDisabled = 0   --SELECT tp.*
FROM		    [config].[TaskParameter]  AS TP 
INNER JOIN	[config].[Task]           AS T
			      ON T.TaskID = TP.TaskID
INNER JOIN  [config].[Package]        AS P
            ON  P.PackageID = T.PackageID
WHERE       P.PackagePath = N'ExecuteTransform.dtsx'
        AND TP.ParameterName = N'LoadType'
        AND T.IsActive = 1
        AND T.IsDisabled = 0
        AND P.IsDisabled = 0
        AND (   TP.ParameterValue <> @LoadType
            OR  TP.IsDisabled <> 0
            )
--/

GO
