USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE View [config].[vMetaFieldDefault]

AS


  /*
  Schema            : config
  Object            : vMetaFieldDefault
  Author            : Jon Giles
  Created Date      : 02.09.2014
  Description       : A view of default values for various meta fields, which should be referenced by any update/merge scripts to ensure consistency.

  Change  History   : 
  Author  Date          Description of Change
  JG      02.09.2014    Created
  {YOUR ROW HERE}     
  

  Usage:
    SELECT * FROM [config].[vMetaFieldDefault]
  */

  
--Type 1
SELECT    N'Meta_Insert_TaskExecutionInstanceId' AS ColumnName
        , 1                                      AS SCDType
        , N'@TaskExecutionInstanceId'            AS MetaDefault_InsertValue
        , NULL                                   AS MetaDefault_UpdateValue

  UNION ALL

SELECT    N'Meta_LatestUpdate_TaskExecutionInstanceId'
        , 1                                           
        , N'@TaskExecutionInstanceId'                 
        , N'@TaskExecutionInstanceId'
--/
  
  UNION ALL

--Type 2
SELECT    N'Meta_IsCurrent'              
        , 2                              
        , N'1'                           
        , N'0'

  UNION ALL

SELECT    N'Meta_EffectiveStartDate'
        , 2                         
        , N'@EffectiveStartDate' 
        , NULL

  UNION ALL

SELECT    N'Meta_EffectiveEndDate'  
        , 2                         
        , N'''99991231'''
        , N'@EffectiveEndDate'        

  UNION ALL

SELECT    N'Meta_Insert_TaskExecutionInstanceId'
        , 2                                     
        , N'@TaskExecutionInstanceId'   
        , NULL        

  UNION ALL

SELECT    N'Meta_LatestUpdate_TaskExecutionInstanceId'
        , 2                                           
        , N'@TaskExecutionInstanceId'                 
        , N'@TaskExecutionInstanceId'
--/


GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE View [config].[vMetaFieldDefault]

AS


  /*
  Schema            : config
  Object            : vMetaFieldDefault
  Author            : Jon Giles
  Created Date      : 02.09.2014
  Description       : A view of default values for various meta fields, which should be referenced by any update/merge scripts to ensure consistency.

  Change  History   : 
  Author  Date          Description of Change
  JG      02.09.2014    Created
  {YOUR ROW HERE}     
  

  Usage:
    SELECT * FROM [config].[vMetaFieldDefault]
  */

  
--Type 1
SELECT    N'Meta_Insert_TaskExecutionInstanceId' AS ColumnName
        , 1                                      AS SCDType
        , N'@TaskExecutionInstanceId'            AS MetaDefault_InsertValue
        , NULL                                   AS MetaDefault_UpdateValue

  UNION ALL

SELECT    N'Meta_LatestUpdate_TaskExecutionInstanceId'
        , 1                                           
        , N'@TaskExecutionInstanceId'                 
        , N'@TaskExecutionInstanceId'
--/
  
  UNION ALL

--Type 2
SELECT    N'Meta_IsCurrent'              
        , 2                              
        , N'1'                           
        , N'0'

  UNION ALL

SELECT    N'Meta_EffectiveStartDate'
        , 2                         
        , N'@EffectiveStartDate' 
        , NULL

  UNION ALL

SELECT    N'Meta_EffectiveEndDate'  
        , 2                         
        , N'''99991231'''
        , N'@EffectiveEndDate'        

  UNION ALL

SELECT    N'Meta_Insert_TaskExecutionInstanceId'
        , 2                                     
        , N'@TaskExecutionInstanceId'   
        , NULL        

  UNION ALL

SELECT    N'Meta_LatestUpdate_TaskExecutionInstanceId'
        , 2                                           
        , N'@TaskExecutionInstanceId'                 
        , N'@TaskExecutionInstanceId'
--/

GO
