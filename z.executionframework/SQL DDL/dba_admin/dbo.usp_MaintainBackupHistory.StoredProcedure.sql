USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MaintainBackupHistory] 
AS


-- Lumo Energy| Database Administration
-- Backup History Catalog Maintenance
--
-- 2012-10-11 Darren.Pilkington Initial Release
--
-- This procedure will maintain the size of the backup and restore history tables 
-- by deleting the entries for backup sets older than the specified date range.
-- We make use of the supplied msdb.dbo.sp_delete_backuphistory

SET NOCOUNT ON
DECLARE @purge_date DATETIME;
DECLARE @cutoff_date DATETIME;
DECLARE @RetentionBackupHistory VARCHAR(250);
DECLARE @BACKUP_LITESPEED CHAR(1);
DECLARE @DATABASE_VERSION INT;
DECLARE @RETRY_COUNT INT;

SET @RetentionBackupHistory = CAST((SELECT parameter_value FROM dba_admin.dbo.SystemParameters WHERE parameter_name = 'RETENTION_BACKUP_HISTORY')AS INT);
SET @cutoff_date = DATEADD(dd,DATEDIFF(dd,0,GETDATE())-@RetentionBackupHistory,0);

-- Determine instance version

-- Check if backups are running, if so, wait 5 minutes then and try again

SET @RETRY_COUNT = 0;

WHILE @RETRY_COUNT < 2
BEGIN
	IF (SELECT COUNT(command)
		FROM sys.dm_exec_requests 
		WHERE command IN ('RESTORE DATBASE','BACKUP DATABASE',' RESTORE LOG','BACKUP LOG')) > 0
		CONTINUE
	ELSE BREAK;

	SET @RETRY_COUNT = @RETRY_COUNT + 1;
	
	IF (@RETRY_COUNT) > 2
	BEGIN
		PRINT 'TIMEOUT - backups running';
		RETURN;
	END

	PRINT 'WAITING COUNT '+CAST(@RETRY_COUNT AS VARCHAR(2));
	WAITFOR DELAY '00:05';
END

PRINT 'Purge backup history before Cutoff Date = ' + CONVERT(VARCHAR(10),@cutoff_date ,121);

WHILE	1 = 1
	BEGIN
	SET @purge_date = null
	-- Find date of oldest backup set
	SELECT
		@purge_date = dateadd(dd,datediff(dd,0,min(backup_finish_date))+1,0)
	FROM
		msdb.dbo.backupset
	WHERE
		backup_finish_date <= @cutoff_date
	IF @purge_date is null or @purge_date > @cutoff_date
		BEGIN
		PRINT 'Purge backup history complete through '+	CONVERT(VARCHAR(10),@cutoff_date ,121)
		BREAK
		END
	PRINT CHAR(10)+CHAR(13)+'Purging backup history before ' + CONVERT(VARCHAR(10),@purge_date,121) + CHAR(10) + CHAR(13)
	SELECT
		[Backup Sets to be Deleted Count ] = COUNT(*) 
	FROM
		msdb.dbo.backupset
	WHERE
		backup_finish_date < @purge_date
	
	EXEC msdb.dbo.sp_delete_backuphistory @purge_date
END  -- End While

GO
