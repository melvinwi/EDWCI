USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GenerateUpdateStatement]
                @SrcDB                    SYSNAME               --Name of the Source database
              , @SrcSchema                SYSNAME               --Name of the Source schema
              , @SrcTable                 SYSNAME               --Name of the Source table
              , @TgtDB                    SYSNAME               --Name of the Target database
              , @TgtSchema                SYSNAME               --Name of the Target schema
              , @TgtTable                 SYSNAME               --Name of the Target table
              , @predicate                SYSNAME       = NULL  --(optional) Override to automatic predicate generation.  A comma-separated list of predicate match items
              , @debug                    BIT           = NULL  --(optional) Pass in 1 to kick out just the update statement text without executing it
              , @ApplyNullDefaults        BIT           = NULL  --(optional) Pass in 1 to include defaults for NULL fields.
              , @TaskExecutionInstanceId  INT           = NULL  --(optional) Pass in Auditing reference to populate TARGET.Meta_LatestUpdate_TaskExecutionInstanceId

AS


  /*
  Schema            : dbo
  Object            : GenerateUpdateStatement
  Author            : Jon Giles
  Created Date      : 15.08.2014
  Description       : Execute / Produce Update Statement for Staging Tables

  Change  History   : 
  Author  Date          Description of Change
  JG      15.08.2014    Created - based on: dbo.GenerateMergeSCD2Statement
  JG      18.08.2014    Added ISNULL(..., '') wrapper to @AdditionalUpdatesString to prevent a NULL nullifying the entire statement
                        Added the parameter: @ApplyNullDefaults and amended @columns_sql, @Equi and @Update to consider NULL defaults.
                        Removed parameters: @TaskExecutionInstanceId and @AsAtDate
                        Added output: RowsUpdated
  JG      19.08.2014    Removed parameter: @AdditionalUpdatesString and replaced 
                        Added parameter: @TaskExecutionInstanceId
  JG      20.08.2014    Removed hardcoding that sets Meta fields. (Those columns should exist in the temp tables.)
  JG      03.09.2014    Added NULLIF() wrapper to @pred_param
  JG      09.09.2014    Removed SET ANSI_NULLS OFF; and SET ANSI_NULLS ON;  --(the ANSI_NULLS setting only applies to literal and variable values, not collumnar)
                        Changed Equivalence section to produce "NOT (a = a AND b = b)" instead of "(a <> a OR b <> b)"
  <YOUR ROW HERE>                                                                         
  

  Usage:
    EXEC [dbo].[GenerateUpdateStatement]
          @SrcDB                    = 'DW_Staging'
        , @SrcSchema                = 'orion_temp'
        , @SrcTable                 = 'crm_party'
        , @TgtDB                    = 'DW_Staging'
        , @TgtSchema                = 'orion'
        , @TgtTable                 = 'crm_party'
        , @predicate                = 'seq_party_id'
        , @debug                    = 1
        , @ApplyNullDefaults        = 0
        , @TaskExecutionInstanceId  = 1

    --to do:  raiserror if tables don't exist

  Contents:
   1) ??Procedure-Specific Variable Declarations
   2) ??Main Body
   3) ??Tidy up
   4) ??Error Handling within Catch Block
  */



BEGIN
	DECLARE @update_sql                       NVARCHAR(MAX);  --overall dynamic sql statement for the update
	DECLARE @columns_sql                      NVARCHAR(MAX);  --the dynamic sql to generate the list of columns used in the update, insert, and insert-values portion of the update dynamic sql
	DECLARE @pred_sql                         NVARCHAR(MAX);	--the dynamic sql to generate the predicate/matching-statement of the update dynamic sql (populates @pred)
	DECLARE @pk_sql                           NVARCHAR(MAX);  --the dynamic sql to populate the @pk table variable that holds the primary keys of the target table
  DECLARE @Update                             NVARCHAR(MAX);  --contains the comma-seperated columns used in the UPDATE portion of the update dynamic sql (populated by @columns_sql)
  DECLARE @Equi                             NVARCHAR(MAX);  --contains the comma-seperated columns used in the equivalence comparison portion of the update dynamic sql (populated by @insert_sql)
	DECLARE @pred                             NVARCHAR(MAX);  --contains the predicate/matching-statement of the update dynamic sql (populated by @pred_sql)
	DECLARE @pred_param                       NVARCHAR(MAX) = @predicate;  --populated by @predicate.  used in the dynamic generation of the predicate statment of the update
	DECLARE @pred_item                        NVARCHAR(MAX);  --used as a placeholder of each individual item contained within the explicitley passed in predicate
	DECLARE @done_ind                         SMALLINT = 0;   --used in the dynamic generation of the predicate statment of the update
	DECLARE @dsql_param                       NVARCHAR(500);  --contains the necessary parameters for the dynamic sql execution

/***********************************************************************************************
* Generate the dynamic sql (@columns_sql) statement that will                                  *
* populate the @columns temp table with the columns that will be used in the update dynamic sql*
* The @columns table will contain columns that exist in both the source and target             *
* tables that have the same data types.                                                        *
************************************************************************************************/
		
--Create the temporary table to collect all the columns shared between both the Source and Target tables.
 
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
                        , MetaDefault_UpdateValue  NVARCHAR(256) NULL
                        )

/***********************************************************************************************
* Generate the dynamic sql (@columns_sql) statement that will                                  *
* populate the @columns temp table with the columns that will be used in the update dynamic sql*
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
      , MetaDefault.MetaDefault_UpdateValue
FROM ' + @TgtDB + '.information_schema.columns              AS TARGET
LEFT OUTER JOIN ' + @SrcDB + '.information_schema.columns   AS SOURCE
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
   AND MetaDefault.SCDType                 =   1
LEFT OUTER JOIN [DW_Utility].[config].[vDataTypeNullDefault] AS NullDefault
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
* These primary key columns will be filtered out of the update portion of the update *
* We do not want to update any portion of clustered index for performance            *
**************************************************************************************/
 
DECLARE @pk TABLE (
  column_name              VARCHAR(100) NULL
);
 
SET @pk_sql = 'SELECT ccu.column_name ' 
            + 'FROM ' + @TgtDB + '.INFORMATION_SCHEMA.TABLE_CONSTRAINTS             AS tc_TARGET '
            + 'INNER JOIN ' + @TgtDB +'.INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE  AS ccu '
            +   'ON   tc_TARGET.CONSTRAINT_NAME = ccu.Constraint_name ' 
            +   'AND  tc_TARGET.table_schema    = ccu.table_schema ' 
            +   'AND  tc_TARGET.table_name      = ccu.table_name ' 
            + 'WHERE  tc_TARGET.CONSTRAINT_TYPE = ''Primary Key'' ' 
            +   'AND  tc_TARGET.table_catalog   = ''' + @TgtDB + ''' ' 
            +   'AND  tc_TARGET.table_name      = ''' + @TgtTable + ''' ' 
            +   'AND  tc_TARGET.table_schema    = ''' + @TgtSchema + ''' ' 
 
INSERT INTO @pk
EXEC sp_executesql @pk_sql

/***************************************************************************************
* This generates the matching statement (aka Predicate) statement of the update.       *
* If a predicate is explicitly passed in, use that to generate the matching statement. *
* Else execute the @pred_sql statement to decide what to match on and generate the     *
* matching statement automatically.                                                    *
****************************************************************************************/
 
IF NULLIF(@pred_param, '') IS NOT NULL
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
                    ' INNER JOIN ' + @TgtDB +'.INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS ccu' +
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

/*************************************************************************
* The update statement contains 2 seperate lists of column names         *
*   1) List of columns used for Equivalence Statement                    *
*   2) List of columns used for Update Statement                         *
**************************************************************************/

--NVARCHAR version of @TaskExecutionInstanceId
DECLARE @TaskExecutionInstanceId_NVARCHAR NVARCHAR(10) = CAST(@TaskExecutionInstanceId AS NVARCHAR(10))

--1) List of columns used for Equivalence Statement
--Populate @Equi with the list of columns that will be used to construct the equivalence section
 
SET @Equi = CAST( ( SELECT  'AND TARGET.[' + column_name + '] = '                                 --use '!=' as XML PATH will convert '<>' 
                          + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN 'ISNULL(' ELSE '' END 
                          + 'SOURCE.[' + column_name + ']'
                          + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN ',' + NullDefaultString + ') ' ELSE ' ' END 
                    FROM @COLUMNS c
                    WHERE NOT EXISTS (SELECT 'x' FROM @pk p WHERE p.column_name = c.column_name)  --we do not want the primary key columns updated for performance
                      AND c.column_name NOT LIKE 'meta_%'                                         --we do not want to evaluate equivalency based on the meta fields
                    FOR XML PATH('')
                  ) 
                  AS NVARCHAR(MAX)
                )
SET @Equi = N'NOT(' + SUBSTRING(@Equi, 5, LEN(@Equi)) + N')'

--2) List of columns used for Update Statement
--Populate @Update with the list of columns that will be used to construct the Update Statment portion of the update
 
SET @Update = CAST( ( SELECT  ', TARGET.[' + column_name + '] = '
                            + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN 'ISNULL(' ELSE '' END 
                            + CASE WHEN src_column_path IS NOT NULL THEN 'SOURCE.' + '[' + column_name + ']' ELSE MetaDefault_UpdateValue END
                            + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN ', ' + NullDefaultString + ')' ELSE '' END 
                      FROM @COLUMNS c
                      WHERE NOT EXISTS (SELECT 'x' FROM @pk p WHERE p.column_name = c.column_name)  --we do not want the primary key columns updated for performance
                      FOR XML PATH('')
                    )
                    AS NVARCHAR(MAX)
                  )
SET @Update = SUBSTRING(@Update, 3, LEN(@Update))

/************************************************************************************
*  Generate the final update statement using the following...                       *
*    -The parameters (@TgtDB, @TgtSchema, @TgtTable, @SrcDB, @SrcSchema, @SrcTable) *
*    -The predicate matching statement (@pred)                                      *
*    -The update column list (@Update)                                              *
*    -The insert column list (@insert)                                              *
*    -The insert-value column list (@vals)                                          *
*    -Filter out Primary Key from the update (updating primary key essentially      *
*     turns the update into an insert and you lose all efficiency benefits)         *
*************************************************************************************/

SET @update_sql = ( 'DECLARE @TaskExecutionInstanceId INT = ' + CAST(@TaskExecutionInstanceId as NVARCHAR(10)) + '; '
                  + 'UPDATE TARGET '
                  + 'SET ' + @Update + ' '
                  + 'FROM ' + @TgtDB + '.' + @TgtSchema + '.' + @TgtTable + ' AS TARGET '
                  + 'INNER JOIN ' + @SrcDB + '.' + @SrcSchema + '.' + @SrcTable + ' AS SOURCE '
                  + 'ON ' + @pred + ' '
                  + 'WHERE ' + @Equi + '; '
                  + 'SELECT @@ROWCOUNT as UpdateRowCount;'
                  );
 
--Either execute the final update statement to update the staging table into production
--Or kick out the actual update statement text if debug is turned on (@debug=1)
IF @debug = 1
  BEGIN
    -- If debug is turned on simply select the text of update statement and return that
    SELECT @update_sql;
  END
ELSE
  BEGIN
    -- If debug is not turned on then execute the update statement
    EXEC sp_executesql @update_sql;
  END
END

GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GenerateUpdateStatement]
                @SrcDB                    SYSNAME               --Name of the Source database
              , @SrcSchema                SYSNAME               --Name of the Source schema
              , @SrcTable                 SYSNAME               --Name of the Source table
              , @TgtDB                    SYSNAME               --Name of the Target database
              , @TgtSchema                SYSNAME               --Name of the Target schema
              , @TgtTable                 SYSNAME               --Name of the Target table
              , @predicate                SYSNAME       = NULL  --(optional) Override to automatic predicate generation.  A comma-separated list of predicate match items
              , @debug                    BIT           = NULL  --(optional) Pass in 1 to kick out just the update statement text without executing it
              , @ApplyNullDefaults        BIT           = NULL  --(optional) Pass in 1 to include defaults for NULL fields.
              , @TaskExecutionInstanceId  INT           = NULL  --(optional) Pass in Auditing reference to populate TARGET.Meta_LatestUpdate_TaskExecutionInstanceId

AS


  /*
  Schema            : dbo
  Object            : GenerateUpdateStatement
  Author            : Jon Giles
  Created Date      : 15.08.2014
  Description       : Execute / Produce Update Statement for Staging Tables

  Change  History   : 
  Author  Date          Description of Change
  JG      15.08.2014    Created - based on: dbo.GenerateMergeSCD2Statement
  JG      18.08.2014    Added ISNULL(..., '') wrapper to @AdditionalUpdatesString to prevent a NULL nullifying the entire statement
                        Added the parameter: @ApplyNullDefaults and amended @columns_sql, @Equi and @Update to consider NULL defaults.
                        Removed parameters: @TaskExecutionInstanceId and @AsAtDate
                        Added output: RowsUpdated
  JG      19.08.2014    Removed parameter: @AdditionalUpdatesString and replaced 
                        Added parameter: @TaskExecutionInstanceId
  JG      20.08.2014    Removed hardcoding that sets Meta fields. (Those columns should exist in the temp tables.)
  JG      03.09.2014    Added NULLIF() wrapper to @pred_param
  JG      09.09.2014    Removed SET ANSI_NULLS OFF; and SET ANSI_NULLS ON;  --(the ANSI_NULLS setting only applies to literal and variable values, not collumnar)
                        Changed Equivalence section to produce "NOT (a = a AND b = b)" instead of "(a <> a OR b <> b)"
  <YOUR ROW HERE>                                                                         
  

  Usage:
    EXEC [dbo].[GenerateUpdateStatement]
          @SrcDB                    = 'DW_Staging'
        , @SrcSchema                = 'orion_temp'
        , @SrcTable                 = 'crm_party'
        , @TgtDB                    = 'DW_Staging'
        , @TgtSchema                = 'orion'
        , @TgtTable                 = 'crm_party'
        , @predicate                = 'seq_party_id'
        , @debug                    = 1
        , @ApplyNullDefaults        = 0
        , @TaskExecutionInstanceId  = 1

    --to do:  raiserror if tables don't exist

  Contents:
   1) ??Procedure-Specific Variable Declarations
   2) ??Main Body
   3) ??Tidy up
   4) ??Error Handling within Catch Block
  */



BEGIN
	DECLARE @update_sql                       NVARCHAR(MAX);  --overall dynamic sql statement for the update
	DECLARE @columns_sql                      NVARCHAR(MAX);  --the dynamic sql to generate the list of columns used in the update, insert, and insert-values portion of the update dynamic sql
	DECLARE @pred_sql                         NVARCHAR(MAX);	--the dynamic sql to generate the predicate/matching-statement of the update dynamic sql (populates @pred)
	DECLARE @pk_sql                           NVARCHAR(MAX);  --the dynamic sql to populate the @pk table variable that holds the primary keys of the target table
  DECLARE @Update                             NVARCHAR(MAX);  --contains the comma-seperated columns used in the UPDATE portion of the update dynamic sql (populated by @columns_sql)
  DECLARE @Equi                             NVARCHAR(MAX);  --contains the comma-seperated columns used in the equivalence comparison portion of the update dynamic sql (populated by @insert_sql)
	DECLARE @pred                             NVARCHAR(MAX);  --contains the predicate/matching-statement of the update dynamic sql (populated by @pred_sql)
	DECLARE @pred_param                       NVARCHAR(MAX) = @predicate;  --populated by @predicate.  used in the dynamic generation of the predicate statment of the update
	DECLARE @pred_item                        NVARCHAR(MAX);  --used as a placeholder of each individual item contained within the explicitley passed in predicate
	DECLARE @done_ind                         SMALLINT = 0;   --used in the dynamic generation of the predicate statment of the update
	DECLARE @dsql_param                       NVARCHAR(500);  --contains the necessary parameters for the dynamic sql execution

/***********************************************************************************************
* Generate the dynamic sql (@columns_sql) statement that will                                  *
* populate the @columns temp table with the columns that will be used in the update dynamic sql*
* The @columns table will contain columns that exist in both the source and target             *
* tables that have the same data types.                                                        *
************************************************************************************************/
		
--Create the temporary table to collect all the columns shared between both the Source and Target tables.
 
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
                        , MetaDefault_UpdateValue  NVARCHAR(256) NULL
                        )

/***********************************************************************************************
* Generate the dynamic sql (@columns_sql) statement that will                                  *
* populate the @columns temp table with the columns that will be used in the update dynamic sql*
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
      , MetaDefault.MetaDefault_UpdateValue
FROM ' + @TgtDB + '.information_schema.columns              AS TARGET
LEFT OUTER JOIN ' + @SrcDB + '.information_schema.columns   AS SOURCE
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
   AND MetaDefault.SCDType                 =   1
LEFT OUTER JOIN [DW_Utility].[config].[vDataTypeNullDefault] AS NullDefault
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
* These primary key columns will be filtered out of the update portion of the update *
* We do not want to update any portion of clustered index for performance            *
**************************************************************************************/
 
DECLARE @pk TABLE (
  column_name              VARCHAR(100) NULL
);
 
SET @pk_sql = 'SELECT ccu.column_name ' 
            + 'FROM ' + @TgtDB + '.INFORMATION_SCHEMA.TABLE_CONSTRAINTS             AS tc_TARGET '
            + 'INNER JOIN ' + @TgtDB +'.INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE  AS ccu '
            +   'ON   tc_TARGET.CONSTRAINT_NAME = ccu.Constraint_name ' 
            +   'AND  tc_TARGET.table_schema    = ccu.table_schema ' 
            +   'AND  tc_TARGET.table_name      = ccu.table_name ' 
            + 'WHERE  tc_TARGET.CONSTRAINT_TYPE = ''Primary Key'' ' 
            +   'AND  tc_TARGET.table_catalog   = ''' + @TgtDB + ''' ' 
            +   'AND  tc_TARGET.table_name      = ''' + @TgtTable + ''' ' 
            +   'AND  tc_TARGET.table_schema    = ''' + @TgtSchema + ''' ' 
 
INSERT INTO @pk
EXEC sp_executesql @pk_sql

/***************************************************************************************
* This generates the matching statement (aka Predicate) statement of the update.       *
* If a predicate is explicitly passed in, use that to generate the matching statement. *
* Else execute the @pred_sql statement to decide what to match on and generate the     *
* matching statement automatically.                                                    *
****************************************************************************************/
 
IF NULLIF(@pred_param, '') IS NOT NULL
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
                    ' INNER JOIN ' + @TgtDB +'.INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE AS ccu' +
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

/*************************************************************************
* The update statement contains 2 seperate lists of column names         *
*   1) List of columns used for Equivalence Statement                    *
*   2) List of columns used for Update Statement                         *
**************************************************************************/

--NVARCHAR version of @TaskExecutionInstanceId
DECLARE @TaskExecutionInstanceId_NVARCHAR NVARCHAR(10) = CAST(@TaskExecutionInstanceId AS NVARCHAR(10))

--1) List of columns used for Equivalence Statement
--Populate @Equi with the list of columns that will be used to construct the equivalence section
 
SET @Equi = CAST( ( SELECT  'AND TARGET.[' + column_name + '] = '                                 --use '!=' as XML PATH will convert '<>' 
                          + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN 'ISNULL(' ELSE '' END 
                          + 'SOURCE.[' + column_name + ']'
                          + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN ',' + NullDefaultString + ') ' ELSE ' ' END 
                    FROM @COLUMNS c
                    WHERE NOT EXISTS (SELECT 'x' FROM @pk p WHERE p.column_name = c.column_name)  --we do not want the primary key columns updated for performance
                      AND c.column_name NOT LIKE 'meta_%'                                         --we do not want to evaluate equivalency based on the meta fields
                    FOR XML PATH('')
                  ) 
                  AS NVARCHAR(MAX)
                )
SET @Equi = N'NOT(' + SUBSTRING(@Equi, 5, LEN(@Equi)) + N')'

--2) List of columns used for Update Statement
--Populate @Update with the list of columns that will be used to construct the Update Statment portion of the update
 
SET @Update = CAST( ( SELECT  ', TARGET.[' + column_name + '] = '
                            + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN 'ISNULL(' ELSE '' END 
                            + CASE WHEN src_column_path IS NOT NULL THEN 'SOURCE.' + '[' + column_name + ']' ELSE MetaDefault_UpdateValue END
                            + CASE WHEN @ApplyNullDefaults = 1 AND NullDefaultString IS NOT NULL THEN ', ' + NullDefaultString + ')' ELSE '' END 
                      FROM @COLUMNS c
                      WHERE NOT EXISTS (SELECT 'x' FROM @pk p WHERE p.column_name = c.column_name)  --we do not want the primary key columns updated for performance
                      FOR XML PATH('')
                    )
                    AS NVARCHAR(MAX)
                  )
SET @Update = SUBSTRING(@Update, 3, LEN(@Update))

/************************************************************************************
*  Generate the final update statement using the following...                       *
*    -The parameters (@TgtDB, @TgtSchema, @TgtTable, @SrcDB, @SrcSchema, @SrcTable) *
*    -The predicate matching statement (@pred)                                      *
*    -The update column list (@Update)                                              *
*    -The insert column list (@insert)                                              *
*    -The insert-value column list (@vals)                                          *
*    -Filter out Primary Key from the update (updating primary key essentially      *
*     turns the update into an insert and you lose all efficiency benefits)         *
*************************************************************************************/

SET @update_sql = ( 'DECLARE @TaskExecutionInstanceId INT = ' + CAST(@TaskExecutionInstanceId as NVARCHAR(10)) + '; '
                  + 'UPDATE TARGET '
                  + 'SET ' + @Update + ' '
                  + 'FROM ' + @TgtDB + '.' + @TgtSchema + '.' + @TgtTable + ' AS TARGET '
                  + 'INNER JOIN ' + @SrcDB + '.' + @SrcSchema + '.' + @SrcTable + ' AS SOURCE '
                  + 'ON ' + @pred + ' '
                  + 'WHERE ' + @Equi + '; '
                  + 'SELECT @@ROWCOUNT as UpdateRowCount;'
                  );
 
--Either execute the final update statement to update the staging table into production
--Or kick out the actual update statement text if debug is turned on (@debug=1)
IF @debug = 1
  BEGIN
    -- If debug is turned on simply select the text of update statement and return that
    SELECT @update_sql;
  END
ELSE
  BEGIN
    -- If debug is not turned on then execute the update statement
    EXEC sp_executesql @update_sql;
  END
END

GO
