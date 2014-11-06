USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [config].[vPackageParametersInSSISDB] AS 
--
SELECT      fo.name           COLLATE Latin1_General_CI_AS  AS FolderName 
          , pr.name           COLLATE Latin1_General_CI_AS  AS ProjectName
          , op.[object_name]  COLLATE Latin1_General_CI_AS  AS PackageName
          , op.parameter_name COLLATE Latin1_General_CI_AS  AS ParameterName
          , op.design_default_value                         AS ParameterValue
          , 'package'                                       AS ObjectType
          , op.object_type                                  AS ObjectTypeId	

FROM        [SSISDB].[catalog].[object_parameters]          AS op
INNER JOIN  [SSISDB].[catalog].[projects]                   AS pr
            ON  pr.project_id = op.project_id
INNER JOIN  [SSISDB].[catalog].[folders]                    AS fo
            ON  fo.folder_id = pr.folder_id

WHERE       op.object_type = 30
--/

GO
