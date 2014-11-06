USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_CheckDB] 
AS

-- Lumo Energy | Database Administration
-- DBCC CHECKDB FOR ALL DATABASES
--
-- 2009-10-29 Darren.Pilkington Initial Release
-- 2009-10-30 Darren.Pilkington Parameterised for PHYSICAL_ONLY
-- 2009-11-30 Darren.Pilkington Ignore dbcc check fixed
-- 2010-04-12 Darren.Pilkington Modifications to enable checks on VLDB's
-- 2010-07-07 Darren.Pilkington Corrected DATABASE_NAME to SYSNAME datatype
-- 2010-07-12 Darren.Pilkington Enhanced SQL Server version check
-- 2011-12-12 Darren.Pilkington Now skips log-shipped subscriber databases
-- 2012-10-25 Darren.Pilkington Removed SQL 2000 dependencies
--
-- This procedure will perform a DBCC CHECKDB for all active databases.
-- Valid check types are:
--		S : Standard Check (Default)
--		I : Ignore Check
--		P : Physical Check
--		L : Large database check (does a subset of tables each run)

SET NOCOUNT ON;
DECLARE @DATABASE_NAME SYSNAME;
DECLARE @ReturnCode INT;
DECLARE @CURRENT_LOG_RECORD INT;
DECLARE @CHECK_TYPE CHAR(1);

-- CURSOR for iteration through each database to be checked

DECLARE database_check_list_cursor CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR
	SELECT sd.name, ISNULL(cc.check_type,'S')
	FROM sys.databases sd
	LEFT OUTER JOIN dba_admin.dbo.DatabaseCheckControl cc ON sd.name = cc.database_name
	WHERE sd.source_database_id IS NULL -- Not a snapshot
	AND sd.state = 0                    -- Is online
	AND sd.is_read_only = 0             -- Is not read only
	AND sd.user_access = 0              -- Is open for nomal use (MULTI_USER)
	AND sd.name NOT IN (SELECT secondary_database FROM msdb.dbo.log_shipping_secondary_databases)  -- Not a log shipping secondary
	ORDER BY name;

OPEN database_check_list_cursor
FETCH NEXT FROM database_check_list_cursor INTO @DATABASE_NAME, @CHECK_TYPE

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO dba_admin.dbo.DatabaseCheckLog (database_name, start_time, check_type)
	VALUES (@DATABASE_NAME, GETDATE(), @CHECK_TYPE);
		
	SET @CURRENT_LOG_RECORD = CAST(@@IDENTITY AS INT);

	IF @CHECK_TYPE = 'P'	-- Physical only
	BEGIN
		DBCC CHECKDB ( @DATABASE_NAME ) WITH PHYSICAL_ONLY, ALL_ERRORMSGS, NO_INFOMSGS;					
	END
	IF @CHECK_TYPE = 'S'	-- Standard check
	BEGIN
		DBCC CHECKDB ( @DATABASE_NAME ) WITH ALL_ERRORMSGS, NO_INFOMSGS;
	END
	IF @CHECK_TYPE = 'L'	-- Large database check (table by table)
	BEGIN
		EXEC dbo.usp_CheckVLDB @DATABASE_NAME;
	END

	SET @RETURNCODE = @@ERROR;
		
	UPDATE dba_admin.dbo.DatabaseCheckLog
	SET end_time = GETDATE(),
		result = @RETURNCODE
	WHERE log_record_no = @CURRENT_LOG_RECORD
	AND end_time IS NULL;

	FETCH NEXT FROM database_check_list_cursor INTO @DATABASE_NAME, @CHECK_TYPE
END

CLOSE database_check_list_cursor;
DEALLOCATE database_check_list_cursor;

-- PURGE CHECKDB LOG HISTORY

DECLARE @CHECKDB_LOG_HISTORY_RETENTION AS INTEGER;
DECLARE @KEEPDATE DATETIME;

SET @CHECKDB_LOG_HISTORY_RETENTION = CAST((SELECT parameter_value
	 FROM dba_admin.dbo.systemparameters
	WHERE parameter_name = 'RETENTION_CHECKDB_HISTORY')AS INT);
SET @KEEPDATE = (SELECT DATEADD(mi,DATEDIFF(mi,0,GETDATE())-(@CHECKDB_LOG_HISTORY_RETENTION*(60*24)),0));

PRINT 'DELETING CHECKDB LOG RECORDS BEFORE: '+CAST(@KEEPDATE AS VARCHAR(50));

-- Delete Log Records
DELETE FROM dba_admin.dbo.DatabaseCheckLog WHERE end_time <= @KEEPDATE;
DELETE FROM dba_admin.dbo.DatabaseCheckVLDBLog WHERE end_time <= @KEEPDATE;
GO
