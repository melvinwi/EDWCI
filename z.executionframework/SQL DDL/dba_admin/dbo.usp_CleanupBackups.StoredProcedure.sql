USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_CleanupBackups] 
AS
-- Lumo Energy | Database Administration
-- Delete old Database Backup files from disk.
--
-- This procedure will delete redundant database backup files from disk.
-- It makes use of the system catalogs to determin what backups to keep.
--
-- THIS IS FOR SQL SERVER 2005 or newer
--
-- 2009-04-28 DARRENP Initial Release
-- 2009-06-15 DARRENP CHG-1263833 Production Release
-- 2009-06-29 DARRENP Enhanced cursor delaration syntax
-- 2009-08-23 PAULS   Rationalise names, comments, cast retention days explicitly as decimal
-- 2009-09-21 DARRENP Fixed variable definitions based on cast type
-- 2009-12-17 DARRENP Added checks for differential backups and copy_only backups
-- 2009-12-17 DARRENP Ignores "copy only" backups
-- 2010-04-23 DARRENP Corrected Keep Diff Number usage
-- 2010-08-17 DARRENP Correctly maintains full/diff/log stream
-- 2010-09-17 DARRENP Checks ignoration - now both db and log
-- 2012-05-03 DARRENP Fix time-range checking for full db backup
-- 2012-07-06 DARRENP Lumo release
-- 2012-02-14 DARRENP Now copes with multiple files per backup

SET NOCOUNT ON;

DECLARE @Database_Name			SYSNAME;
DECLARE @Keep_Full_Days			DECIMAL(5,2);	-- RETENTION_DAYS_FULL_BACKUP
DECLARE @Keep_Log_Days			DECIMAL(5,2);	-- RETENTION_DAYS_LOG_BACKUP
DECLARE @Keep_Diff_Days			DECIMAL(5,2);	-- RETENTION_DAYS_DIFF_BACKUP
DECLARE @Keep_Full_Number		INT;			-- RETENTION_NUM_FULL_BACKUP
DECLARE @Keep_Diff_Number		INT;			-- RETENTION_NUM_DIFF_BACKUP
DECLARE @Keep_Log_Number		INT;			-- RETENTION_NUM_LOG_BACKUP
DECLARE @Backup_Location		VARCHAR(256);	-- BACKUP_LOCATION
DECLARE @Old_Backups_Warning	DECIMAL(5,2);	-- WARNING_OLD_BACKUPS
DECLARE @XPCMD					VARCHAR(8000);
DECLARE @Del_File_Name			VARCHAR(256);
DECLARE @File_Name				VARCHAR(256);
DECLARE @Del_Result				INT;
DECLARE @Return_Code			INT;

DECLARE @BackupsToKeep	TABLE (BackupName NVARCHAR(260));
DECLARE @backups_present_in_backup_directory TABLE (BackupName NVARCHAR(260));
DECLARE @Checkpoint_LSN TABLE (Checkpoint_LSN NUMERIC(25,0));
DECLARE @NotDefaultLocationBackups TABLE (BackupName NVARCHAR(260));

SET @Keep_Full_Days = CAST((SELECT parameter_value FROM dba_admin.dbo.systemparameters WHERE parameter_name = 'RETENTION_DAYS_FULL_BACKUP') as DECIMAL(5,2));
SET @Keep_Log_Days = CAST((SELECT parameter_value FROM dba_admin.dbo.systemparameters WHERE parameter_name = 'RETENTION_DAYS_LOG_BACKUP') as DECIMAL(5,2));
SET @Keep_Diff_Days = CAST((SELECT parameter_value FROM dba_admin.dbo.systemparameters WHERE parameter_name = 'RETENTION_DAYS_DIFF_BACKUP') as DECIMAL(5,2));
SET @Keep_Full_Number = CAST((SELECT parameter_value FROM dba_admin.dbo.systemparameters WHERE parameter_name = 'RETENTION_NUM_FULL_BACKUP')as INT);
SET @Keep_Log_Number = CAST((SELECT parameter_value FROM dba_admin.dbo.systemparameters WHERE parameter_name = 'RETENTION_NUM_LOG_BACKUP')as INT);
SET @Keep_Diff_Number = CAST((SELECT parameter_value FROM dba_admin.dbo.systemparameters WHERE parameter_name = 'RETENTION_NUM_DIFF_BACKUP')as INT);
SET @Backup_Location = (SELECT parameter_value FROM dba_admin.dbo.systemparameters WHERE parameter_name = 'BACKUP_LOCATION');
SET @Old_Backups_Warning = CAST((SELECT parameter_value FROM dba_admin.dbo.systemparameters WHERE parameter_name = 'WARNING_OLD_BACKUPS') as DECIMAL(5,2));

-- GET LIST OF BACKUPS ON DISK

SET @XPCMD = 'dir /B "'+ @Backup_Location + '\*.trn"';
INSERT INTO @backups_present_in_backup_directory EXEC master..xp_cmdshell @XPCMD;

SET @XPCMD = 'dir /B "'+ @Backup_Location + '\*.bak"';
INSERT INTO @backups_present_in_backup_directory EXEC master..xp_cmdshell @XPCMD;

SET @XPCMD = 'dir /B "'+ @Backup_Location + '\*.dif"';
INSERT INTO @backups_present_in_backup_directory EXEC master..xp_cmdshell @XPCMD;

-- CLEAN UP ANY INVALID RECORDS
DELETE FROM @backups_present_in_backup_directory WHERE BackupName IS NULL;
DELETE FROM @backups_present_in_backup_directory WHERE BackupName = 'File Not Found';

-- WARN no backups on disk --

IF (SELECT COUNT(BackupName) FROM @backups_present_in_backup_directory) = 0
BEGIN
	PRINT 'NO FILES FOUND ON DISK - IS THIS EXPECTED?';
    RAISERROR('No Backup Files On Disk - Is this expected?.', 16, 1) WITH LOG;
	GOTO EndOfStoredProcedure;
END

-- PREPEND BACKUP LOCATION TO FOUND FILES
UPDATE @backups_present_in_backup_directory SET BackupName = UPPER(@Backup_Location+'\'+BackupName);

-- GET LIST OF DATABASES TO PROCESS

DECLARE database_backup_list_cursor CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR
SELECT name FROM sys.databases WHERE source_database_id IS NULL
EXCEPT
SELECT database_name 
FROM dba_admin.dbo.DatabaseBackupIgnore 
WHERE ignore_full = 'Y'
ORDER BY name;

-- PROCESS EACH DATABASE FOR REQUIRED BACKUPS

OPEN database_backup_list_cursor
FETCH NEXT FROM database_backup_list_cursor INTO @DATABASE_NAME
WHILE @@FETCH_STATUS = 0
BEGIN

-- Insert into @BackupsToKeep full backup files required.
-- Required number of backups

	INSERT INTO @BackupsToKeep
	SELECT UPPER(bmf.physical_device_name)    
	FROM msdb.dbo.backupmediafamily bmf
	WHERE bmf.media_set_id IN
	(	
		SELECT TOP(@Keep_Full_Number) media_set_id 
		FROM msdb.dbo.backupset bs
		where bs.database_name = @DATABASE_NAME
		AND bs.type = 'D'
		ORDER BY bs.backup_finish_date DESC
	)	
	AND UPPER(bmf.physical_device_name) LIKE UPPER(@Backup_Location+'%');
	

-- Required time range of backups
	INSERT INTO @BackupsToKeep
	SELECT UPPER(bmf.physical_device_name)    
	FROM msdb.dbo.backupmediafamily bmf
	WHERE bmf.media_set_id IN
	(	
		SELECT media_set_id 
		FROM msdb.dbo.backupset bs
		where bs.database_name = @DATABASE_NAME
		AND bs.type = 'D'
		AND bs.backup_finish_date >= DATEADD(dd,-@Keep_Full_Days, GETDATE())
	)	
	AND UPPER(bmf.physical_device_name) LIKE UPPER(@Backup_Location+'%');
	
	FETCH NEXT FROM database_backup_list_cursor INTO @DATABASE_NAME;
END
CLOSE database_backup_list_cursor;
DEALLOCATE database_backup_list_cursor;

-- FULL BACKUPS PROCESSING END

-- DIFFERENTIAL BACKUPS PROCESSING START

DECLARE database_diff_backup_list_cursor CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR
SELECT name FROM master.dbo.sysdatabases
EXCEPT
SELECT database_name 
FROM dba_admin.dbo.DatabaseBackupIgnore 
WHERE ignore_diff = 'Y' or ignore_full = 'Y'
ORDER BY name;

OPEN database_diff_backup_list_cursor
FETCH NEXT FROM database_diff_backup_list_cursor INTO @DATABASE_NAME
WHILE @@FETCH_STATUS = 0
BEGIN

	-- insert into @BackupsToKeep differential backup files not to delete
	-- for both number of full backups to keep from and full backup retention time

	INSERT INTO @Checkpoint_LSN
		SELECT TOP(@Keep_Diff_Number) checkpoint_lsn
		FROM msdb.dbo.backupset 
		WHERE database_name = @DATABASE_NAME
		AND type = 'D'
		AND is_copy_only = 0
	UNION
		SELECT checkpoint_lsn
		FROM msdb.dbo.backupset 
		WHERE database_name = @DATABASE_NAME
		AND type = 'D'
		AND backup_finish_date >= DATEADD(dd,-@Keep_Diff_Days, GETDATE())
		AND is_copy_only = 0;

	INSERT INTO @BackupsToKeep
	SELECT TOP(@Keep_Diff_Number) UPPER(bmf.physical_device_name)
	FROM msdb.dbo.backupmediafamily bmf
	INNER JOIN msdb.dbo.backupset bs
	ON bmf.media_set_id = bs.media_set_id 
	WHERE bs.database_name = @DATABASE_NAME
	AND bs.type ='I'
	AND bs.is_copy_only = 0
	AND UPPER(bmf.physical_device_name) like UPPER(@Backup_Location+'%')
	AND bs.database_backup_lsn in (SELECT checkpoint_lsn FROM @Checkpoint_LSN)
	ORDER BY bs.backup_finish_date DESC;

	INSERT INTO @BackupsToKeep
	SELECT UPPER(bmf.physical_device_name)
	FROM msdb.dbo.backupmediafamily bmf
	INNER JOIN msdb.dbo.backupset bs
	ON bmf.media_set_id = bs.media_set_id 
	WHERE bs.database_name = @DATABASE_NAME
	AND bs.type ='I'
	AND bs.is_copy_only = 0
	AND UPPER(bmf.physical_device_name) like UPPER(@Backup_Location+'%')
	AND bs.database_backup_lsn in (SELECT checkpoint_lsn FROM @Checkpoint_LSN)
	AND bs.backup_finish_date >= DATEADD(dd,-@Keep_Diff_Days, GETDATE())
	ORDER BY bs.backup_finish_date DESC;


	DELETE FROM @Checkpoint_LSN;

	FETCH NEXT FROM database_diff_backup_list_cursor INTO @DATABASE_NAME;
END

CLOSE database_diff_backup_list_cursor;
DEALLOCATE database_diff_backup_list_cursor;

-- DIFF BACKUPS PROCESSING END

-- TRANSACTION LOG BACKUPS PROCESSING START

DECLARE database_log_backup_list_cursor CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR
SELECT name FROM master.dbo.sysdatabases
EXCEPT
SELECT database_name 
FROM dba_admin.dbo.DatabaseBackupIgnore 
WHERE ignore_log = 'Y'
ORDER BY name;

OPEN database_log_backup_list_cursor
FETCH NEXT FROM database_log_backup_list_cursor INTO @DATABASE_NAME
WHILE @@FETCH_STATUS = 0
BEGIN

	-- insert into @BackupsToKeep transaction log backups files not to delete
	-- for both number of full backups or differential backups to keep from and retention time

	IF (SELECT COUNT(type)
		FROM msdb.dbo.backupset 
		WHERE database_name = @DATABASE_NAME
		AND is_copy_only = 0
		AND msdb.dbo.backupset.type = 'I' 
		AND backup_finish_date >= DATEADD(dd,-@Keep_Diff_Days, GETDATE())
		) > 0
	BEGIN

	INSERT INTO @Checkpoint_LSN
		SELECT TOP(@Keep_Diff_Number) checkpoint_lsn
		FROM msdb.dbo.backupset 
		WHERE database_name = @DATABASE_NAME
		AND is_copy_only = 0
		AND msdb.dbo.backupset.type = 'I'
		ORDER BY backup_finish_date DESC;
		
		INSERT INTO @BackupsToKeep
		SELECT UPPER(physical_device_name)
		FROM msdb.dbo.backupmediafamily 
		INNER JOIN msdb.dbo.backupset 
		ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id 
		WHERE database_name = @DATABASE_NAME
		AND msdb.dbo.backupset.type = 'L'
		AND UPPER(physical_device_name) like UPPER(@Backup_Location+'%')
		AND checkpoint_lsn >= (SELECT MIN(checkpoint_lsn) FROM @Checkpoint_LSN);
	END
	ELSE
	BEGIN
		INSERT INTO @Checkpoint_LSN
			SELECT TOP(@Keep_Log_Number) checkpoint_lsn
			FROM msdb.dbo.backupset 
			WHERE database_name = @DATABASE_NAME
			AND is_copy_only = 0
			AND msdb.dbo.backupset.type = 'D'
			ORDER BY backup_finish_date DESC;

		INSERT INTO @BackupsToKeep
			SELECT UPPER(bmf.physical_device_name)
			FROM msdb.dbo.backupmediafamily bmf
			INNER JOIN msdb.dbo.backupset bs
			ON bmf.media_set_id = bs.media_set_id 
			WHERE bs.database_name = @DATABASE_NAME
			AND bs.type = 'L'
			AND UPPER(bmf.physical_device_name) like UPPER(@Backup_Location+'%')
			AND bs.database_backup_lsn in (SELECT checkpoint_lsn FROM @Checkpoint_LSN)
			UNION 
			SELECT UPPER(physical_device_name)
			FROM msdb.dbo.backupmediafamily bmf
			INNER JOIN msdb.dbo.backupset bs
			ON bmf.media_set_id = bs.media_set_id 
			WHERE bs.database_name = @DATABASE_NAME
			AND bs.type = 'L'
			AND UPPER(bmf.physical_device_name) like UPPER(@Backup_Location+'%')
			AND bs.database_backup_lsn in (SELECT checkpoint_lsn
									FROM msdb.dbo.backupset 
									WHERE database_name = @DATABASE_NAME
									AND type = 'D'
									AND is_copy_only = 0
									AND backup_finish_date >= DATEADD(dd,-@Keep_Full_Days, GETDATE())
	)
	END
	DELETE FROM @Checkpoint_LSN;
	FETCH NEXT FROM database_log_backup_list_cursor INTO @DATABASE_NAME;
END

CLOSE database_log_backup_list_cursor;
DEALLOCATE database_log_backup_list_cursor;

-- TRANSACTION LOG BACKUPS PROCESSING END
 
-- WARN IF BACKUPS ARE MISSING OFF DISK

IF (SELECT COUNT(BackupName)
	FROM @BackupsToKeep
	WHERE BackupName NOT IN (SELECT BackupName FROM @backups_present_in_backup_directory)) > 0
BEGIN
	PRINT '### THESE BACKUPS ARE MISSING:';
	SELECT DISTINCT BackupName FROM @BackupsToKeep
	WHERE BackupName NOT IN (SELECT BackupName FROM @backups_present_in_backup_directory);
-- RAISERROR('Backups are missing off disk - Why?.', 16, 1) WITH LOG;
END
ELSE
BEGIN
	PRINT '### NO BACKUPS MISSING OFF DISK.';
END

-- NOTIFY OF OLD BACKUPS IN NON DEFAULT LOCATION

INSERT INTO @NotDefaultLocationBackups (BackupName)
	SELECT UPPER(physical_device_name)
	FROM msdb.dbo.backupmediafamily 
	INNER JOIN msdb.dbo.backupset
	ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id 
	WHERE NAME NOT IN
		(SELECT database_name 
		FROM dba_admin.dbo.DatabaseBackupIgnore 
		WHERE ignore_full = 'Y')
	AND UPPER(physical_device_name) not like UPPER(@Backup_Location+'%')
	AND msdb.dbo.backupset.backup_finish_Date <= DATEADD(mi,DATEDIFF(mi,0,GETDATE())-(@Old_Backups_Warning*(60.00*24.00)),0);

IF (SELECT COUNT(BackupName) FROM @NotDefaultLocationBackups) > 0
BEGIN
	-- THERE MAY BE BACKUPS IN A NON-DEFAULT LOCATION

	DECLARE non_default_backup_list_cursor CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR
	SELECT BackupName FROM @NotDefaultLocationBackups;

	OPEN non_default_backup_list_cursor
	FETCH NEXT FROM non_default_backup_list_cursor INTO @File_Name
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @XPCMD = 'dir /B "'+ @File_Name;
		EXEC @Return_Code = master..xp_cmdshell @XPCMD, no_output;
		IF @Return_Code <> 0
		BEGIN
			DELETE FROM @NotDefaultLocationBackups
			WHERE BackupName = @File_Name;
		END
		FETCH NEXT FROM non_default_backup_list_cursor INTO @File_Name;
	END

	CLOSE non_default_backup_list_cursor;
	DEALLOCATE non_default_backup_list_cursor;
END


IF (SELECT COUNT(BackupName) FROM @NotDefaultLocationBackups) > 0
	BEGIN	
		PRINT 'THESE ARE OLD BACKUPS IN NON-DEFAULT LOCATION:';

		SELECT BackupName
		FROM @NotDefaultLocationBackups;

		IF @Old_Backups_Warning <> 0
		BEGIN
			RAISERROR('Old backups in non-default location. Investigate.', 16, 1) WITH LOG;
		END
	END
ELSE
BEGIN
	PRINT 'Backups are all where they''re supposed to be.';
END

-- NOW DELETE FROM Known Backups those we need to keep.
DELETE FROM @backups_present_in_backup_directory
WHERE BackupName IN (SELECT DISTINCT BackupName
					FROM @BackupsToKeep);

-- NOW DELETE THE FILES THAT ARE TOO OLD

IF (SELECT COUNT(BackupName) FROM @backups_present_in_backup_directory) = 0
BEGIN
	PRINT 'NO BACKUPS TO DELETE';
	GOTO EndOfStoredProcedure;
END
ELSE
BEGIN
	PRINT '### DELETING FILES NOW';

	DECLARE delete_file_cursor CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR
	SELECT BackupName FROM @backups_present_in_backup_directory;

	OPEN delete_file_cursor;
	FETCH NEXT FROM delete_file_cursor INTO @DEL_FILE_NAME;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @XPCMD = 'del /F "'+ @DEL_FILE_NAME + '"';

		EXEC @Del_Result = master..xp_cmdshell @XPCMD;
		IF (@Del_Result = 0)
		BEGIN
			PRINT 'DELETED '+@DEL_FILE_NAME;
		END
		ELSE
		BEGIN
			PRINT '### FILE NOT DELETED '+@DEL_FILE_NAME;
			RAISERROR('File could not be deleted.', 16, 1) WITH LOG;
		END

		FETCH NEXT FROM delete_file_cursor INTO @DEL_FILE_NAME;
	END

	CLOSE delete_file_cursor;
	DEALLOCATE delete_file_cursor;
END

EndOfStoredProcedure:







GO
