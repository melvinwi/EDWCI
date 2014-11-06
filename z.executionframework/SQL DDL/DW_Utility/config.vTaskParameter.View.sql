USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [config].[vTaskParameter] as
  /*
  Schema            : config
  Object            : vTaskParameter
  Author            : Jon Giles
  Created Date      : 22.10.2014
  Description       : A view of Task Parameters (used by [dbo].[ExecuteSSISCatalogPackage])

  Change  History   : 
  Author  Date          Description of Change
  JG      22.10.2014    Created
  {YOUR ROW HERE}     

  Usage:
    SELECT * FROM [config].[vTaskParameter]
  */

SELECT  NULL AS TaskParameterID
      , NULL AS TaskID
      , FolderName
      , ProjectName
      , ParameterName
      , ParameterValue
      , ParameterType
      , ObjectType
      , ObjectTypeId
FROM    [config].[vProjectParametersInSSISDB]

UNION ALL

SELECT  TaskParameterID
      , TaskID
      , NULL AS FolderName
      , NULL AS ProjectName
      , ParameterName
      , ParameterValue
      , 'String' AS ParameterType
      , ObjectType
      , ObjectTypeId
FROM    config.TaskParameter
WHERE   IsDisabled <> 1


GO
