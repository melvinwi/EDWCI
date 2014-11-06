USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_BackupTransactionLog] 
AS

-- Lumo Energy | Database Administration
-- Database Transaction Log Backups
--
-- 2009-03-04 DARRENP - Initial Release
-- 2009-06-15 DARRENP - CHG-1263833 Production Release
-- 2009-06-29 DARRENP - Enhanced cursor delaration syntax
-- 2009-07-17 pauls   - check if DB has had initial full backup, if not make one.
-- 2009-10-05 DARRENP - Check if backup or restore is running on chosen database and skip if it is.
-- 2009-10-26 DARRENP - SQL 2K5+ backups will perform CHECKSUM
--                    - Checks for databases in STANDBY mode (and will not back them up)
-- 2009-11-02 DARRENP - Fixed problem where only "FULL RECOVERY" db's where being backed up, now includes "BULK-LOGGED" as well
-- 2010-07-07 DARRENP - Corrected DATABASE_NAME to SYSNAME datatype
-- 2010-08-30 DARRENP - Corrected "RESTORE DATABASE" in Backups running check
-- 2010-10-19 DARRENP - Increased size of database name field for backup
-- 2011-05-17 DARRENP - Will now ignore read-only databases (including snapshots)
-- 2013-01-16 DARRENP - Initial Lumo release
--
-- This procedure will generate a transaction log backup for each database which requires it.
-- File extension for native backup: .trn

SET NOCOUNT ON;
DECLARE @BACKUP_TIME		VARCHAR(100);
DECLARE @BACKUP_LOCATION	VARCHAR(200);
DECLARE @DATABASE_NAME		SYSNAME;
DECLARE @BACKUP_FILENAME	VARCHAR(1000);
DECLARE @CAN_BACKUP			INT;
DECLARE @BACKUP_COMMAND		nVARCHAR(1000);
DECLARE @CAN_COMPRESS		INT;

SET @BACKUP_TIME = LEFT(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR, GETDATE(), 121),'-',''),' ',''),':',''),12);
SET @BACKUP_LOCATION = (SELECT parameter_value FROM dba_admin.dbo.systemparameters WHERE parameter_name = 'BACKUP_LOCATION');

-- CURSOR for iteration through each database to be backed up

DECLARE database_backup_list_cursor CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR
SELECT name FROM sys.databases
EXCEPT
SELECT database_name
FROM dba_admin.dbo.DatabaseBackupIgnore
WHERE ignore_log = 'Y'
ORDER BY name;

OPEN database_backup_list_cursor;
FETCH NEXT FROM database_backup_list_cursor INTO @DATABASE_NAME
WHILE @@FETCH_STATUS = 0
BEGIN

-- Check if backups or restores are running on current database
	IF (SELECT COUNT(command)
	FROM sys.dm_exec_requests 
	WHERE command IN ('RESTORE DATABASE','BACKUP DATABASE',' RESTORE LOG','BACKUP LOG')
	AND DB_NAME(database_id) = @DATABASE_NAME) > 0
	BEGIN
		GOTO SKIP_DB_BACKUP
	END

-- check instance version and editon to see if can do a native compressed backup
	SET @CAN_COMPRESS = 0;

	IF (SELECT CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(128)),4) AS DECIMAL)) >= 10.5
	BEGIN
		SET @CAN_COMPRESS = 1;
	END

	IF (SELECT LEFT(CAST(SERVERPROPERTY('ProductVersion') AS VARCHAR(128)),4)) = '10.0'
	BEGIN
		IF (SELECT LEFT(CAST(SERVERPROPERTY('Edition') AS VARCHAR(128)),11)) = 'Enterprise'
		BEGIN
			SET @CAN_COMPRESS = 1;
		END
	END

-- Check if the database can have a transaction log backup

	SET @CAN_BACKUP = (SELECT 
		CASE (DATABASEPROPERTYEX(@DATABASE_NAME,'Status')) WHEN 'Online' THEN 1 ELSE 0 END
		&
		CASE (DATABASEPROPERTYEX(@DATABASE_NAME,'IsInStandBy')) WHEN 0 THEN 1 ELSE 0 END
		&
		CASE (DATABASEPROPERTYEX(@DATABASE_NAME,'Updateability ')) WHEN 'READ_ONLY' THEN 0 ELSE 1 END
		&
		CASE (DATABASEPROPERTYEX(@DATABASE_NAME,'Recovery')) WHEN 'SIMPLE' THEN 0 ELSE 1 END)

	IF @CAN_BACKUP = 1
	BEGIN
		-- Check an initial full backup has been made. If not, make one
		IF NOT EXISTS (SELECT database_name
				FROM msdb.dbo.backupset
				WHERE type = 'D'
				AND database_name = @DATABASE_NAME)
		BEGIN
			EXEC dba_admin.dbo.usp_BackupFull_SingleDB @DATABASE_NAME;
		END

		SET @BACKUP_FILENAME=@BACKUP_LOCATION+'\'+@DATABASE_NAME+'_'+RTRIM(@BACKUP_TIME) + '.trn';
		SET @BACKUP_COMMAND = N'BACKUP LOG @dbname TO DISK = @bakfilename WITH CHECKSUM'
	
		IF @CAN_COMPRESS = 1
		BEGIN
			SET @BACKUP_COMMAND = @BACKUP_COMMAND + ', COMPRESSION'
		END

		EXECUTE sp_executesql
			@BACKUP_COMMAND,
			N'@dbname SYSNAME, @bakfilename VARCHAR(200)',
			@DATABASE_NAME, @BACKUP_FILENAME;	
	END

	SKIP_DB_BACKUP:

FETCH NEXT FROM database_backup_list_cursor INTO @DATABASE_NAME
END

CLOSE database_backup_list_cursor;
DEALLOCATE database_backup_list_cursor;


GO
