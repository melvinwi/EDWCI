USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE View [config].[vDataTypeNullDefault]

AS


  /*
  Schema            : config
  Object            : vDataTypeNullDefault
  Author            : Jon Giles
  Created Date      : 18.08.2014
  Description       : A view of default values for various datatypes, which should be referenced by any update/merge scripts to ensure consistency.

  Change  History   : 
  Author  Date          Description of Change
  JG      18.08.2014    Created
  {YOUR ROW HERE}     
  

  Usage:
    SELECT * FROM [config].[vDataTypeNullDefault]
  */

WITH Numbers
    AS
     ( SELECT 1 AS Number
       UNION ALL
       SELECT Number + 1
       FROM Numbers
       WHERE Number < 7
     )
--SELECT * FROM Numbers

SELECT    CAST(N'nvarchar' AS NVARCHAR(256))                                  AS [DataType]
        , CAST(N'N''{' + LEFT(N'Unknown', Number) + N'}''' AS NVARCHAR(256))  AS [NullDefaultString]
        , CAST(Number + 2 AS INT)                                             AS [Length_Minimum] --Adding two for N'{' and N'}'
        , CAST(CASE WHEN Number < 7 THEN Number + 2 ELSE NULL END  AS INT)    AS [Length_Maximum]
FROM Numbers

  UNION ALL

SELECT    N'varchar'                                          AS [DataType]
        , N'''{' + LEFT(N'Unknown', Number) + N'}'''          AS [NullDefault]
        , Number + 2                                          AS [Length_Minimum] --Adding two for N'{' and N'}'
        , CASE WHEN Number < 7 THEN Number + 2 ELSE NULL END  AS [Length_Maximum]
FROM Numbers

  UNION ALL

SELECT    N'nchar'                                            AS [DataType]
        , N'N''{' + LEFT(N'Unknown', Number) + N'}'''         AS [NullDefault]
        , Number + 2                                          AS [Length_Minimum] --Adding two for N'{' and N'}'
        , CASE WHEN Number < 7 THEN Number + 2 ELSE NULL END  AS [Length_Maximum]
FROM Numbers

  UNION ALL

SELECT    N'char'                                             AS [DataType]
        , N'''{' + LEFT(N'Unknown', Number) + N'}'''          AS [NullDefault]
        , Number + 2                                          AS [Length_Minimum] --Adding two for N'{' and N'}'
        , CASE WHEN Number < 7 THEN Number + 2 ELSE NULL END  AS [Length_Maximum]
FROM Numbers


GO
