USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Lumo Energy | Database Administration
-- Author:		Darren Pilkington
-- Create date: 2012-11-09
-- Description:	Compares object checksums (Taken from source)
-- 2012-11-23	Darren.Pilkington	Now exports object lists
-- 2014-05-12	Iain.Jacob			Modified to create directories where required
-- 2014-09-15	Darren.Pilkington	Added check and default constraint definitions
-- 2014-09-16	Darren.Pilkington	Excludes default and check constraints in list of schema objects	
-- =============================================

CREATE PROCEDURE [dbo].[usp_CompareObjects_Destination] 
	@DATABASE_NAME_DESTINATION SYSNAME,
	@DATABASE_NAME_SOURCE SYSNAME = null,
	@FILE_PATH VARCHAR(64) = 'C:\DBA_ADMIN',
	@LABEL VARCHAR(64) = null
AS
BEGIN
SET NOCOUNT ON;

DECLARE @SQLCMD			VARCHAR(1024);
DECLARE @SOURCE_FILE	VARCHAR(256);

IF @DATABASE_NAME_SOURCE IS NULL
	SET @DATABASE_NAME_SOURCE = @DATABASE_NAME_DESTINATION;

--#########################
-- COMPARE CHECKSUMS
--#########################

CREATE TABLE #TEMP_MONITOR_CODE (
	[object_id] [INT] NOT NULL,
	[object_name] [SYSNAME] NOT NULL,
	[type] [CHAR](2) NOT NULL,
	[type_desc] [NVARCHAR](60) NOT NULL,
	[definition_checksum] [INT] NOT NULL,
	[code_length] [INT] NULL,
	);

CREATE TABLE #TEMP_MONITOR_CODE_LOAD (
	[instance_name] [SYSNAME] NOT NULL,
	[database_name] [SYSNAME] NOT NULL,
	[object_id] [INT] NOT NULL,
	[object_name] [SYSNAME] NOT NULL,
	[type] [CHAR](2) NOT NULL,
	[type_desc] [NVARCHAR](60) NOT NULL,
	[definition_checksum] [INT] NOT NULL,
	[code_length] [INT] NULL,
	[record_time] [DATETIME] NOT NULL
	);
	
SET @SOURCE_FILE = @FILE_PATH+'\'+@DATABASE_NAME_SOURCE+'_CHECKSUM_'+@LABEL+'.dat';
	
SET @SQLCMD = 'BULK INSERT #TEMP_MONITOR_CODE_LOAD FROM '''+@SOURCE_FILE+'''';
EXEC (@SQLCMD);
	
EXECUTE ('
	USE ['+@DATABASE_NAME_DESTINATION+'];
	INSERT INTO #TEMP_MONITOR_CODE 
	SELECT
		sm.object_id,
		OBJECT_NAME(sm.object_id),
		o.type,
		o.type_desc,
		CHECKSUM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(sm.definition,'' '',''''),CHAR(9),''''),CHAR(10),''''),CHAR(13),''''),CHAR(12),'''')),
		LEN(sm.definition) AS code_length
	FROM sys.sql_modules AS sm (nolock)
	JOIN sys.objects AS o ON sm.object_id = o.object_id;
	');

SELECT 'CHECKSUM COMPARISON AT '+CAST(GETDATE() AS VARCHAR(30))+' ON';
SELECT 'SOURCE DATABASE: '+@DATABASE_NAME_SOURCE;
SELECT 'DESTINATION DATABASE: '+@DATABASE_NAME_DESTINATION;
SELECT 'INSTANCE: '+@@SERVERNAME;
SELECT 'SOURCE FILE: '+@SOURCE_FILE;
SELECT '### DESTINATION DB CHECKSUM: '+CAST(SUM(CAST([definition_checksum] as bigint)) as VARCHAR(20)) FROM #TEMP_MONITOR_CODE;
SELECT '### SOURCE DB CHECKSUM:      '+CAST(SUM(CAST([definition_checksum] as bigint)) as VARCHAR(20)) FROM #TEMP_MONITOR_CODE_LOAD;

IF (SELECT SUM(CAST([definition_checksum] AS BIGINT)) from #TEMP_MONITOR_CODE) <> (SELECT SUM(CAST([definition_checksum] AS BIGINT)) from #TEMP_MONITOR_CODE_LOAD)
BEGIN
	SELECT 'CHECKSUMS DON''T MATCH -- DIFFERENCES ARE';
	SELECT 'OBJECTS IN CURRENT DATABASE THAT ARE DIFFERENT TO SOURCE';	
	SELECT 
	[object_name],
	[type_desc],
	[definition_checksum]
	FROM
	#TEMP_MONITOR_CODE
	EXCEPT
	SELECT
	[object_name],
	[type_desc],
	[definition_checksum]
	FROM 
	#TEMP_MONITOR_CODE_LOAD;	
	
	SELECT 'OBJECTS IN SOURCE DATABASE THAT ARE DIFFERENT TO CURRENT DATABASE';	
	SELECT 
	[object_name],
	[type_desc],
	[definition_checksum]
	FROM
	#TEMP_MONITOR_CODE_LOAD
	EXCEPT
	SELECT
	[object_name],
	[type_desc],
	[definition_checksum]
	FROM 
	#TEMP_MONITOR_CODE;	
END

DROP TABLE #TEMP_MONITOR_CODE_LOAD;
DROP TABLE #TEMP_MONITOR_CODE;


--#########################
-- DATABASE OBJECTS
--#########################

CREATE TABLE #TEMP_OBJECTS (
	[name]		SYSNAME NULL,
	[SCH_NAME]	SYSNAME NULL,
	[OBJ_NAME]	SYSNAME NULL,
	type_desc	NVARCHAR(60) NULL,
	create_date DATETIME NULL,
	modify_date DATETIME NULL);

CREATE TABLE #TEMP_OBJECTS_LOAD (
	[instance]	SYSNAME NULL,
	[database]	SYSNAME NULL,
	[name]		SYSNAME NULL,
	[SCH_NAME]	SYSNAME NULL,
	[OBJ_NAME]	SYSNAME NULL,
	type_desc	NVARCHAR(60) NULL,
	create_date DATETIME NULL,
	modify_date DATETIME NULL,
	record_Date DATETIME NULL);
	
SET @SOURCE_FILE = @FILE_PATH+'\'+@DATABASE_NAME_SOURCE+'_objects_'+@LABEL+'.dat';

SET @SQLCMD = 'BULK INSERT #TEMP_OBJECTS_LOAD FROM '''+@SOURCE_FILE+'''';
EXEC (@SQLCMD);

EXECUTE ('
	USE ['+@DATABASE_NAME_DESTINATION+'];
	INSERT INTO #TEMP_OBJECTS 
	SELECT
		name,
		SCHEMA_NAME(schema_id),
		OBJECT_NAME(parent_object_id),
		type_desc,
		create_date,
		modify_date
	FROM sys.objects
	WHERE SCHEMA_NAME(schema_id) <> ''sys''
	AND type_desc NOT IN (''CHECK_CONSTRAINT'',''DEFAULT_CONSTRAINT'');
');

SELECT 'OBJECT COMPARISON AT '+CAST(GETDATE() AS VARCHAR(30))+' ON';
SELECT 'SOURCE DATABASE: '+@DATABASE_NAME_SOURCE;
SELECT 'DESTINATION DATABASE: '+@DATABASE_NAME_DESTINATION;
SELECT 'INSTANCE: '+@@SERVERNAME;
SELECT 'SOURCE FILE: '+@SOURCE_FILE;

SELECT 'OBJECTS IN CURRENT DATABASE THAT AREN''T ON SOURCE';
	
SELECT 
	[name],
	[SCH_NAME],
	NULLIF([OBJ_NAME],'') as obj_name,
	type_desc
FROM
	#TEMP_OBJECTS
EXCEPT
SELECT
	[name],
	[SCH_NAME],
	NULLIF([OBJ_NAME],'') as obj_name,
	type_desc
FROM 
	#TEMP_OBJECTS_LOAD;	

SELECT 'OBJECTS IN SOURCE DATABASE THAT AREN''T IN CURRENT';
	
SELECT 
	[name],
	[SCH_NAME],
	NULLIF([OBJ_NAME],'') as obj_name,
	type_desc
FROM
	#TEMP_OBJECTS_LOAD
EXCEPT
SELECT
	[name],
	[SCH_NAME],
	NULLIF([OBJ_NAME],'') as obj_name,
	type_desc
FROM 
	#TEMP_OBJECTS;	

DROP TABLE #TEMP_OBJECTS;
DROP TABLE #TEMP_OBJECTS_LOAD;

--###################
-- COLUMN CHECKS
--####################

CREATE TABLE #TEMP_COLUMNS (
	[sch_name]		SYSNAME  NULL,
	[obj_name]		SYSNAME  NULL,
	name			SYSNAME  NULL,
	column_id		INT  NULL,
	system_type_id	TINYINT  NULL,
	user_type_id	INT NULL,
	max_length		SMALLINT NULL,
	[precision]		TINYINT NULL, 
	scale			TINYINT NULL,
	collation_name	SYSNAME NULL,
	is_nullable		BIT  NULL,
	is_ansi_padded	BIT  NULL,
	is_rowguidcol	BIT  NULL,
	is_identity		BIT  NULL,
	is_computed		BIT  NULL);

CREATE TABLE #TEMP_COLUMNS_LOAD (
	[instance]		SYSNAME NULL,
	[database]		SYSNAME  NULL,
	[sch_name]		SYSNAME  NULL,
	[obj_name]		SYSNAME  NULL,
	name			SYSNAME  NULL,
	column_id		INT  NULL,
	system_type_id	TINYINT  NULL,
	user_type_id	INT NULL,
	max_length		SMALLINT NULL,
	[precision]		TINYINT NULL, 
	scale			TINYINT NULL,
	collation_name	SYSNAME NULL,
	is_nullable		BIT  NULL,
	is_ansi_padded	BIT  NULL,
	is_rowguidcol	BIT  NULL,
	is_identity		BIT  NULL,
	is_computed		BIT  NULL,
	record_Date		DATETIME NULL);
	
SET @SOURCE_FILE = @FILE_PATH+'\'+@DATABASE_NAME_SOURCE+'_table_columns_'+@LABEL+'.dat';

SET @SQLCMD = 'BULK INSERT #TEMP_COLUMNS_LOAD FROM '''+@SOURCE_FILE+'''';
EXEC (@SQLCMD);

EXECUTE ('
	USE ['+@DATABASE_NAME_DESTINATION+'];
	INSERT INTO #TEMP_COLUMNS 
	SELECT
		SCHEMA_NAME(so.schema_id),
		OBJECT_NAME(sc.object_id),
		sc.name,
		sc.column_id,
		sc.system_type_id,
		sc.user_type_id,
		sc.max_length,
		sc.precision, 
		sc.scale,
		sc.collation_name,
		sc.is_nullable,
		sc.is_ansi_padded,
		sc.is_rowguidcol,
		sc.is_identity,
		sc.is_computed
	FROM sys.columns sc
	LEFT JOIN sys.objects so ON so.object_id = sc.object_id
	WHERE SCHEMA_NAME(so.schema_id) <> ''sys'';
');

SELECT 'TABLE COMPARISON AT '+CAST(GETDATE() AS VARCHAR(30))+' ON';
SELECT 'SOURCE DATABASE: '+@DATABASE_NAME_SOURCE;
SELECT 'DESTINATION DATABASE: '+@DATABASE_NAME_DESTINATION;
SELECT 'INSTANCE: '+@@SERVERNAME;
SELECT 'SOURCE FILE: '+@SOURCE_FILE;

SELECT 'COLUMNS IN CURRENT DATABASE THAT AREN''T ON SOURCE';
	
SELECT 
	[sch_name],
	[obj_name],
	name,
	column_id,
	system_type_id,
	user_type_id,
	max_length,
	[precision],
	scale,
	collation_name,
	is_nullable,
	is_ansi_padded,
	is_rowguidcol,
	is_identity,
	is_computed
FROM
	#TEMP_COLUMNS
EXCEPT
SELECT
	[sch_name],
	[obj_name],
	name,
	column_id,
	system_type_id,
	user_type_id,
	max_length,
	[precision],
	scale,
	collation_name,
	is_nullable,
	is_ansi_padded,
	is_rowguidcol,
	is_identity,
	is_computed
FROM 
	#TEMP_COLUMNS_LOAD;	

SELECT 'COLUMNS IN SOURCE DATABASE THAT AREN''T IN CURRENT';
	
SELECT 
	[sch_name],
	[obj_name],
	name,
	column_id,
	system_type_id,
	user_type_id,
	max_length,
	[precision],
	scale,
	collation_name,
	is_nullable,
	is_ansi_padded,
	is_rowguidcol,
	is_identity,
	is_computed
FROM
	#TEMP_COLUMNS_LOAD
EXCEPT
SELECT
	[sch_name],
	[obj_name],
	name,
	column_id,
	system_type_id,
	user_type_id,
	max_length,
	[precision],
	scale,
	collation_name,
	is_nullable,
	is_ansi_padded,
	is_rowguidcol,
	is_identity,
	is_computed
FROM 
	#TEMP_COLUMNS;	

DROP TABLE #TEMP_COLUMNS;
DROP TABLE #TEMP_COLUMNS_LOAD;

--###################
-- CONSTRAINT CHECKS
--####################

CREATE TABLE #TEMP_CONSTRAINTS (
	[name] [sysname] NOT NULL,
	[parent_table_name] [nvarchar](128) NULL,
	[type] [char](2) NULL,
	[column_name] [sysname] NULL,
	[definition] [nvarchar](max) NULL,
	[is_system_named] [bit] NOT NULL);

CREATE TABLE #TEMP_CONSTRAINTS_LOAD (
	[instance]	SYSNAME NULL,
	[database]	SYSNAME  NULL,
	[name] [sysname] NOT NULL,
	[parent_table_name] [nvarchar](128) NULL,
	[type] [char](2) NULL,
	[column_name] [sysname] NULL,
	[definition] [nvarchar](max) NULL,
	[is_system_named] [bit] NOT NULL,
	[record_date] DATETIME NULL);
	
SET @SOURCE_FILE = @FILE_PATH+'\'+@DATABASE_NAME_SOURCE+'_table_constraints_'+@LABEL+'.dat';

SET @SQLCMD = 'BULK INSERT #TEMP_CONSTRAINTS_LOAD FROM '''+@SOURCE_FILE+'''';
EXEC (@SQLCMD);

EXECUTE ('
	USE ['+@DATABASE_NAME_DESTINATION+'];
	INSERT INTO #TEMP_CONSTRAINTS 
	SELECT
		dc.name,
		OBJECT_NAME(dc.parent_object_id) AS parent_table_name,
		dc.type,
		c.name AS column_name,
		dc.definition,
		dc.is_system_named
	FROM sys.default_constraints dc
	INNER JOIN sys.columns c ON (dc.parent_column_id = c.column_id AND dc.parent_object_id = c.object_id);

	INSERT INTO #TEMP_CONSTRAINTS 
	SELECT
		dc.name,
		OBJECT_NAME(dc.parent_object_id) AS parent_table_name,
		dc.type,
		c.name AS column_name,
		dc.definition,
		dc.is_system_named
	FROM sys.check_constraints dc
	INNER JOIN sys.columns c ON (dc.parent_column_id = c.column_id AND dc.parent_object_id = c.object_id);
');

SELECT 'TABLE CONSTRAINT COMPARISON AT '+CAST(GETDATE() AS VARCHAR(30))+' ON';
SELECT 'SOURCE DATABASE: '+@DATABASE_NAME_SOURCE;
SELECT 'DESTINATION DATABASE: '+@DATABASE_NAME_DESTINATION;
SELECT 'INSTANCE: '+@@SERVERNAME;
SELECT 'SOURCE FILE: '+@SOURCE_FILE;

SELECT 'TABLE CONSTRAINTS IN CURRENT DATABASE THAT AREN''T ON SOURCE';
	
SELECT 
	[name],
	[parent_table_name],
	[type],
	[column_name],
	[definition],
	[is_system_named]
FROM
	#TEMP_CONSTRAINTS
EXCEPT
SELECT
	[name],
	[parent_table_name],
	[type],
	[column_name],
	[definition],
	[is_system_named]
FROM 
	#TEMP_CONSTRAINTS_LOAD;	

SELECT 'TABLE CONSTRAINTS IN SOURCE DATABASE THAT AREN''T IN CURRENT';
	
SELECT 
	[name],
	[parent_table_name],
	[type],
	[column_name],
	[definition],
	[is_system_named]
FROM
	#TEMP_CONSTRAINTS_LOAD
EXCEPT
SELECT
	[name],
	[parent_table_name],
	[type],
	[column_name],
	[definition],
	[is_system_named]
FROM 
	#TEMP_CONSTRAINTS;	

DROP TABLE #TEMP_CONSTRAINTS;
DROP TABLE #TEMP_CONSTRAINTS_LOAD;

END	


GO
