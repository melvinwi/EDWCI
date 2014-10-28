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
-- Description:	Extracts object checksums for comparison
-- 2012-11-23	Darren.Pilkington	Now exports object lists
-- 2014-05-12	Iain.Jacob			Modified to create directories where required
-- 2014-09-15	Darren.Pilkington	Added check and default constraint definitions
-- 2014-09-16	Darren.Pilkington	Excludes default and check constraints in list of schema objects	
-- =============================================

CREATE PROCEDURE [dbo].[usp_CompareObjects_Source] 
	@DATABASE_NAME SYSNAME,
	@FILE_PATH VARCHAR(64) = 'C:\DBA_ADMIN',
	@LABEL VARCHAR(64) = null
AS
BEGIN
SET NOCOUNT ON;

DECLARE @XPCMD VARCHAR(1024);
DECLARE @FILE_NAME VARCHAR(256);
DECLARE @FOLDER_EXISTS as int;
 
DECLARE @file_results table
    (file_exists int,
    file_is_a_directory int,
    parent_directory_exists int
    );

IF ISNULL(LEN(@LABEL),0) = 0
	SET @LABEL = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(20),GETDATE(),120),'-',''),':',''),' ','');

IF @FILE_PATH = 'C:\DBA_ADMIN'
   SET @FILE_PATH = @FILE_PATH + '\' + @LABEL

--#########################
-- Create subDirectories where required
--#########################
    --Check filetree
INSERT into @file_results
    (file_exists, file_is_a_directory, parent_directory_exists)
    EXEC master.dbo.xp_fileexist @FILE_PATH;

    --Return filetree results     
SELECT @FOLDER_EXISTS = file_is_a_directory
    FROM @file_results;
     
    --script to create directory        
IF @FOLDER_EXISTS = 0
     BEGIN
        --print 'Directory does not exists, creating new one'
        EXECUTE master.dbo.xp_create_subdir @FILE_PATH
        --print @FILE_PATH +  ' created on ' + @@servername
     END
    --ELSE
    --print 'Directory already exists'
;

--#########################
-- CHECKSUM OBJECTS
--#########################

SET @FILE_NAME = @FILE_PATH+'\'+@DATABASE_NAME+'_CHECKSUM_'+@LABEL+'.dat';

	CREATE TABLE ##TEMP_MONITOR_CODE (
		[instance_name] [SYSNAME],
		[database_name] [SYSNAME],
		[object_id] [int],
		[object_name] [sysname],
		[type] [char](2),
		[type_desc] [nvarchar](60),
		[definition_checksum] [int],
		[code_length] [int] NULL,
		[record_time] [datetime] NOT NULL
		);
	
	EXECUTE ('
		USE ['+@DATABASE_NAME+'];
		INSERT INTO ##TEMP_MONITOR_CODE 
		SELECT
			@@SERVERNAME,
			DB_NAME(),
			sm.object_id,
			OBJECT_NAME(sm.object_id),
			o.type,
			o.type_desc,
			CHECKSUM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(sm.definition,'' '',''''),CHAR(9),''''),CHAR(10),''''),CHAR(13),''''),CHAR(12),'''')),
			LEN(sm.definition) AS code_length,
			GETDATE()
		FROM sys.sql_modules AS sm
		JOIN sys.objects AS o ON sm.object_id = o.object_id;
		');
	
	SELECT 'CHECKSUM CALCULATED AT '+CAST(GETDATE() AS VARCHAR(30))+' ON';
	SELECT 'DATABASE: '+@DATABASE_NAME;
	SELECT 'INSTANCE: '+@@SERVERNAME;
	SELECT '### DB CHECKSUM: '+CAST(SUM(CAST([definition_checksum] as bigint)) as VARCHAR(20)) FROM ##TEMP_MONITOR_CODE;
	SELECT 'OUTPUT FILE: '+@FILE_NAME;
	
	SET @XPCMD = 'BCP "SELECT * FROM ##TEMP_MONITOR_CODE" QUERYOUT "'+@FILE_NAME+'" -S '+@@SERVERNAME+' -T -c';
	
	EXEC xp_cmdshell @XPCMD;
		
DROP TABLE ##TEMP_MONITOR_CODE;

--#########################
-- DATABASE OBJECTS
--#########################

SET @FILE_NAME = @FILE_PATH+'\'+@DATABASE_NAME+'_objects_'+@LABEL+'.dat';

CREATE TABLE ##TEMP_OBJECTS (
	[instance]	SYSNAME NULL,
	[database]	SYSNAME NULL,
	[name]		SYSNAME NULL,
	[SCH_NAME]	SYSNAME NULL,
	[OBJ_NAME]	SYSNAME NULL,
	type_desc	NVARCHAR(60) NULL,
	create_date DATETIME NULL,
	modify_date DATETIME NULL,
	record_Date DATETIME NULL);
	
EXECUTE ('
	USE ['+@DATABASE_NAME+'];
	INSERT INTO ##TEMP_OBJECTS 
	SELECT
		@@SERVERNAME,
		DB_NAME(),
		name,
		SCHEMA_NAME(schema_id),
		OBJECT_NAME(parent_object_id),
		type_desc,
		create_date,
		modify_date,
		GETDATE()
	FROM sys.objects
	WHERE SCHEMA_NAME(schema_id) <> ''sys''
	AND type_desc NOT IN (''CHECK_CONSTRAINT'',''DEFAULT_CONSTRAINT'');
');
	
SELECT 'OBJECT BASELINE GENERATED AT '+CAST(GETDATE() AS VARCHAR(30))+' ON';
SELECT 'DATABASE: '+@DATABASE_NAME;
SELECT 'INSTANCE: '+@@SERVERNAME;
SELECT 'OUTPUT FILE: '+@FILE_NAME;
	
SET @XPCMD = 'BCP "SELECT * FROM ##TEMP_OBJECTS" QUERYOUT "'+@FILE_NAME+'" -S '+@@SERVERNAME+' -T -c';
	
EXEC xp_cmdshell @XPCMD;
		
DROP TABLE ##TEMP_OBJECTS;

--#########################
-- TABLE COLUMNS
--#########################

SET @FILE_NAME = @FILE_PATH+'\'+@DATABASE_NAME+'_table_columns_'+@LABEL+'.dat';

CREATE TABLE ##TEMP_COLUMNS (
	[instance]	SYSNAME NULL,
	[database]	SYSNAME  NULL,
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
	record_Date DATETIME NULL);
	
EXECUTE ('
	USE ['+@DATABASE_NAME+'];
	INSERT INTO ##TEMP_COLUMNS 
	SELECT
		@@SERVERNAME,
		DB_NAME(),
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
		sc.is_computed,
		GETDATE()
	FROM sys.columns sc
	LEFT JOIN sys.objects so ON so.object_id = sc.object_id
	WHERE SCHEMA_NAME(so.schema_id) <> ''sys'';
');


SELECT 'COLUMN BASELINE GENERATED AT '+CAST(GETDATE() AS VARCHAR(30))+' ON';
SELECT 'DATABASE: '+@DATABASE_NAME;
SELECT 'INSTANCE: '+@@SERVERNAME;
SELECT 'OUTPUT FILE: '+@FILE_NAME;
	
	SET @XPCMD = 'BCP "SELECT * FROM ##TEMP_COLUMNS" QUERYOUT "'+@FILE_NAME+'" -S '+@@SERVERNAME+' -T -c';
	
	EXEC xp_cmdshell @XPCMD;
		
DROP TABLE ##TEMP_COLUMNS;

--#########################
-- TABLE CONSTRAINTS
--#########################

SET @FILE_NAME = @FILE_PATH+'\'+@DATABASE_NAME+'_table_constraints_'+@LABEL+'.dat';

CREATE TABLE ##TEMP_CONSTRAINTS (
	[instance]	SYSNAME NULL,
	[database]	SYSNAME  NULL,
	[name] [sysname] NOT NULL,
	[parent_table_name] [nvarchar](128) NULL,
	[type] [char](2) NULL,
	[column_name] [sysname] NULL,
	[definition] [nvarchar](max) NULL,
	[is_system_named] [bit] NOT NULL,
	[record_date] DATETIME NULL
);

EXECUTE ('
	USE ['+@DATABASE_NAME+'];
	INSERT INTO ##TEMP_CONSTRAINTS 
	SELECT
		@@SERVERNAME,
		DB_NAME(),	
		dc.name,
		OBJECT_NAME(dc.parent_object_id) AS parent_table_name,
		dc.type,
		c.name AS column_name,
		dc.definition,
		dc.is_system_named,
		GETDATE()
	FROM sys.default_constraints dc
	INNER JOIN sys.columns c ON (dc.parent_column_id = c.column_id AND dc.parent_object_id = c.object_id);


	USE ['+@DATABASE_NAME+'];
	INSERT INTO ##TEMP_CONSTRAINTS 
	SELECT
		@@SERVERNAME,
		DB_NAME(),	
		dc.name,
		OBJECT_NAME(dc.parent_object_id) AS parent_table_name,
		dc.type,
		c.name AS column_name,
		dc.definition,
		dc.is_system_named,
		GETDATE()
	FROM sys.check_constraints dc
	INNER JOIN sys.columns c ON (dc.parent_column_id = c.column_id AND dc.parent_object_id = c.object_id);
');


SELECT 'TABLE CONSTRAINT BASELINE GENERATED AT '+CAST(GETDATE() AS VARCHAR(30))+' ON';
SELECT 'DATABASE: '+@DATABASE_NAME;
SELECT 'INSTANCE: '+@@SERVERNAME;
SELECT 'OUTPUT FILE: '+@FILE_NAME;
	
	SET @XPCMD = 'BCP "SELECT * FROM ##TEMP_CONSTRAINTS" QUERYOUT "'+@FILE_NAME+'" -S '+@@SERVERNAME+' -T -c';
	
	EXEC xp_cmdshell @XPCMD;
		
DROP TABLE ##TEMP_CONSTRAINTS;

END	


GO
