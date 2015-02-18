USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_RoboCopy2] 
@SourceLocation VARCHAR(250) = '',
@DestinationLocation VARCHAR(250) = '',
@FileMask VARCHAR(250) = '*',
@CopyParams VARCHAR(100) = ''

AS

-- Lumo Energy | Database Administration
-- Backup Files Copy Offsite
--
-- 2009-04-17 DARRENP Initial Release
-- 2010-04-19 DARRENP Checks for robocopy.exe after checking for copy location
-- 2010-12-16 DARRENP Split ffrom usp_RoboCopy to copy specified files from/to destination
--
-- This procedure uses robocopy.exe to copy files from a source to a destination.
-- robocopy.exe is obtained from the windows server resource kit.
-- it is expected in %WINDIR%\system32

SET NOCOUNT ON

DECLARE @BackupLocation AS VARCHAR(250);
DECLARE @DestDir AS VARCHAR(200);
DECLARE @CmdString AS VARCHAR(1000);
DECLARE @rc AS INT;
DECLARE @LogDir AS VARCHAR(250);

IF @DestinationLocation = ''
BEGIN
	PRINT 'Destination is not set -- Exiting now';
	GOTO EndProc;
END

IF @SourceLocation = ''
BEGIN
	PRINT 'Source is not set -- Exiting now';
	GOTO EndProc;
END

IF @CopyParams = ''
BEGIN
	PRINT 'Copy Parameters is not set -- Exiting now';
	GOTO EndProc;
END

-- Check if robocopy exists

EXECUTE @rc = master.dbo.xp_cmdshell 'dir /B %WINDIR%\system32\robocopy.exe', no_output;
IF (@rc = 1) BEGIN
                   PRINT 'ROBOCOPY.EXE DOES NOT EXISTS IN %WINDIR%\SYSTEM32';
                   RAISERROR('Robocopy does not exist.', 16, 1) WITH LOG;
                   GOTO EndProc;
             END 

SET @LogDir = 'c:\dba_admin'

SET @CmdString = '%WINDIR%\system32\robocopy.exe "' 
		+ @SourceLocation + '" "' + @DestinationLocation + '" '
		+ @FileMask + ' '
		+ @CopyParams + ' '
		+ '/LOG+:' + @LogDir + '\copyfiles.'+ UPPER(DATENAME(yy,GETDATE()))+DATENAME(wk,GETDATE()) +'.log';

-- PRINT @CmdString

EXECUTE @rc = master.dbo.xp_cmdshell @CmdString, no_output;

IF (@rc = 16) BEGIN PRINT '***FATAL ERROR***'; END ELSE
IF (@rc = 15) BEGIN PRINT 'FAIL MISM XTRA COPY'; END ELSE
IF (@rc = 14) BEGIN PRINT 'FAIL MISM XTRA'; END ELSE
IF (@rc = 13) BEGIN PRINT 'FAIL MISM COPY'; END ELSE
IF (@rc = 12) BEGIN PRINT 'FAIL MISM'; END ELSE
IF (@rc = 11) BEGIN PRINT 'FAIL XTRA COPY'; END ELSE
IF (@rc = 10) BEGIN PRINT 'FAIL XTRA'; END ELSE
IF (@rc = 9)  BEGIN PRINT 'FAIL COPY'; END ELSE
IF (@rc = 8)  BEGIN PRINT 'FAIL'; END ELSE
IF (@rc = 7)  BEGIN PRINT 'MISM XTRA COPY'; END ELSE
IF (@rc = 6)  BEGIN PRINT 'MISM XTRA'; END ELSE
IF (@rc = 5)  BEGIN PRINT 'MISM COPY'; END ELSE
IF (@rc = 4)  BEGIN PRINT 'MISM'; END ELSE
IF (@rc = 3)  BEGIN PRINT 'XTRA COPY'; END ELSE
IF (@rc = 2)  BEGIN PRINT 'XTRA'; END ELSE
IF (@rc = 1)  BEGIN PRINT 'COPY'; END ELSE
IF (@rc = 0)  BEGIN PRINT '-no change-'; END ELSE
              BEGIN PRINT 'RETURN CODE UNKNOWN'; END 
IF (@rc >= 8) BEGIN
                    PRINT '### FAIL '+CAST(@rc AS VARCHAR)+' ###';
                    RAISERROR('Robocopy has returned an error.', 16, 1) WITH LOG;
              END ELSE
              BEGIN PRINT '### SUCCESS '+CAST(@rc AS VARCHAR)+' ###'; END

EndProc:



GO
