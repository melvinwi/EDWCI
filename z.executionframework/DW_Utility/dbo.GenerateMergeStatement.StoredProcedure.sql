USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GenerateMergeStatement]
                @SrcDB                    SYSNAME               --Name of the Source database
              , @SrcSchema                SYSNAME               --Name of the Source schema
              , @SrcTable                 SYSNAME               --Name of the Source table
              , @TgtDB                    SYSNAME               --Name of the Target database
              , @TgtSchema                SYSNAME               --Name of the Target schema
              , @TgtTable                 SYSNAME               --Name of the Target table
              , @SCDType                  TINYINT               --Slowly Changing Dimensions Type (1 or 2)
              , @predicate                SYSNAME       = NULL  --(optional) Override to automatic predicate generation.  A comma-separated list of predicate match items
              , @debug                    BIT           = NULL  --(optional) Pass in 1 to print the MERGE statement text without executing it
              , @ApplyNullDefaults        BIT           = NULL  --(optional) Pass in 1 to include defaults for NULL fields.
              , @TaskExecutionInstanceId  INT           = NULL  --(optional) Auditing reference
              , @AsAtDate                 DATETIME2(0)  = NULL  --(optional) Date Override
AS


  /*
  Schema            : dbo
  Object            : GenerateMergeStatement
  Author            : Jon Giles
  Created Date      : 12.08.2014
  Description       : Execute / Produce Merge Statement for Staging Tables

  Change  History   : 
  Author  Date          Description of Change
  JG      12.08.2014    Created - based on: http://informatics.northwestern.edu/blog/uncategorized/2012/05/using-the-merge-statement-in-ssis-via-stored-procedure/
  JG      18.08.2014    Added the parameter: @ApplyNullDefaults and amended @columns_sql, @Equivalence and @Update to consider NULL defaults.
                        Included Row expiry and inserts for matched and changed records
  JG      20.08.2014    Included [Meta_EffectiveEndDate] and [Meta_LatestUpdate_TaskExecutionInstanceId] when inserting new or changed records.
  JG      02.09.2014    Modified to accept parameter @SCDType
                        Incorporated default meta fields from: [config].[vMetaFieldDefault]
  JG      08.09.2014    Removed SET ANSI_NULLS OFF; and SET ANSI_NULLS ON;  --(the ANSI_NULLS setting only applies to literal and variable values, not columnar)
                        Changed Equivalence section to produce "NOT (a = a AND b = b)" instead of "(a <> a OR b <> b)"
  JG      07.10.2014    Changed Equivalence section to use WHERE EXISTS ( SELECT TARGET... EXCEPT SELECT SOURCE... ), to ensure NULLs are evaluated and propogated.
  JG      13.11.2014    Multiple whitespace removals (to reduce overall merge statement string length).
  <YOUR ROW HERE>     
  

  Usage:
    EXEC [dbo].[GenerateMergeStatement]
          @SrcDB                        = 'DW_Work'
        , @SrcSchema                    = 'temp'
        , @SrcTable                     = 'DimCustomer'
        , @TgtDB                        = 'DW_Dimensional'
        , @TgtSchema                    = 'DW'
        , @TgtTable                     = 'DimCustomer'
        , @SCDType                      = 2
        , @predicate                    = 'CustomerCode'
        , @debug                        = 1
        , @ApplyNullDefaults            = 0
        , @TaskExecutionInstanceId      = 0
        , @AsAtDate                     = NULL


    --to do:  raiserror if tables don't exist
            , Amend (or create alternative proc) to load historic data (involves ignoring Meta_IsCurrent and joining on overlapping effective dates)
            , row counts (need to create temp table, insert output, use for 'InsertChanged' then query)

  Contents:
   1) ??Procedure-Specific Variable Declarations
   2) ??Main Body
   3) ??Tidy up
   4) ??Error Handling within Catch Block
  */



BEGIN
  DECLARE @merge_sql                        NVARCHAR(MAX);  --overall dynamic sql statement for the merge
  DECLARE @columns_sql                      NVARCHAR(MAX);  --the dynamic sql to generate the list of columns used in the update, insert, and insert-values portion of the merge dynamic sql
  DECLARE @pred_sql                         NVARCHAR(MAX);	--the dynamic sql to generate the predicate/matching-statement of the merge dynamic sql (populates @pred)
  DECLARE @pk_sql                           NVARCHAR(MAX);  --the dynamic sql to populate the @pk table variable that holds the primary keys of the target table
  DECLARE @Equivalence                      NVARCHAR(MAX);  --contains the comma-seperated columns used in the MATCHED portion of the merge dynamic sql (populated by @columns_sql)
  DECLARE @Equivalence_Target               NVARCHAR(MAX);  --used to populate @Equivalence
  DECLARE @Equivalence_Source               NVARCHAR(MAX);  --used to populate @Equivalence
  DECLARE @Update                           NVARCHAR(MAX);  --contains the comma-seperated columns used in the UPDATE portion of the merge dynamic sql (populated by @columns_sql)
  DECLARE @InsertChanged                    NVARCHAR(MAX);  --contains the comma-seperated columns used in the INSERT (changed rows) portion of the merge dynamic sql (populated by @insert_sql)
  DECLARE @InsertFields                     NVARCHAR(MAX);  --contains the comma-seperated columns used in the INSERT portion of the merge dynamic sql (populated by @insert_sql)
  DECLARE @InsertValues                     NVARCHAR(MAX);  --contains the comma-seperated columns used in the VALUES portion of the merge dynamic sql (populated by @vals_sql)
  DECLARE @pred                             NVARCHAR(MAX);  --contains the predicate/matching-statement of the merge dynamic sql (populated by @pred_sql)
  DECLARE @pred_param                       NVARCHAR(MAX) = @predicate;  --populated by @predicate.  used in the dynamic generation of the predicate statment of the merge
  DECLARE @pred_item                        NVARCHAR(MAX);  --used as a placeholder of each individual item contained within the explicitley passed in predicate
  DECLARE @done_ind                         SMALLINT = 0;   --used in the dynamic generation of the predicate statment of the merge
  DECLARE @dsql_param                       NVARCHAR(500);  --contains the necessary parameters for the dynamic sql execution

  IF @AsAtDate IS NULL
  BEGIN
    SET @AsAtDate = SYSDATETIME()
  END

/***********************************************************************************************
* Generate the dynamic sql (@columns_sql) statement that will                                  *
* populate the @columns temp table with the columns that will be used in the merge dynamic sql *
* The @columns table will contain columns that exist in both the source and target             *
* tables that have the same data types.                                                        *
************************************************************************************************/
		
--Create the temporary table to collect all the columns shared
--between both the Source and Target tables.
 
DECLARE @COLUMNS TABLE  (  table_catalog           VARCHAR(100)  NULL
                        , table_schema             VARCHAR(100)  NULL
                        , TABLE_NAME               VARCHAR(100)  NULL
                        , column_name              VARCHAR(100)  NULL
                        , data_type                VARCHAR(100)  NULL
                        , character_maximum_length INT           NULL
                        , numeric_precision        INT           NULL
                        , src_column_path          VARCHAR(100)  NULL
                        , tgt_column_path          VARCHAR(100)  NULL
                        , NullDefaultString        NVARCHAR(256) NULL
                        , MetaDefault_InsertValue  NVARCHAR(256) NULL
                        , MetaDefault_UpdateValue  NVARCHAR(256) NULL
                        )


/***********************************************************************************************
* Generate the dynamic sql (@columns_sql) statement that will                                  *
* populate the @columns temp table with the columns that will be used in the merge dynamic sql *
* The @columns table will contain columns that exist in both the source and target             *
* tables that have the same data types.                                                        *
************************************************************************************************/    
 
SET @columns_sql =
    'SELECT TARGET.table_catalog
          , TARGET.table_schema
          , TARGET.table_name
          , TARGET.column_name
          , TARGET.data_type
          , TARGET.character_maximum_length
          , TARGET.numeric_precision
          , (SOURCE.table_catalog+''.''+SOURCE.table_schema+''.''+SOURCE.table_name+''.''+SOURCE.column_name) AS src_column_path
          , (TARGET.table_catalog+''.''+TARGET.table_schema+''.''+TARGET.table_name+''.''+TARGET.column_name) AS tgt_column_path
          , NullDefault.NullDefaultString
          , MetaDefault.MetaDefault_InsertValue
          , MetaDefault.MetaDefault_UpdateValue
    FROM ' + @TgtDB + '.information_schema.columns                                  AS TARGET
    LEFT OUTER JOIN ' + @SrcDB + '.information_schema.columns                       AS SOURCE
      ON  TARGET.column_name                  =   SOURCE.column_name
      AND TARGET.data_type                    =   SOURCE.data_type
      AND SOURCE.table_catalog     = ''' + @SrcDB + '''
      AND SOURCE.table_schema      = ''' + @SrcSchema + '''
      AND SOURCE.table_name        = ''' + @SrcTable + '''
      AND LEFT(Source.column_name, 5)         <>  ''Meta_''
      AND (   TARGET.character_maximum_length IS  NULL 
          OR  TARGET.character_maximum_length >=  SOURCE.character_maximum_length
          )
      AND (   TARGET.numeric_precision        IS  NULL 
          OR  TARGET.numeric_precision        >=  SOURCE.numeric_precision
          )
    LEFT OUTER JOIN [DW_Utility].[config].[vMetaFieldDefault]                       AS MetaDefault
      ON  MetaDefault.ColumnName              =   TARGET.column_name
      AND MetaDefault.SCDType                 =   ''' + CAST(@SCDType AS VARCHAR(3)) + '''
    LEFT OUTER JOIN [DW_Utility].[config].[vDataTypeNullDefault]                    AS NullDefault
      ON  NullDefault.[DataType]              =   TARGET.data_type
      AND TARGET.character_maximum_length     >=  NullDefault.[Length_Minimum]
      AND (   TARGET.character_maximum_length <=  NullDefault.[Length_Maximum]
          OR  NullDefault.[Length_Maximum]    IS  NULL
          )
    WHERE TARGET.table_catalog     = ''' + @TgtDB + '''
      AND TARGET.table_schema      = ''' + @TgtSchema + '''
      AND TARGET.table_name        = ''' + @TgtTable + '''
    ORDER BY TARGET.ordinal_position'
 
     --execute the @columns_sql dynamic sql and populate @columns table with the data
     INSERT INTO @COLUMNS
     EXEC sp_executesql @columns_sql


/*************************************************************************************
* Create the temporary table to collect all the primary key columns                  *
* These primary key columns will be filtered out of the update portion of the merge  *
* We do not want to update any portion of clustered index for performance            *
**************************************************************************************/
 
DECLARE @pk TABLE (
  column_name              NVARCHAR(256) NULL
);
 
SET @pk_sql = 'SELECT ccu.column_name '
            + 'FROM ' + @TgtDB + '.INFORMATION_SCHEMA.TABLE_CONSTRAINTS             AS tc_TARGET '
            + 'INNER JOIN ' + @TgtDB +'.INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE  AS ccu '
            +   'ON   tc_TARGET.CONSTRAINT_NAME = ccu.Constraint_name '
            +   'AND  tc_TARGET.table_schema    = ccu.table_schema '
            +   'AND  tc_TARGET.table_name      = ccu.table_name '
            + 'WHERE  tc_TARGET.CONSTRAINT_TYPE  = ''Primary Key'' '
            +   'AND  tc_TARGET.table_catalog    = ''' + @TgtDB + ''' '
            +   'AND  tc_TARGET.table_name       = ''' + @TgtTable + ''' '
            +   'AND  tc_TARGET.table_schema     = ''' + @TgtSchema + ''' ' 
 
INSERT INTO @pk
EXEC sp_executesql @pk_sql

/***************************************************************************************
* This generates the matching statement (aka Predicate) statement of the Merge.        *
* If a predicate is explicitly passed in, use that to generate the matching statement. *
* Else execute the @pred_sql statement to decide what to match on and generate the     *
* matching statement automatically.                                                    *
****************************************************************************************/
 
IF @pred_param IS NOT NULL
  -- If a comma-separated list of predicate match items were passed in via @predicate
  BEGIN
    -- These next two SET statements do basic clean-up on the comma-separated list of predicate items (@pred_param)
    -- if the user passed in a predicate that begins with a comma, strip it out
    SET @pred_param = CASE WHEN SUBSTRING(ltrim(@pred_param),1,1) = ',' THEN SUBSTRING(@pred_param,(charindex(',',@pred_param)+1),LEN(@pred_param)) ELSE @pred_param END
    --if the user passed in a predicate that ends with a comma, strip it out
    SET @pred_param = CASE WHEN SUBSTRING(rtrim(@pred_param),LEN(@pred_param),1) = ',' THEN SUBSTRING(@pred_param,1,LEN(@pred_param)-1) ELSE @pred_param END
    -- End clean-up of(@pred_param) *
    -- loop through the comma-seperated predicate that was passed in via the paramater and construct the predicate statement
    WHILE (@done_ind = 0)
      BEGIN
        SET @pred_item = CASE WHEN charindex(',',@pred_param) > 0 THEN SUBSTRING(@pred_param,1,(charindex(',',@pred_param)-1)) ELSE @pred_param END
        SET @pred_param = SUBSTRING(@pred_param,(charindex(',',@pred_param)+1),LEN(@pred_param))
        SET @pred = CASE WHEN @pred IS NULL THEN (COALESCE(@pred,'') + 'SOURCE.[' + @pred_item + '] = ' + 'TARGET.[' + @pred_item + ']') ELSE (COALESCE(@pred,'') + ' and ' + 'SOURCE.[' + @pred_item + '] = ' + 'TARGET.[' + @pred_item + ']') END
        SET @done_ind = CASE WHEN @pred_param = @pred_item THEN 1 ELSE 0 END
      END
  END
ELSE
  -- If an explicite list of predicate match items was NOT passed in then automatically construct the predicate
  -- match statement based on the primary keys of the Source and Target tables
  BEGIN
    SET @pred_sql = ' SELECT @predsqlout = COALESCE(@predsqlout+'' and '','''')+' +
                    '(''''+''SOURCE.''+column_name+'' = TARGET.''+ccu.column_name)' +
                    ' FROM ' + @TgtDB + '.INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc_TARGET' +
                    ' INNER JOIN ' + @TgtDB + '.INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS ccu' +
                    ' ON tc_TARGET.CONSTRAINT_NAME = ccu.Constraint_name' +
                    ' AND tc_TARGET.table_schema = ccu.table_schema' +
                    ' AND tc_TARGET.table_name = ccu.table_name' +
                    ' WHERE tc_TARGET.CONSTRAINT_TYPE = ''Primary Key''' +
                    ' and tc_TARGET.table_catalog = ''' + @TgtDB + '''' +
                    ' and tc_TARGET.table_name = ''' + @TgtTable + '''' +
                    ' and tc_TARGET.table_schema = ''' + @TgtSchema + ''''
    SET @dsql_param = '	@predsqlout nvarchar(max) OUTPUT'
 
    EXEC sp_executesql
    @pred_sql,
    @dsql_param,
    @predsqlout = @pred OUTPUT;
  END

IF @SCDType = 2 AND EXISTS (SELECT 'x' FROM @COLUMNS WHERE column_name = 'Meta_IsCurrent')
  BEGIN
    SET @pred = @pred + N' AND TARGET.Meta_IsCurrent = 1 '
  END

/*************************************************************************
* The Merge statement contains 4 seperate lists of column names          *
*   1) List of columns used for Matched Statement                        *
*   2) List of columns used for Update Statement                         *
*   3) List of columns used for Insert Statement                         *
*   4) List of columns used for Values portion of the Insert Statement   *
**************************************************************************/

--NVARCHAR version of @TaskExecutionInstanceId
DECLARE @TaskExecutionInstanceId_NVARCHAR NVARCHAR(10) = CAST(@TaskExecutionInstanceId as NVARCHAR(10))


SET @InsertChanged =  CAST( ( SELECT  ','
                                    + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN 'ISNULL(' ELSE '' END 
                                    + CASE WHEN src_column_path IS NOT NULL THEN 'MergeOutput.' + '[' + column_name + ']' ELSE MetaDefault_InsertValue END
                                    + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN ',' + NullDefaultString + ')' ELSE '' END
                              FROM  @COLUMNS
                              WHERE src_column_path         IS NOT NULL
                                OR  MetaDefault_InsertValue IS NOT NULL
                              FOR XML PATH('')
                            )
                            AS NVARCHAR(MAX)
                          )
SET @InsertChanged = SUBSTRING(@InsertChanged, 2, LEN(@InsertChanged)) 

--1) List of columns used for Equivalence Statement
--Populate @Update with the list of columns that will be used to construct the Update Statment portion of the Merge
                  
SET @Equivalence_Target = CAST( ( SELECT  ',TARGET.[' + column_name + ']'
                                  FROM @COLUMNS c
                                  WHERE NOT EXISTS (SELECT 'x' FROM @pk p WHERE p.column_name = c.column_name)  --we do not want the primary key columns updated for performance
                                    AND LEFT(c.column_name, 5) <> N'Meta_'                                      --we do not want to evaluate equivalency based on the meta fields
                                  FOR XML PATH('')
                                )
                                AS NVARCHAR(MAX)
                              )

SET @Equivalence_Source = CAST( ( SELECT  CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN ',ISNULL(' ELSE ',' END 
                                        + 'SOURCE.[' + column_name + ']'
                                        + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN ',' + NullDefaultString + ')' ELSE '' END 
                                  FROM @COLUMNS c
                                  WHERE NOT EXISTS (SELECT 'x' FROM @pk p WHERE p.column_name = c.column_name)  --we do not want the primary key columns updated for performance
                                    AND LEFT(c.column_name, 5) <> N'Meta_'                                      --we do not want to evaluate equivalency based on the meta fields
                                  FOR XML PATH('')
                                )
                                AS NVARCHAR(MAX)
                              )

SET @Equivalence  = N'EXISTS(SELECT ' + SUBSTRING(@Equivalence_Target, 2, LEN(@Equivalence_Target)) 
                  + N' EXCEPT SELECT ' + SUBSTRING(@Equivalence_Source, 2, LEN(@Equivalence_Source)) 
                  + N')'


/* 07.10.2014 - Replaced this section with above code
SET @Equi = CAST( ( SELECT  'AND TARGET.[' + column_name + '] = '
                          + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN 'ISNULL(' ELSE '' END 
                          + 'SOURCE.[' + column_name + ']'
                          + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN ',' + NullDefaultString + ') ' ELSE ' ' END 
                    FROM @COLUMNS c
                    WHERE NOT EXISTS (SELECT 'x' FROM @pk p WHERE p.column_name = c.column_name)  --we do not want the primary key columns updated for performance
                      AND LEFT(c.column_name, 5) <> N'Meta_'                                      --we do not want to evaluate equivalency based on the meta fields
                    FOR XML PATH('')
                  )
                  AS NVARCHAR(MAX)
                )
SET @Equi = N'NOT(' + SUBSTRING(@Equi, 5, LEN(@Equi)) + N')'
*/


--2) List of columns used for Update Statement
--Populate @Update with the list of columns that will be used to construct the Update Statment portion of the Merge

SET @Update = CAST( ( SELECT  ',TARGET.[' + column_name + ']='
                          + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN 'ISNULL(' ELSE '' END 
                          + CASE WHEN src_column_path IS NOT NULL THEN 'SOURCE.' + '[' + column_name + ']' ELSE MetaDefault_UpdateValue END
                          + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN ',' + NullDefaultString + ')' ELSE '' END 
                      FROM @COLUMNS c
                      WHERE NOT EXISTS (SELECT 'x' FROM @pk p WHERE p.column_name = c.column_name)  --we do not want the primary key columns updated (for performance)
                        AND (
                              (   @SCDType = 1
                              AND ISNULL(src_column_path, MetaDefault_UpdateValue) IS NOT NULL
                              )
                            OR
                              (   @SCDType = 2
                              AND src_column_path IS NULL     --For SCD Type 2, we only update the Meta fields.
                              AND MetaDefault_UpdateValue IS NOT NULL
                              )
                            )  
                      FOR XML PATH('')
                    )
                    AS NVARCHAR(MAX)
                  )

SET @Update = SUBSTRING(@Update, 2, LEN(@Update))

--3) List of columns used for Insert Statement
--Populate @InsertFields with the list of columns that will be used to construct the Insert Statment portion of the Merge
 
SET @InsertFields = CAST( ( SELECT  ',[' + column_name + ']'
                            FROM  @COLUMNS
                            WHERE ISNULL(src_column_path, MetaDefault_InsertValue) IS NOT NULL
                            FOR XML PATH('')
                          )
                          AS NVARCHAR(MAX)
                        )
SET @InsertFields = SUBSTRING(@InsertFields, 2, LEN(@InsertFields))

--4) List of columns used for Insert-Values Statement
--Populate @InsertValues with the list of columns that will be used to construct the Insert-Values Statment portion of the Merge	
 
SET @InsertValues = CAST( ( SELECT  ','
                                  + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN 'ISNULL(' ELSE '' END 
                                  + CASE WHEN src_column_path IS NOT NULL THEN 'SOURCE.' + '[' + column_name + ']' ELSE MetaDefault_InsertValue END
                                  + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN ',' + NullDefaultString + ')' ELSE '' END
                            FROM @COLUMNS
                            WHERE ISNULL(src_column_path, MetaDefault_InsertValue) IS NOT NULL
                            FOR XML PATH('')
                          )
                          AS NVARCHAR(MAX)
                        )
SET @InsertValues = SUBSTRING(@InsertValues, 2, LEN(@InsertValues))

/************************************************************************************
*  Generate the final Merge statement using the following...                        *
*    -The parameters (@TgtDB, @TgtSchema, @TgtTable, @SrcDB, @SrcSchema, @SrcTable) *
*    -The predicate matching statement (@pred)                                      *
*    -The update column list (@Update)                                              *
*    -The insert column list (@InsertFields)                                        *
*    -The insert-value column list (@InsertValues)                                  
*    -Filter out Primary Key from the update (updating primary key essentially      *
*     turns the update into an insert and you lose all efficiency benefits)         *
*************************************************************************************/

SET @merge_sql =  ( 'DECLARE @EffectiveStartDate DATETIME2(0)=''' + CAST(@AsAtDate as NVARCHAR(20)) + ''';'
                  + 'DECLARE @EffectiveEndDate DATETIME2(0)=''' + CAST(DATEADD(ss, -1, @AsAtDate) as NVARCHAR(20)) + ''';'
                  + 'DECLARE @TaskExecutionInstanceId INT=' + CAST(@TaskExecutionInstanceId as NVARCHAR(10)) + ';'
                  + CASE WHEN @SCDType = 2 
                      THEN  'INSERT INTO ' + @TgtDB + '.' + @TgtSchema + '.' + @TgtTable + '(' + @InsertFields + ') '
                          + 'SELECT ' + @InsertChanged + ' FROM ('
                      ELSE '' END
                  + 'MERGE INTO ' + @TgtDB + '.' + @TgtSchema + '.' + @TgtTable + ' AS TARGET '
                  + 'USING ' + @SrcDB + '.' + @SrcSchema + '.' + @SrcTable + ' AS SOURCE '
                  + 'ON ' + @pred + ' '
                 -- + 'AND TARGET.Meta_IsCurrent = 1 '
                  + 'WHEN MATCHED AND (' +  @Equivalence + ') '
                  + 'THEN UPDATE SET ' + @Update + ' '
                  + 'WHEN NOT MATCHED BY TARGET THEN INSERT (' + @InsertFields + ') '
                  + 'VALUES ( ' + @InsertValues + ')'
                  + CASE WHEN @SCDType = 2 
                      THEN 'OUTPUT $action AS Action,SOURCE.*) AS MergeOutput WHERE MergeOutput.Action=''UPDATE'';'
                      ELSE ';' END
                  + 'SELECT -1 AS InsertRowCount'
                  + ',ISNULL(@@ROWCOUNT, -1) AS UpdateRowCount'
                  );
 
--Either execute the final Merge statement to merge the staging table into production
--Or select the merge statement text if debug is turned on (@debug=1)
IF @debug = 1
  BEGIN
    -- If debug is true, select the text of merge statement and the column metadata
    SELECT @merge_sql AS merge_sql
    SELECT * FROM @COLUMNS;
  END
ELSE
  BEGIN
    -- If debug is not true, execute the merge statement
    EXEC sp_executesql @merge_sql;
  END
END

GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GenerateMergeStatement]
                @SrcDB                    SYSNAME               --Name of the Source database
              , @SrcSchema                SYSNAME               --Name of the Source schema
              , @SrcTable                 SYSNAME               --Name of the Source table
              , @TgtDB                    SYSNAME               --Name of the Target database
              , @TgtSchema                SYSNAME               --Name of the Target schema
              , @TgtTable                 SYSNAME               --Name of the Target table
              , @SCDType                  TINYINT               --Slowly Changing Dimensions Type (1 or 2)
              , @predicate                SYSNAME       = NULL  --(optional) Override to automatic predicate generation.  A comma-separated list of predicate match items
              , @debug                    BIT           = NULL  --(optional) Pass in 1 to print the MERGE statement text without executing it
              , @ApplyNullDefaults        BIT           = NULL  --(optional) Pass in 1 to include defaults for NULL fields.
              , @TaskExecutionInstanceId  INT           = NULL  --(optional) Auditing reference
              , @AsAtDate                 DATETIME2(0)  = NULL  --(optional) Date Override
              , @BatchIterationCount      BIGINT        = NULL  --(optional) Number of batches
              , @BatchRowCount            BIGINT        = NULL  --(optional) Number of rows per batch
AS


  /*
  Schema            : dbo
  Object            : GenerateMergeStatement
  Author            : Jon Giles
  Created Date      : 12.08.2014
  Description       : Execute / Produce Merge Statement for Staging Tables

  Change  History   : 
  Author  Date          Description of Change
  JG      12.08.2014    Created - based on: http://informatics.northwestern.edu/blog/uncategorized/2012/05/using-the-merge-statement-in-ssis-via-stored-procedure/
  JG      18.08.2014    Added the parameter: @ApplyNullDefaults and amended @columns_sql, @Equivalence and @Update to consider NULL defaults.
                        Included Row expiry and inserts for matched and changed records
  JG      20.08.2014    Included [Meta_EffectiveEndDate] and [Meta_LatestUpdate_TaskExecutionInstanceId] when inserting new or changed records.
  JG      02.09.2014    Modified to accept parameter @SCDType
                        Incorporated default meta fields from: [config].[vMetaFieldDefault]
  JG      08.09.2014    Removed SET ANSI_NULLS OFF; and SET ANSI_NULLS ON;  --(the ANSI_NULLS setting only applies to literal and variable values, not columnar)
                        Changed Equivalence section to produce "NOT (a = a AND b = b)" instead of "(a <> a OR b <> b)"
  JG      07.10.2014    Changed Equivalence section to use WHERE EXISTS ( SELECT TARGET... EXCEPT SELECT SOURCE... ), to ensure NULLs are evaluated and propogated.
  JG      13.11.2014    Multiple whitespace removals (to reduce overall merge statement string length).
  JG      16.01.2015    Added error messages to aid debugging (i.e. tables do not exist, @SCDType not between 1 and 2)
  JG      20.01.2015    Added Batching behaviour and streamlined predicate determination section.
  <YOUR ROW HERE>     
  

  Usage:
    EXEC [dbo].[GenerateMergeStatement]
          @SrcDB                        = 'DW_Work'
        , @SrcSchema                    = 'temp'
        , @SrcTable                     = 'DimCustomer'
        , @TgtDB                        = 'DW_Dimensional'
        , @TgtSchema                    = 'DW'
        , @TgtTable                     = 'DimCustomer'
        , @SCDType                      = 2
        , @predicate                    = 'CustomerCode'
        , @debug                        = 1
        , @ApplyNullDefaults            = 0
        , @TaskExecutionInstanceId      = 0
        , @AsAtDate                     = NULL
        , @BatchIterationCount          = NULL
        , @BatchRowCount                = NULL

    --to do:  raiserror if tables don't exist
            , Amend (or create alternative proc) to load historic data (involves ignoring Meta_IsCurrent and joining on overlapping effective dates)
            , row counts (need to create temp table, insert output, use for 'InsertChanged' then query)

  Contents:
   1) ??Procedure-Specific Variable Declarations
   2) ??Main Body
   3) ??Tidy up
   4) ??Error Handling within Catch Block
  */



BEGIN
  DECLARE @merge_sql                        NVARCHAR(MAX);  --overall dynamic sql statement for the merge
  DECLARE @columns_sql                      NVARCHAR(MAX);  --the dynamic sql to generate the list of columns used in the update, insert, and insert-values portion of the merge dynamic sql
  DECLARE @pred_sql                         NVARCHAR(MAX);	--the dynamic sql to generate the predicate/matching-statement of the merge dynamic sql (populates @pred)
  DECLARE @pk_sql                           NVARCHAR(MAX);  --the dynamic sql to populate the @pk table variable that holds the primary keys of the target table
  
  DECLARE @pred                             NVARCHAR(MAX);  --contains the predicate/matching-statement of the merge dynamic sql (populated by @pred_sql)
  DECLARE @Equivalence                      NVARCHAR(MAX);  --contains the comma-seperated columns used in the MATCHED portion of the merge dynamic sql (populated by @columns_sql)
  DECLARE @Equivalence_Target               NVARCHAR(MAX);  --used to populate @Equivalence
  DECLARE @Equivalence_Source               NVARCHAR(MAX);  --used to populate @Equivalence
  DECLARE @Update                           NVARCHAR(MAX);  --contains the comma-seperated columns used in the UPDATE portion of the merge dynamic sql (populated by @columns_sql)
  
  DECLARE @InsertChanged                    NVARCHAR(MAX);  --contains the comma-seperated columns used in the INSERT (changed rows) portion of the merge dynamic sql (populated by @insert_sql)
  DECLARE @InsertFields                     NVARCHAR(MAX);  --contains the comma-seperated columns used in the INSERT portion of the merge dynamic sql (populated by @insert_sql)
  DECLARE @InsertValues                     NVARCHAR(MAX);  --contains the comma-seperated columns used in the VALUES portion of the merge dynamic sql (populated by @vals_sql)
  
  DECLARE @UseBatching                      BIT = 0;        --controls whether batching behaviour will be employed
  DECLARE @BatchId                          INT = 1;        --used to keep track of batch iterations and to drive @BatchOffset
  DECLARE @BatchIdMaximum                   INT = 1;        --used to limit number of batch iterations
  DECLARE @BatchOffset                      BIGINT = 0;     --used to indicate starting row postion for each batch iteration
  DECLARE @BatchOrderBy                     NVARCHAR(500);  --ensures that batch offseting does not miss/repeat records
  
  DECLARE @InsertRowCount                   BIGINT = 0;
  DECLARE @UpdateRowCount                   BIGINT = 0;

  IF    @BatchIterationCount  IS NOT NULL 
    AND @BatchRowCount        IS NOT NULL 
    BEGIN
      SET @UseBatching = 1;
      SET @BatchIdMaximum = @BatchIterationCount;
    END

  IF @AsAtDate IS NULL
  BEGIN
    SET @AsAtDate = SYSDATETIME()
  END

  IF @SCDType NOT BETWEEN 1 AND 2
    BEGIN
      DECLARE @ErrorMessage_SCD NVARCHAR(4000) = N'DW_Utility.dbo.GenerateMergeStatement Failed - TaskExecutionInstanceID: ' + CAST(@TaskExecutionInstanceID AS VARCHAR(10)) 
                          + N' , @SCDType parameter = ' + ISNULL(CAST(@SCDType AS VARCHAR(10)), N'NULL') + ' not in expected range.'
      RAISERROR (@ErrorMessage_SCD, 16, 1)
    END

/***********************************************************************************************
* Generate the dynamic sql (@columns_sql) statement that will                                  *
* populate the @columns temp table with the columns that will be used in the merge dynamic sql *
* The @columns table will contain columns that exist in both the source and target             *
* tables that have the same data types.                                                        *
************************************************************************************************/
		
--Create the temporary table to collect all the columns shared
--between both the Source and Target tables.
 
DECLARE @COLUMNS TABLE  ( table_catalog            VARCHAR(100)  NULL
                        , table_schema             VARCHAR(100)  NULL
                        , TABLE_NAME               VARCHAR(100)  NULL
                        , column_name              VARCHAR(100)  NULL
                        , data_type                VARCHAR(100)  NULL
                        , character_maximum_length INT           NULL
                        , numeric_precision        INT           NULL
                        , src_column_path          VARCHAR(100)  NULL
                        , tgt_column_path          VARCHAR(100)  NULL
                        , NullDefaultString        NVARCHAR(256) NULL
                        , MetaDefault_InsertValue  NVARCHAR(256) NULL
                        , MetaDefault_UpdateValue  NVARCHAR(256) NULL
                        )


/***********************************************************************************************
* Generate the dynamic sql (@columns_sql) statement that will                                  *
* populate the @columns temp table with the columns that will be used in the merge dynamic sql *
* The @columns table will contain columns that exist in both the source and target             *
* tables that have the same data types.                                                        *
************************************************************************************************/    
 
SET @columns_sql =
    'SELECT TARGET.table_catalog
          , TARGET.table_schema
          , TARGET.table_name
          , TARGET.column_name
          , TARGET.data_type
          , TARGET.character_maximum_length
          , TARGET.numeric_precision
          , (SOURCE.table_catalog+''.''+SOURCE.table_schema+''.''+SOURCE.table_name+''.''+SOURCE.column_name) AS src_column_path
          , (TARGET.table_catalog+''.''+TARGET.table_schema+''.''+TARGET.table_name+''.''+TARGET.column_name) AS tgt_column_path
          , NullDefault.NullDefaultString
          , MetaDefault.MetaDefault_InsertValue
          , MetaDefault.MetaDefault_UpdateValue
    FROM ' + @TgtDB + '.information_schema.columns                                  AS TARGET
    LEFT OUTER JOIN ' + @SrcDB + '.information_schema.columns                       AS SOURCE
      ON  TARGET.column_name                  =   SOURCE.column_name
      AND TARGET.data_type                    =   SOURCE.data_type
      AND SOURCE.table_catalog     = ''' + @SrcDB + '''
      AND SOURCE.table_schema      = ''' + @SrcSchema + '''
      AND SOURCE.table_name        = ''' + @SrcTable + '''
      AND LEFT(Source.column_name, 5)         <>  ''Meta_''
      AND (   TARGET.character_maximum_length IS  NULL 
          OR  TARGET.character_maximum_length >=  SOURCE.character_maximum_length
          )
      AND (   TARGET.numeric_precision        IS  NULL 
          OR  TARGET.numeric_precision        >=  SOURCE.numeric_precision
          )
    LEFT OUTER JOIN [DW_Utility].[config].[vMetaFieldDefault]                       AS MetaDefault
      ON  MetaDefault.ColumnName              =   TARGET.column_name
      AND MetaDefault.SCDType                 =   ''' + CAST(@SCDType AS VARCHAR(3)) + '''
    LEFT OUTER JOIN [DW_Utility].[config].[vDataTypeNullDefault]                    AS NullDefault
      ON  NullDefault.[DataType]              =   TARGET.data_type
      AND TARGET.character_maximum_length     >=  NullDefault.[Length_Minimum]
      AND (   TARGET.character_maximum_length <=  NullDefault.[Length_Maximum]
          OR  NullDefault.[Length_Maximum]    IS  NULL
          )
    WHERE TARGET.table_catalog     = ''' + @TgtDB + '''
      AND TARGET.table_schema      = ''' + @TgtSchema + '''
      AND TARGET.table_name        = ''' + @TgtTable + '''
    ORDER BY TARGET.ordinal_position'
 
    --execute the @columns_sql dynamic sql and populate @columns table with the data
    INSERT INTO @COLUMNS
    EXEC sp_executesql @columns_sql

    IF @@ROWCOUNT = 0
      BEGIN
        DECLARE @ErrorMessage_Merge NVARCHAR(4000) = N'DW_Utility.dbo.GenerateMergeStatement Failed - TaskExecutionInstanceID: ' + CAST(@TaskExecutionInstanceID AS VARCHAR(10)) 
                        + N' , Target and/or Source table(s) do not exist.'
        RAISERROR (@ErrorMessage_Merge, 16, 1)
      END


/*************************************************************************************
* Create the temporary table to collect all the primary key columns                  *
* These primary key columns will be filtered out of the update portion of the merge  *
* We do not want to update any portion of clustered index for performance            *
**************************************************************************************/
 
DECLARE @pk TABLE (
  column_name       NVARCHAR(256) NULL
);
 
SET @pk_sql = 'SELECT ccu.column_name '
            + 'FROM ' + @TgtDB + '.INFORMATION_SCHEMA.TABLE_CONSTRAINTS             AS tc_TARGET '
            + 'INNER JOIN ' + @TgtDB +'.INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE  AS ccu '
            +   'ON   tc_TARGET.CONSTRAINT_NAME = ccu.Constraint_name '
            +   'AND  tc_TARGET.table_schema    = ccu.table_schema '
            +   'AND  tc_TARGET.table_name      = ccu.table_name '
            + 'WHERE  tc_TARGET.CONSTRAINT_TYPE  = ''Primary Key'' '
            +   'AND  tc_TARGET.table_catalog    = ''' + @TgtDB + ''' '
            +   'AND  tc_TARGET.table_name       = ''' + @TgtTable + ''' '
            +   'AND  tc_TARGET.table_schema     = ''' + @TgtSchema + ''' ' 
 
INSERT INTO @pk
EXEC sp_executesql @pk_sql

/***************************************************************************************
* This generates the matching statement (aka Predicate) statement of the Merge.        *
* If a predicate is explicitly passed in, use that to generate the matching statement. *
* Else execute the @pred_sql statement to decide what to match on and generate the     *
* matching statement automatically.                                                    *
****************************************************************************************/

DECLARE @Pred_Table TABLE (
  ColumnName        NVARCHAR(500)             NOT NULL
                  , Id SMALLINT IDENTITY(1,1) NOT NULL
);
 
IF @predicate IS NOT NULL
  -- If a comma-separated list of predicate match items were passed in via @predicate
  BEGIN
    INSERT  INTO @Pred_Table (ColumnName)
    SELECT  Item 
    FROM    dbo.DelimitedSplit (@predicate, ',')
  END
ELSE
  BEGIN
    SET @pred_sql = ' SELECT ccu.column_name' 
                  + ' FROM ' + @TgtDB + '.INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc_TARGET' 
                  + ' INNER JOIN ' + @TgtDB + '.INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS ccu' 
                  + ' ON tc_TARGET.CONSTRAINT_NAME = ccu.Constraint_name' 
                  + ' AND tc_TARGET.table_schema = ccu.table_schema' 
                  + ' AND tc_TARGET.table_name = ccu.table_name' 
                  + ' WHERE tc_TARGET.CONSTRAINT_TYPE = ''Primary Key''' 
                  + ' and tc_TARGET.table_catalog = ''' + @TgtDB + '''' 
                  + ' and tc_TARGET.table_name = ''' + @TgtTable + '''' 
                  + ' and tc_TARGET.table_schema = ''' + @TgtSchema + ''''
    
    INSERT INTO @Pred_Table (ColumnName)
    EXEC sp_executesql  @pred_sql;
  END
  
SET @pred         = CAST( ( SELECT  CASE WHEN Id = 1 THEN '' ELSE ' AND ' END 
                                  + 'SOURCE.[' + ColumnName + '] = TARGET.[' + ColumnName + ']' 
                            FROM @Pred_Table FOR XML PATH('') 
                          ) AS NVARCHAR(MAX)
                        )
SET @BatchOrderBy = CAST( ( SELECT  CASE WHEN Id = 1 THEN '' ELSE ',' END 
                                  + '[' + ColumnName + ']' 
                            FROM @Pred_Table FOR XML PATH('') 
                          ) AS NVARCHAR(MAX)
                        )

IF @SCDType = 2 AND EXISTS (SELECT 'x' FROM @COLUMNS WHERE column_name = 'Meta_IsCurrent')
  BEGIN
    SET @pred = @pred + N' AND TARGET.Meta_IsCurrent = 1 '
  END

IF @pred IS NULL
  BEGIN
    DECLARE @ErrorMessage_Pred NVARCHAR(4000) = N'DW_Utility.dbo.GenerateMergeStatement Failed - TaskExecutionInstanceID: ' + CAST(@TaskExecutionInstanceID AS VARCHAR(10)) 
                    + N' , Joining predicate not specified and could not be derived.'
    RAISERROR (@ErrorMessage_Pred, 16, 1)
  END

/*************************************************************************
* The Merge statement contains 4 seperate lists of column names          *
*   1) List of columns used for Matched Statement                        *
*   2) List of columns used for Update Statement                         *
*   3) List of columns used for Insert Statement                         *
*   4) List of columns used for Values portion of the Insert Statement   *
**************************************************************************/

--NVARCHAR version of @TaskExecutionInstanceId
DECLARE @TaskExecutionInstanceId_NVARCHAR NVARCHAR(10) = CAST(@TaskExecutionInstanceId as NVARCHAR(10))


SET @InsertChanged =  CAST( ( SELECT  ','
                                    + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN 'ISNULL(' ELSE '' END 
                                    + CASE WHEN src_column_path IS NOT NULL THEN 'MergeOutput.' + '[' + column_name + ']' ELSE MetaDefault_InsertValue END
                                    + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN ',' + NullDefaultString + ')' ELSE '' END
                              FROM  @COLUMNS
                              WHERE src_column_path         IS NOT NULL
                                OR  MetaDefault_InsertValue IS NOT NULL
                              FOR XML PATH('')
                            )
                            AS NVARCHAR(MAX)
                          )
SET @InsertChanged = SUBSTRING(@InsertChanged, 2, LEN(@InsertChanged)) 

--1) List of columns used for Equivalence Statement
--Populate @Update with the list of columns that will be used to construct the Update Statment portion of the Merge
                  
SET @Equivalence_Target = CAST( ( SELECT  ',TARGET.[' + column_name + ']'
                                  FROM @COLUMNS c
                                  WHERE NOT EXISTS (SELECT 'x' FROM @pk p WHERE p.column_name = c.column_name)  --we do not want to update the primary key columns
                                    AND LEFT(c.column_name, 5) <> N'Meta_'                                      --we do not want to evaluate equivalency based on the meta fields
                                  FOR XML PATH('')
                                )
                                AS NVARCHAR(MAX)
                              )

SET @Equivalence_Source = CAST( ( SELECT  CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN ',ISNULL(' ELSE ',' END 
                                        + 'SOURCE.[' + column_name + ']'
                                        + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN ',' + NullDefaultString + ')' ELSE '' END 
                                  FROM @COLUMNS c
                                  WHERE NOT EXISTS (SELECT 'x' FROM @pk p WHERE p.column_name = c.column_name)  --we do not want to update the primary key columns
                                    AND LEFT(c.column_name, 5) <> N'Meta_'                                      --we do not want to evaluate equivalency based on the meta fields
                                  FOR XML PATH('')
                                )
                                AS NVARCHAR(MAX)
                              )

SET @Equivalence  = N'EXISTS(SELECT ' + SUBSTRING(@Equivalence_Target, 2, LEN(@Equivalence_Target)) 
                  + N' EXCEPT SELECT ' + SUBSTRING(@Equivalence_Source, 2, LEN(@Equivalence_Source)) 
                  + N')'

--2) List of columns used for Update Statement
--Populate @Update with the list of columns that will be used to construct the Update Statment portion of the Merge

SET @Update = CAST( ( SELECT  ',TARGET.[' + column_name + ']='
                          + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN 'ISNULL(' ELSE '' END 
                          + CASE WHEN src_column_path IS NOT NULL THEN 'SOURCE.' + '[' + column_name + ']' ELSE MetaDefault_UpdateValue END
                          + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN ',' + NullDefaultString + ')' ELSE '' END 
                      FROM @COLUMNS c
                      WHERE NOT EXISTS (SELECT 'x' FROM @pk p WHERE p.column_name = c.column_name)  --we do not want the primary key columns updated (for performance)
                        AND (
                              (   @SCDType = 1
                              AND ISNULL(src_column_path, MetaDefault_UpdateValue) IS NOT NULL
                              )
                            OR
                              (   @SCDType = 2
                              AND src_column_path IS NULL     --For SCD Type 2, we only update the Meta fields.
                              AND MetaDefault_UpdateValue IS NOT NULL
                              )
                            )  
                      FOR XML PATH('')
                    )
                    AS NVARCHAR(MAX)
                  )

SET @Update = SUBSTRING(@Update, 2, LEN(@Update))

--3) List of columns used for Insert Statement
--Populate @InsertFields with the list of columns that will be used to construct the Insert Statment portion of the Merge
 
SET @InsertFields = CAST( ( SELECT  ',[' + column_name + ']'
                            FROM  @COLUMNS
                            WHERE ISNULL(src_column_path, MetaDefault_InsertValue) IS NOT NULL
                            FOR XML PATH('')
                          )
                          AS NVARCHAR(MAX)
                        )
SET @InsertFields = SUBSTRING(@InsertFields, 2, LEN(@InsertFields))

--4) List of columns used for Insert-Values Statement
--Populate @InsertValues with the list of columns that will be used to construct the Insert-Values Statment portion of the Merge	
 
SET @InsertValues = CAST( ( SELECT  ','
                                  + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN 'ISNULL(' ELSE '' END 
                                  + CASE WHEN src_column_path IS NOT NULL THEN 'SOURCE.' + '[' + column_name + ']' ELSE MetaDefault_InsertValue END
                                  + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN ',' + NullDefaultString + ')' ELSE '' END
                            FROM @COLUMNS
                            WHERE ISNULL(src_column_path, MetaDefault_InsertValue) IS NOT NULL
                            FOR XML PATH('')
                          )
                          AS NVARCHAR(MAX)
                        )
SET @InsertValues = SUBSTRING(@InsertValues, 2, LEN(@InsertValues))

/************************************************************************************
*  Generate the final Merge statement using the following...                        *
*    -The parameters (@TgtDB, @TgtSchema, @TgtTable, @SrcDB, @SrcSchema, @SrcTable) *
*    -The predicate matching statement (@pred)                                      *
*    -The update column list (@Update)                                              *
*    -The insert column list (@InsertFields)                                        *
*    -The insert-value column list (@InsertValues)                                  
*    -Filter out Primary Key from the update (updating primary key essentially      *
*     turns the update into an insert and you lose all efficiency benefits)         *
*************************************************************************************/

WHILE @BatchId <= @BatchIdMaximum
  BEGIN

  SET @merge_sql =  ( 'DECLARE @EffectiveStartDate DATETIME2(0)=''' + CAST(@AsAtDate as NVARCHAR(20)) + ''';'
                    + 'DECLARE @EffectiveEndDate DATETIME2(0)=''' + CAST(DATEADD(ss, -1, @AsAtDate) as NVARCHAR(20)) + ''';'
                    + 'DECLARE @TaskExecutionInstanceId INT=' + CAST(@TaskExecutionInstanceId as NVARCHAR(10)) + ';'
                    + CASE WHEN @SCDType = 2 
                        THEN  'INSERT INTO ' + @TgtDB + '.' + @TgtSchema + '.' + @TgtTable + '(' + @InsertFields + ') '
                            + 'SELECT ' + @InsertChanged + ' FROM ('
                        ELSE '' END
                    + 'MERGE INTO ' + @TgtDB + '.' + @TgtSchema + '.' + @TgtTable + ' AS TARGET '
                    + 'USING ' 
                    + CASE WHEN @UseBatching = 1 THEN '(SELECT * FROM ' ELSE '' END
                    + @SrcDB + '.' + @SrcSchema + '.' + @SrcTable 
                    + CASE WHEN @UseBatching = 1 THEN ' ORDER BY ' + @BatchOrderBy + ' OFFSET ' + CAST(@BatchOffset AS NVARCHAR(50)) + ' ROWS ' ELSE '' END
                    + CASE WHEN @UseBatching = 1 AND @BatchId < @BatchIdMaximum THEN 'FETCH NEXT ' + CAST(@BatchRowCount AS NVARCHAR(50)) + ' ROWS ONLY' ELSE '' END
                    + CASE WHEN @UseBatching = 1 THEN ')' ELSE '' END
                    + ' AS SOURCE '
                    + 'ON ' + @pred + ' '
                    + 'WHEN MATCHED AND (' +  @Equivalence + ') '
                    + 'THEN UPDATE SET ' + @Update + ' '
                    + 'WHEN NOT MATCHED BY TARGET THEN INSERT (' + @InsertFields + ') '
                    + 'VALUES ( ' + @InsertValues + ')'
                    + CASE WHEN @SCDType = 2 
                        THEN 'OUTPUT $action AS Action,SOURCE.*) AS MergeOutput WHERE MergeOutput.Action=''UPDATE'';'
                        ELSE ';' END
                    );
 
    --Either execute the final Merge statement to merge the staging table into production
    --Or select the merge statement text if debug is turned on (@debug=1)
    IF @debug = 1
      BEGIN
        -- If debug is true, select the text of merge statement and the column metadata
        SELECT @merge_sql AS merge_sql
        --SELECT @columns_sql AS columns_sql
        SELECT * FROM @COLUMNS
        --SELECT @pred AS Pred, @Pred_Table_Id as Pred_Table_Id, @Pred_Table_Count as Pred_Table_Count
        --SELECT * FROM @Pred_Table
        --SELECT @UseBatching, @BatchId, @BatchIdMaximum, @BatchOrderBy, @BatchOffset, @BatchRowCount
      END
    ELSE
      BEGIN
        -- If debug is not true, execute the merge statement
        EXEC sp_executesql @merge_sql;
        SELECT  @InsertRowCount = ISNULL(@InsertRowCount,0) -1                      
              , @UpdateRowCount = ISNULL(@UpdateRowCount,0) + ISNULL(@@ROWCOUNT, 0)
      END
  
    --Increment @BatchOffset using previous @BatchId
    SET @BatchOffset = @BatchId * @BatchRowCount;
    --/
    --Increment @BatchId
    SET @BatchId = @BatchId + 1;
    --/
  END

IF @debug <> 1
  BEGIN
    SELECT @InsertRowCount AS InsertRowCount, @UpdateRowCount AS UpdateRowCount
  END

END
GO
