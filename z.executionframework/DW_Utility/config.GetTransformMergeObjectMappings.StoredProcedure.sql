USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [config].[GetTransformMergeObjectMappings]
  @ShowAll BIT
AS
/*
Usage:
  EXEC DW_Utility.config.GetTransformMergeObjectMappings @ShowAll = 1
*/

  ;WITH DW_Work_Procedures AS ( 
      SELECT  SPECIFIC_NAME AS Item 
            , SUBSTRING(SPECIFIC_NAME, 0, ISNULL(NULLIF(PATINDEX('%[_]%', SPECIFIC_NAME), 0), LEN(SPECIFIC_NAME)+1)) AS Item_Prefix
      FROM DW_Work.INFORMATION_SCHEMA.ROUTINES 
      WHERE SPECIFIC_SCHEMA = 'transform'
    ) 
    , DW_Work_Tables AS ( 
      SELECT TABLE_NAME AS Item 
      FROM DW_Work.INFORMATION_SCHEMA.TABLES 
    ) 
    , DW_Dimensional_Tables AS ( 
      SELECT TABLE_NAME AS Item 
      FROM DW_Dimensional.INFORMATION_SCHEMA.TABLES 
    ) 
    , Task_Truncate AS (
      SELECT CAST(ParameterValue AS NVARCHAR(100)) AS Item --select *
      FROM DW_Utility.config.TaskParameter 
      WHERE TaskId IN (SELECT TaskID FROM [DW_Utility].[config].[Task] WHERE PackageId = 17 AND TaskName LIKE '%DW_Work%') AND ParameterName = N'TargetTable'
    )
    , Task_Load1 AS (
      SELECT  REPLACE(REPLACE(CAST(ParameterValue AS NVARCHAR(100)), '[transform].[', ''), ']', '') AS Item 
      FROM DW_Utility.config.TaskParameter 
      WHERE TaskId IN (SELECT TaskID FROM [DW_Utility].[config].[Task] WHERE PackageId = 15) AND ParameterName = N'ProcedurePath'
    )
    , Task_Load2 AS (
      SELECT  Item
            , SUBSTRING(Item, 0, ISNULL(NULLIF(PATINDEX('%[_]%', Item), 0), LEN(Item)+1)) AS Item_Prefix
      FROM Task_Load1
    )
    , Task_Merge AS (
      SELECT CAST(ParameterValue AS NVARCHAR(100)) AS Item --select *
      FROM DW_Utility.config.TaskParameter 
      WHERE TaskId IN (SELECT TaskID FROM [DW_Utility].[config].[Task] WHERE PackageId = 16 AND TaskName LIKE '%DW_Dim%') AND ParameterName = N'TargetTable'
    )
    SELECT T2.Item AS DW_Work_Table
         , T4.Item AS Task_Truncate
         , T1.Item AS DW_Work_Procedure
         , T5.Item AS Task_Load
         , T3.Item AS DW_Dimensional_Tables
         , T6.Item AS Task_Merge

    FROM DW_Work_Procedures               AS T1
    FULL OUTER JOIN DW_Work_Tables        AS T2
                    ON T2.Item = T1.Item_Prefix
    FULL OUTER JOIN DW_Dimensional_Tables AS T3
                    ON T3.Item = T1.Item_Prefix
                    OR T3.Item = T2.Item
    FULL OUTER JOIN Task_Truncate         AS T4
                    ON T4.Item = T1.Item_Prefix
                    OR T4.Item = T2.Item
                    OR T4.Item = T3.Item
    FULL OUTER JOIN Task_Load2            AS T5
                    ON T5.Item_Prefix = T1.Item_Prefix
                    OR T5.Item_Prefix = T2.Item
                    OR T5.Item_Prefix = T3.Item
                    OR T5.Item_Prefix = T4.Item
    FULL OUTER JOIN Task_Merge            AS T6
                    ON T6.Item = T1.Item_Prefix
                    OR T6.Item = T2.Item
                    OR T6.Item = T3.Item
                    OR T6.Item = T4.Item
                    OR T6.Item = T5.Item

WHERE   T2.Item IS NULL 
    OR  T4.Item IS NULL
    OR  T1.Item_Prefix IS NULL
    OR  T5.Item_Prefix IS NULL
    OR  T3.Item IS NULL
    OR  T6.Item IS NULL
    OR  @ShowAll = 1

ORDER BY ISNULL(T2.Item, N'0')
       , ISNULL(T4.Item, N'0')
       , ISNULL(T1.Item, N'0')
       , ISNULL(T5.Item, N'0')
       , ISNULL(T3.Item, N'0')
       , ISNULL(T6.Item, N'0')


GO
