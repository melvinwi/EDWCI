USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [config].[vProjectParametersInSSISDB] as
  /*
  Schema            : config
  Object            : vProjectParametersInSSISDB
  Author            : Jon Giles
  Created Date      : 22.10.2014
  Description       : A view of SSISDB Project Parameters (for use in [dbo].[ExecuteSSISCatalogPackage])

  Change  History   : 
  Author  Date          Description of Change
  JG      22.10.2014    Created
  {YOUR ROW HERE}     

  Usage:
    SELECT * FROM [config].[vProjectParametersInSSISDB]
  */

SELECT      fo.name                 COLLATE Latin1_General_CI_AS  AS FolderName 
          , pr.name                 COLLATE Latin1_General_CI_AS  AS ProjectName
          , op.parameter_name       COLLATE Latin1_General_CI_AS  AS ParameterName
          , op.design_default_value                               AS ParameterValue
          , ev.[type]               COLLATE Latin1_General_CI_AS  AS ParameterType
          , 'Project'                                             AS ObjectType
          , op.object_type                                        AS ObjectTypeId	

FROM        [SSISDB].[catalog].[object_parameters]          AS op

INNER JOIN  [SSISDB].[catalog].[projects]                   AS pr
            ON  pr.project_id = op.project_id

INNER JOIN  [SSISDB].[catalog].[folders]                    AS fo
            ON  fo.folder_id = pr.folder_id

INNER JOIN  [SSISDB].[catalog].[environments]               as e
            ON  e.folder_id =  fo.folder_id

INNER JOIN  [SSISDB].[catalog].[environment_variables]      as ev
            ON  ev.environment_id = e.environment_id
            AND ev.name = op.referenced_variable_name

WHERE       op.object_type = 20
  AND       op.design_default_value IS NOT NULL
  AND       op.value_type = 'R'
  AND       LEFT(op.parameter_name, 3) <> 'CM.'


GO
