USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE View [config].[vMetaField]

AS


  /*
  Schema            : config
  Object            : vMetaField
  Author            : Jon Giles
  Created Date      : 18.08.2014
  Description       : A view of default values for the metafields, which should be referenced by any update/merge scripts to ensure consistency.

  Change  History   : 
  Author  Date          Description of Change
  JG      18.08.2014    Created
  {YOUR ROW HERE}     
  

  Usage:
    SELECT * FROM [config].[vMetaField]
  */
  
SELECT    CAST(N'Meta_EffectiveEndDate' AS NVARCHAR(256))   AS FieldName 
        , CAST(N'DATETIME2(0)'          AS NVARCHAR(256))   AS DataType
        , CAST(N'DW_Dimensional'        AS NVARCHAR(256))   AS DatabaseName
        , CAST(N'dw'                    AS NVARCHAR(256))   AS SchemaName
        , CAST(1                        AS BIT)             AS Nullable
        , CAST(NULL                     AS NVARCHAR(256))   AS DefaultValue

                  --FieldName                                 --DataType          --DatabaseName      --SchemaName    --Nullable  --DefaultValue
UNION ALL SELECT  N'Meta_EffectiveStartDate'	                , N'DATETIME2(0)'   , N'DW_Dimensional' , N'dw'         , 0         , NULL
UNION ALL SELECT  N'Meta_Insert_TaskExecutionInstanceId'      , N'INT'            , N'DW_Dimensional' , N'dw'         , 0         , NULL
UNION ALL SELECT  N'Meta_LatestUpdate_TaskExecutionInstanceId', N'INT'            , N'DW_Dimensional' , N'dw'         , 1         , NULL
UNION ALL SELECT  N'Meta_IsCurrent'	                          , N'BIT'            , N'DW_Dimensional' , N'dw'         , 0         , NULL
UNION ALL SELECT  N'Meta_ChangeFlag'	                        , N'BIT'            , N'DW_Staging'     , N'orion'      , 1         , 1
UNION ALL SELECT  N'Meta_Insert_TaskExecutionInstanceId'      , N'INT'            , N'DW_Staging'     , N'orion'      , 1         , NULL
UNION ALL SELECT  N'Meta_LatestUpdate_TaskExecutionInstanceId', N'INT'            , N'DW_Staging'     , N'orion'      , 1         , NULL
UNION ALL SELECT  N'Meta_ChangeFlag'	                        , N'BIT'            , N'DW_Staging'     , N'orion_temp' , 1         , 1
UNION ALL SELECT  N'Meta_LatestUpdate_TaskExecutionInstanceId', N'INT'            , N'DW_Staging'     , N'orion_temp' , 1         , NULL

GO
