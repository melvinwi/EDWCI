USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_CheckVLDB]
	@Database_Name sysname
AS

SET NOCOUNT ON
SET QUOTED_IDENTIFIER ON

/***************************************************************************
							

-- Lumo Energy | Database Administration
-- DBCC CHECKDB FOR LARGE DATABASES
--
-- 2012-10-22 Darren.Pilkington Initial release
--
-- This procedure will perform a DBCC CHECKDB for each object (with storage) in a large database.
-- It first performs DBCC CHECKALLOC and CHECKCATALOG on the database.
-- It then processes all objects in order of last checked.
-- The process will run for time specified by 'VLDB_CHECK_MAX_TIME' minutes so that other databases can be checked.
-- A report will be generated of tables not analyzed within 'VLDB_CHECK_THRESHOLD' days.
--
									
***************************************************************************/

DECLARE	@SQL_cmd NVARCHAR(2000);
DECLARE @crlf NCHAR(2);
DECLARE @Object_Name SYSNAME;
DECLARE @Current_Log_Record INT;
DECLARE @Return_Code INT;
DECLARE @Max_Run_Time INT;
DECLARE @Last_Checked DATETIME;
DECLARE @Last_Run_Time INT;
DECLARE @Finish_Time DATETIME;
DECLARE @Pool TABLE (
	[Name] SYSNAME,
	[LastChecked] DATETIME,
	[runtime] INT
	);
	
SET @crlf = NCHAR(13) + NCHAR(10);	
SET @Max_Run_Time = CAST((SELECT parameter_value FROM dba_admin.dbo.SystemParameters WHERE parameter_name = 'VLDB_CHECK_MAX_TIME')AS INT);

-- PERFORM GENERAL DBCC CHECKS

DBCC CHECKALLOC (@Database_Name) WITH ALL_ERRORMSGS, NO_INFOMSGS;
DBCC CHECKCATALOG (@Database_Name) WITH NO_INFOMSGS;

-- Find User Tables, System Base Table, Indexed Views, Internal Tables for the nominated database.
SET  @SQL_cmd = 
	N'USE [' + @DATABASE_NAME + N'];' + @crlf +
	N'SELECT' + @crlf +
	N'SCHEMA_NAME(o.schema_id) + N''.'' + o.name, dcvi.last_checked, dcvi.avg_seconds' + @crlf +
	N'FROM [' + @DATABASE_NAME + N'].sys.objects o WITH (NOLOCK)' + @crlf +
	N'LEFT JOIN [dba_admin].[dbo].[DatabaseCheckVLDBInfo] dcvi ON dcvi.[object_name] = SCHEMA_NAME(o.schema_id) + N''.'' + o.name COLLATE DATABASE_DEFAULT' + @crlf +
	N'AND dcvi.[database_name] = '''+ @DATABASE_NAME +''''  + @crlf + 
	N'WHERE o.[type] IN (N''U'', N''S'', N''IT'')' + @crlf +
	N'AND left(o.[name],1) <> ''#''' + @crlf + 
	N'UNION'  + @crlf + 
	N'SELECT' + @crlf +
	N'SCHEMA_NAME(it.schema_id) + N''.'' + OBJECT_NAME(it.object_id), dcvi.last_checked, dcvi.avg_seconds' + @crlf +
	N'FROM [' + @DATABASE_NAME + N'].sys.internal_tables it WITH (NOLOCK)' + @crlf +
	N'LEFT JOIN [dba_admin].[dbo].[DatabaseCheckVLDBInfo] dcvi ON dcvi.[object_name] = SCHEMA_NAME(it.schema_id) + N''.'' + it.name COLLATE DATABASE_DEFAULT' + @crlf +
	N'AND dcvi.[database_name] = '''+ @DATABASE_NAME +''''  + @crlf + 
	N'WHERE it.internal_type IN (202,204)' + @crlf + 
	N'UNION' + @crlf +
	N'SELECT' + @crlf +
	N'SCHEMA_NAME(o.schema_id) + N''.'' + o.name, dcvi.last_checked, dcvi.avg_seconds' + @crlf +
	N'FROM [' + @DATABASE_NAME + N'].sys.objects o WITH (NOLOCK)' + @crlf +
	N'LEFT JOIN [dba_admin].[dbo].[DatabaseCheckVLDBInfo] dcvi ON dcvi.[object_name] = SCHEMA_NAME(o.schema_id) + N''.'' + o.name COLLATE DATABASE_DEFAULT' + @crlf +
	N'AND dcvi.[database_name] = '''+ @DATABASE_NAME +''''  + @crlf + 
	N'INNER JOIN sys.indexes i ON o.object_id = i.object_id' + @crlf + 
	N'WHERE o.[type] = ''V''' + @crlf +
	N'AND left(o.[name],1) <> ''#'';'

INSERT INTO @Pool EXEC (@SQL_cmd);

-- DO THE TABLE CHECKS (A SUBSET OF THE TABLES)

SET @Finish_Time = DATEADD(MI,@Max_Run_Time,GETDATE());

DECLARE table_check_list_cursor CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR
	SELECT [Name], ISNULL([LastChecked],GETDATE()), ISNULL([RunTime],0)
	FROM @Pool
	ORDER BY [LastChecked] ASC, [RunTime] ASC;  -- CHECK NEW OBJECTS AND OLDEST RECORDS WITHIN RUNTIME 

OPEN table_check_list_cursor

FETCH NEXT FROM table_check_list_cursor INTO @Object_Name, @Last_Checked, @Last_Run_Time;

WHILE @@FETCH_STATUS = 0 
BEGIN

	IF GETDATE() >= @Finish_Time -- Checks if enough time overall remains.
	BEGIN
		PRINT 'RUN OUT OF TIME ENDING NOW';
		RETURN
	END

	IF DATEADD(SS,@Last_Run_Time,GETDATE()) < @Finish_Time -- Checks if enough time left for object check (based on average time)
	BEGIN
		INSERT INTO dba_admin.dbo.DatabaseCheckVLDBLog (database_name, object_name, start_time)
			VALUES (@Database_Name, @Object_Name, GETDATE());
	
		SET @Current_Log_Record = CAST(@@IDENTITY AS INT);
		SET @SQL_cmd = 'DBCC CHECKTABLE ([' + @Database_Name + '.' + @Object_Name + ']) WITH ALL_ERRORMSGS, NO_INFOMSGS;'
		EXEC (@SQL_cmd)
		SET @Return_Code = @@ERROR;
		
		UPDATE dba_admin.dbo.DatabaseCheckVLDBLog
		SET end_time = GETDATE(), result = @Return_Code
		WHERE log_record_no = @Current_Log_Record
		AND end_time IS NULL;
	END

	FETCH NEXT FROM table_check_list_cursor INTO @Object_Name, @Last_Checked, @Last_Run_Time
END

CLOSE table_check_list_cursor;
DEALLOCATE table_check_list_cursor;



GO
