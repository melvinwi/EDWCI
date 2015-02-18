USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[DelimitedSplit]
(@String NVARCHAR(4000), @Delimiter NCHAR(1))

RETURNS TABLE WITH SCHEMABINDING AS

  /*
  Schema            : dbo
  Object            : DelimitedSplit
  Author            : Jon Giles
  Created Date      : 27.08.2014
  Description       : Returns the values from a delimited string, in a table

  Change  History   : 
  Author  Date          Description of Change
  JG      27.08.2014    Created - based on: http://www.sqlservercentral.com/articles/Tally+Table/72993/
  <YOUR ROW HERE>     
  

  Usage:
    SELECT  Item 
    FROM    dbo.DelimitedSplit ('a,b,c', ',')

  */

 RETURN
  WITH 
    E1(N)         AS  ( SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
                        SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1
                      )
  , E2(N)         AS  ( SELECT 1 FROM E1 a, E1 b
                      )
  , E4(N)         AS  ( SELECT 1 FROM E2 a, E2 b
                      )
  , cteTally(N)   AS  ( SELECT TOP (ISNULL(DATALENGTH(@String)/2,0)) 
                              ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) 
                        FROM E4
                      )
  , cteStart(N1)  AS  ( SELECT 1 UNION ALL 
                        SELECT t.N+1 
                        FROM cteTally t 
                        WHERE SUBSTRING(@String,t.N,1) = @Delimiter
                      )
  , cteLen(N1,L1) AS  ( SELECT  s.N1
                              , ISNULL(NULLIF(CHARINDEX(@Delimiter,@String,s.N1),0)-s.N1,4000)
                        FROM cteStart s
                      )
  SELECT    ROW_NUMBER() OVER(ORDER BY l.N1) AS ItemNumber
          , SUBSTRING(@String, l.N1, l.L1)  AS Item      
  FROM      cteLen l;

GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[DelimitedSplit]
(@String NVARCHAR(4000), @Delimiter NCHAR(1))

RETURNS TABLE WITH SCHEMABINDING AS

  /*
  Schema            : dbo
  Object            : DelimitedSplit
  Author            : Jon Giles
  Created Date      : 27.08.2014
  Description       : Returns the values from a delimited string, in a table

  Change  History   : 
  Author  Date          Description of Change
  JG      27.08.2014    Created - based on: http://www.sqlservercentral.com/articles/Tally+Table/72993/
  <YOUR ROW HERE>     
  

  Usage:
    SELECT  Item 
    FROM    dbo.DelimitedSplit ('a,b,c', ',')

  */

 RETURN
  WITH 
    E1(N)         AS  ( SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
                        SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1
                      )
  , E2(N)         AS  ( SELECT 1 FROM E1 a, E1 b
                      )
  , E4(N)         AS  ( SELECT 1 FROM E2 a, E2 b
                      )
  , cteTally(N)   AS  ( SELECT TOP (ISNULL(DATALENGTH(@String)/2,0)) 
                              ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) 
                        FROM E4
                      )
  , cteStart(N1)  AS  ( SELECT 1 UNION ALL 
                        SELECT t.N+1 
                        FROM cteTally t 
                        WHERE SUBSTRING(@String,t.N,1) = @Delimiter
                      )
  , cteLen(N1,L1) AS  ( SELECT  s.N1
                              , ISNULL(NULLIF(CHARINDEX(@Delimiter,@String,s.N1),0)-s.N1,4000)
                        FROM cteStart s
                      )
  SELECT    ROW_NUMBER() OVER(ORDER BY l.N1) AS ItemNumber
          , SUBSTRING(@String, l.N1, l.L1)  AS Item      
  FROM      cteLen l;

GO
