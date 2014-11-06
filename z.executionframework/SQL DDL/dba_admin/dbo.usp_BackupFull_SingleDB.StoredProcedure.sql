USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_BackupFull_SingleDB] 
@DATABASE_NAME SYSNAME,
@BACKUP_LOCATION VARCHAR(200) = '',	-- default value = empty string
@FILE_NAME VARCHAR(200) = '',		-- default value = empty string
@COPY_ONLY CHAR(1) = 'N',			-- default value = N for No
@COMPRESS CHAR(1) = 'Y',			-- default value = Y for Yes
@NUM_FILES INT = 1					-- default value for num of files for db backup = 1

AS

-- Lumo Energy | Database Administration
-- Single Database Full Backup
--
-- 2009-03-04 DARRENP Initial release
-- 2009-07-15 PAULS   exise backup code from usp_BackupFull, create stand alone proc for single db, add optional parameter for destination directory to be passed in.
-- 2009-10-23 DARRENP SQL 2K5+ backups will perform CHECKSUM and checks db's in standby mode
-- 2009-12-30 DARRENP New parameter for backup file name
-- 2010-10-20 DARRENP Corrected databasename variables to sysname data type
-- 2011-11-10 DARRENP Added @olrmap parameter to speed up object level recovery
-- 2012-07-16 DARRENP Removed SQL 2K code and included native compression as default where possible.
-- 2013-01-25 DARRENP Added new params - copy_only, compress & num_files
-- 2013-12-09 DARRENP Restore CHECKSUM option
--
-- This procedure will generate a full backup of the nominated database (if it's online)
-- The backup will be written to a nominated directory, or the location configured in dba_admin.dbo.systemparameters
-- It will either generate a native or LiteSpeed backup.
-- If the native backup can be compressed it will be.
--
-- File extension for native backup: .ntv.bak
--
-- usage:	exec dba_admin.dbo.[usp_BackupFull_SingleDB] 'databaseName'
-- usage:	exec dba_admin.dbo.[usp_BackupFull_SingleDB] 'dba_admin', 'c:\temp'
-- usage:	exec dba_admin.dbo.[usp_BackupFull_SingleDB] 'dba_admin', 'c:\temp', 'dba_admin.bak'

SET NOCOUNT ON;
DECLARE @BACKUP_TIME CHAR(100);
DECLARE @BACKUP_LITESPEED CHAR(1);
DECLARE @BACKUP_FILENAME VARCHAR(MAX);
DECLARE @ENCRYPTION_KEY VARCHAR(50);
DECLARE @CAN_BACKUP INT;
DECLARE @BACKUP_COMMAND nVARCHAR(MAX);
DECLARE @CAN_COMPRESS CHAR(1);

-- if no location passed in, lookup from systemparameters
IF LEN(@BACKUP_LOCATION) = 0 
BEGIN
	SET @BACKUP_LOCATION = (SELECT parameter_value FROM dba_admin.dbo.systemparameters WHERE parameter_name = 'BACKUP_LOCATION');
END

SET @BACKUP_TIME = LEFT(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR, GETDATE(), 121),'-',''),' ',''),':',''),12);

-- check instance version and editon to see if can do a native compressed backup

SET @CAN_COMPRESS = 'N';

IF (SELECT CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(128)),4) AS DECIMAL)) >= 10.5
BEGIN
	SET @CAN_COMPRESS = 'Y';
END
IF (SELECT LEFT(CAST(SERVERPROPERTY('ProductVersion') AS VARCHAR(128)),4)) = '10.0'
BEGIN
	IF (SELECT LEFT(CAST(SERVERPROPERTY('Edition') AS VARCHAR(128)),11)) = 'Enterprise'
	BEGIN
		SET @CAN_COMPRESS = 'Y';
	END
END

IF @COMPRESS = 'N' -- REQUEST UNCOMPRESSED BACKUP
BEGIN
	SET @CAN_COMPRESS = 'N';
END

-- Check if the database can have a full backup made
SET @CAN_BACKUP = (SELECT
			CASE (DATABASEPROPERTYEX(@DATABASE_NAME,'Status')) WHEN 'Online' THEN 1 ELSE 0 END
			&
			CASE (DATABASEPROPERTYEX(@DATABASE_NAME,'IsInStandBy')) WHEN 0 THEN 1 ELSE 0 END);

DECLARE @count_files INT;

IF @CAN_BACKUP = 1
BEGIN
	
	SET @BACKUP_COMMAND = N'BACKUP DATABASE ['+@DATABASE_NAME+'] TO ';

	IF LEN(@FILE_NAME) = 0 
	BEGIN
		IF @NUM_FILES = 1
		BEGIN
			SET @BACKUP_COMMAND = @BACKUP_COMMAND + 'DISK = '''+@BACKUP_LOCATION+'\'+@DATABASE_NAME+'_'+RTRIM(@BACKUP_TIME) + '.bak''';
		END
		ELSE
		BEGIN
			SET @count_files = 1;
			WHILE @count_files <= @NUM_FILES
			BEGIN
				SET @BACKUP_COMMAND = @BACKUP_COMMAND + ' DISK = '''+ @BACKUP_LOCATION+'\'+@DATABASE_NAME+'_'+RTRIM(@BACKUP_TIME)+'_'+CAST(@count_files AS VARCHAR(2))+ '.bak'''
				SET @count_files = @count_files + 1;
				IF @count_files <= @NUM_FILES
				BEGIN
					SET @BACKUP_COMMAND = @BACKUP_COMMAND + ', ';
				END
			END
		END
	END

	SET @BACKUP_COMMAND = @BACKUP_COMMAND + ' WITH CHECKSUM'	

	IF @CAN_COMPRESS = 'Y'
	BEGIN
		SET @BACKUP_COMMAND = @BACKUP_COMMAND + ', COMPRESSION'
	END
		
	IF @COPY_ONLY = 'Y'
	BEGIN
		SET @BACKUP_COMMAND = @BACKUP_COMMAND + ', COPY_ONLY'
	END
	
	PRINT @BACKUP_COMMAND

	EXECUTE (@BACKUP_COMMAND);
	
END




GO
