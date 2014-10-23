USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[ToggleIndexes]
    @DatabaseName NVARCHAR(255)
  , @SchemaName   NVARCHAR(255)  
  , @TableName    NVARCHAR(255)   
  , @Operation    NVARCHAR(50)    
  , @Debug        BIT = 0

AS

/*
Usage:
  EXEC [dbo].[ToggleIndexes]  @DatabaseName = '[DW_Staging]'
                            , @SchemaName = '[orion]'
                            , @TableName = '[utl_transaction]'
                            , @Operation = 'REBUILD'
                            , @Debug = 1

For testing:
  DECLARE @DatabaseName   NVARCHAR(255) = '[DW_Staging]'
  DECLARE @SchemaName     NVARCHAR(255) = '[orion]'
  DECLARE @TableName      NVARCHAR(255) = '[utl_transaction_type]'
  DECLARE @Operation      NVARCHAR(50)  = 'REBUILD'  --'DISABLE' / 'REBUILD'
  DECLARE @Debug          BIT           = 1
*/

--create temp table
IF OBJECT_ID('tempdb..#Queries') IS NOT NULL 
BEGIN
  DROP TABLE #Queries
END

CREATE TABLE #Queries   ( Query NVARCHAR(1000)
                        , RN    SMALLINT
                        )
--/

--Prepare SQL statements
DECLARE @Rebuild_AdditionalSQL NVARCHAR(MAX)
IF @Operation = 'REBUILD'
  BEGIN
    SET @Rebuild_AdditionalSQL = 'PARTITION = ALL WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)'
  END

DECLARE @SQL NVARCHAR(MAX) =
'DECLARE @Operation  NVARCHAR(50) = ''' + @Operation + '''
INSERT INTO #Queries  ( Query
                      , RN
                      )
SELECT    ''ALTER INDEX '' + NAME + '' ON ' + @DatabaseName + '.' + @SchemaName + '.' + @TableName + ' ' + @Operation + ISNULL(' ' + @Rebuild_AdditionalSQL, '') + '''
         , ROW_NUMBER() OVER (PARTITION BY NULL ORDER BY NAME)
FROM      ' + @DatabaseName + '.SYS.INDEXES 
WHERE     OBJECT_ID = OBJECT_ID(''' + @DatabaseName + '.' + @SchemaName + '.' + @TableName + ''') 
  AND TYPE_DESC = ''NONCLUSTERED''
  AND (   (IS_DISABLED = 0 AND @Operation = ''DISABLE'')
      OR  (IS_DISABLED = 1 AND @Operation = ''REBUILD'')
      )
ORDER BY  NAME'

EXECUTE sp_executesql @SQL
--/

--Loop through indexes
DECLARE @RN SMALLINT = @@ROWCOUNT
DECLARE @Query NVARCHAR(1000)

WHILE @RN > 0
  BEGIN
    
    SELECT  @Query = Query 
    FROM    #Queries 
    WHERE   RN = @RN
    
    IF @Debug = 1
      BEGIN
        PRINT @Query
      END
    ELSE
      BEGIN
        EXECUTE sp_executesql @Query
      END

    SET @RN = @RN - 1
  END
--/
GO
