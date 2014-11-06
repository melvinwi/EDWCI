USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_BackupFull] 
AS

-- Lumo Energy | Database Administration
-- Full Database Backups
--
-- 2009-04-02 Darren.Pilkington Initial Release
-- 2009-06-15 Darren.Pilkington CHG-1263833 Production Release
-- 2009-06-29 Darren.Pilkington Enhanced cursor delaration syntax
-- 2009-08-18 Darren.Pilkington Disables / Enables robocopy job
-- 2009-10-05 Darren.Pilkington No longer disables transaction log backup job 
-- 2009-10-29 Darren.Pilkington Removed red
-- 2010-08-30 Paul.Storm	Now checks if Transasction Log Backup is running prior to execution.
-- 2011-05-24 Darren.Pilkington Excludes snapshot databases.
-- 2012-03-07 Darren.Pilkington Change name of copy offsite job.
-- 2013-01-16 Darren.Pilkington Initial Lumo Release
-- 2013-04-13 Darren.Pilkinfton Determins number of files for backupset
--
-- This procedure will generate a full backup for each database which requires it.
-- File extension for native backup: .bak
--
-- CURSOR for iteration through each database to be backed up

SET NOCOUNT ON;
DECLARE @DATABASE_NAME SYSNAME;
DECLARE @DATABASE_STATUS NVARCHAR(128);
DECLARE @isRunning BIT; 
DECLARE @file_num INT;

DECLARE database_backup_list_cursor CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR
	SELECT name FROM sys.databases WHERE source_database_id IS NULL
	EXCEPT
	SELECT database_name FROM dba_admin.dbo.DatabaseBackupIgnore WHERE ignore_full = 'Y'
	EXCEPT 
	SELECT name as database_name FROM sys.databases WHERE source_database_id IS NOT NULL
	ORDER BY name;

OPEN database_backup_list_cursor
FETCH NEXT FROM database_backup_list_cursor INTO @DATABASE_NAME

WHILE @@FETCH_STATUS = 0
BEGIN
	-- Check if the database can have a full backup made
	SET @DATABASE_STATUS = CONVERT(nVARCHAR,(SELECT DATABASEPROPERTYEX(@DATABASE_NAME,'STATUS')));
	IF @DATABASE_STATUS = 'ONLINE'
	BEGIN
		SET @file_num = (SELECT num_files FROM dba_admin..DatabaseBackupIgnore where database_name = @DATABASE_NAME);
		SET @file_num = ISNULL(@File_num,1);
		EXEC [dba_admin].[dbo].[usp_BackupFull_SingleDB] @DATABASE_NAME, @num_files = @file_num;
	END
	FETCH NEXT FROM database_backup_list_cursor INTO @DATABASE_NAME
END

CLOSE database_backup_list_cursor;
DEALLOCATE database_backup_list_cursor;

-- Run Transaction Log Backup job if not already running

EXEC dba_admin.dbo.usp_is_job_running
	@job_name = 'Database Backup - Transaction Logs',
	@is_running = @isRunning output

IF @isRunning = 0
BEGIN
	EXEC msdb.dbo.sp_start_job @job_name = 'Database Backup - Transaction Logs';
END







GO
