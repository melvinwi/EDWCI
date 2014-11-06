USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [audit].[usp_LoadAuditTrace] 
AS

-- Lumo Energy | Database Administration
--
-- Load SQL Profiler Audit Trace
-- 2009-05-25 Darren.Pilkington Initial release
-- 2014-01-07 Darren.Pilkington Reviewed for SQL Server 2008 R2
-- 2014-01-13 Darren.Pilkington Will load all files in trace directory
--
-- This procedure will load SQL Profiler traces for auditing purposes.
--

SET NOCOUNT ON;

DECLARE @XPCMD VARCHAR(8000);
DECLARE @Trace_File_Name NVARCHAR(245);
DECLARE @Del_File_Name VARCHAR(256);
DECLARE @File_Name VARCHAR(256);
DECLARE @Del_Result INT;
DECLARE @Return_Code AS INT;
DECLARE @TraceID int;
DECLARE @TraceDir VARCHAR(4000);
DECLARE @RowCOunt BIGINT;

-- FIND LOCATION OF SQL ROOT LOCATION
EXEC master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE',N'Software\Microsoft\MSSQLServer\Setup',N'SQLDataRoot', @TraceDir OUTPUT, 'no_output';
SET	@TraceDir = @TraceDir + '\JOBS\audit_trace';

-- Stop then start a new trace to enable processing of files
-- EXEC msdb.dbo.sp_update_job @job_name =N'Instance Audit - Watchdog', @enabled=0;

-- Find the traceIDs of the current audit trace(s)

DECLARE database_trace_list_cursor CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR
	SELECT traceid FROM :: fn_trace_getinfo(default) WHERE property = 2 AND CAST(value AS VARCHAR(MAX)) LIKE '%audit_trace%';

OPEN database_trace_list_cursor
FETCH NEXT FROM database_trace_list_cursor INTO @TraceID

WHILE @@FETCH_STATUS = 0
BEGIN

	-- Stop the audit trace

	EXEC sp_trace_setstatus @TraceID, 0;

	WHILE
		(SELECT value FROM :: fn_trace_getinfo(@TraceID) where property = 5) <> 0
	BEGIN
	-- WAIT FOR TRACE TO STOP
		WAITFOR DELAY '00:00:01';
		PRINT 'WAITING';
		IF (SELECT value FROM :: fn_trace_getinfo(@TraceID) where property = 5) = 0
		BEGIN
			BREAK
		END		
	END

-- Close the current audit trace

	EXEC sp_trace_setstatus @TraceID, 2;

	WHILE
		(SELECT COUNT(value) FROM :: fn_trace_getinfo(@TraceID) where property = 5) > 0
	BEGIN
	-- WAIT FOR TRACE TO BE DELETED
		WAITFOR DELAY '00:00:01';
		PRINT 'WAITING';
		IF (SELECT count(value) FROM :: fn_trace_getinfo(@TraceID) where property = 5) = 0
		BEGIN
			BREAK
		END		
	END
	
	FETCH NEXT FROM database_trace_list_cursor INTO @TraceID
END

CLOSE database_trace_list_cursor;
DEALLOCATE database_trace_list_cursor;

-- Start a new audit trace

EXEC [master].[dbo].[usp_StartAuditTrace];

-- Find files to process

CREATE TABLE #TraceFiles (TraceFileName NVARCHAR(1024));

-- GET LIST OF trace files ON DISK

SET @XPCMD = 'dir /B "'+@TraceDir+'\"*.trc';
INSERT INTO #TraceFiles EXEC master..xp_cmdshell @XPCMD;

-- CLEAN UP ANY INVALID FILE RECORDS
DELETE FROM #TraceFiles WHERE TraceFileName IS NULL;
DELETE FROM #TraceFiles WHERE TraceFileName = 'File Not Found';

IF (SELECT COUNT(TraceFileName) FROM #TraceFiles) = 0
BEGIN
	PRINT 'NO FILES FOUND ON DISK - IS THIS EXPECTED?';
    RAISERROR('No Trace Files On Disk - Is this expected?.', 16, 1) WITH LOG;
	GOTO EndOfStoredProcedure;
END

-- PREPEND BACKUP LOCATION TO FOUND FILES
UPDATE #TraceFiles SET TraceFileName = @TraceDir+'\'+TraceFileName;

-- REMOVE THE CURRENT TRACE FILES FROM LIST OF FILES TO PROCESS
DELETE FROM #TraceFiles WHERE TraceFileName IN (SELECT value FROM :: fn_trace_getinfo(default)
												WHERE property = 2
												AND CAST(value AS VARCHAR(MAX)) LIKE '%audit_trace%');

-- NOW PROCESS AND DELETE TRACE FILES

DECLARE trace_file_cursor CURSOR FOR
SELECT TraceFileName FROM #TraceFiles;

OPEN trace_file_cursor;
FETCH NEXT FROM trace_file_cursor INTO @TRACE_FILE_NAME;
WHILE @@FETCH_STATUS = 0
BEGIN

	SELECT * 
	INTO #AccessAuditTraceData_load
	FROM ::fn_trace_gettable(@TRACE_FILE_NAME, default);
		
	SET @XPCMD = 'del /F "'+ @TRACE_FILE_NAME + '"';
		EXEC @Del_Result = xp_cmdshell @XPCMD;
		IF (@Del_Result = 0)
		BEGIN
			PRINT 'DELETED '+@TRACE_FILE_NAME;
		END
		ELSE
		BEGIN
			PRINT '### FILE NOT DELETED '+@TRACE_FILE_NAME;
			RAISERROR('File could not be deleted.', 16, 1) WITH LOG;
		END


	SET @RowCount = (SELECT COUNT(1) FROM #AccessAuditTraceData_load);

	IF @RowCount > 0
	BEGIN

	-- REMOVE RECORDS ASSOCIATED TO SQL AGENT LOAD JOB

	DELETE FROM #AccessAuditTraceData_load
	WHERE ApplicationName LIKE '%'+(SELECT CONVERT(VARCHAR(32),cast(job_id as binary(16)),2) FROM msdb.dbo.sysjobs WHERE name = 'Instance Audit - Load Audit Data')+'%';

	-- CAPTURE REQUIRED RECORDS
	
		INSERT INTO [dba_admin].[audit].[AccessAuditTraceData]
				   ([TextData]
				   ,[BinaryData]
				   ,[DatabaseID]
				   ,[TransactionID]
				   ,[LineNumber]
				   ,[NTUserName]
				   ,[NTDomainName]
				   ,[HostName]
				   ,[ClientProcessID]
				   ,[ApplicationName]
				   ,[LoginName]
				   ,[SPID]
				   ,[Duration]
				   ,[StartTime]
				   ,[EndTime]
				   ,[Reads]
				   ,[Writes]
				   ,[CPU]
				   ,[Permissions]
				   ,[Severity]
				   ,[EventSubClass]
				   ,[ObjectID]
				   ,[Success]
				   ,[IndexID]
				   ,[IntegerData]
				   ,[ServerName]
				   ,[EventClass]
				   ,[ObjectType]
				   ,[NestLevel]
				   ,[State]
				   ,[Error]
				   ,[Mode]
				   ,[Handle]
				   ,[ObjectName]
				   ,[DatabaseName]
				   ,[FileName]
				   ,[OwnerName]
				   ,[RoleName]
				   ,[TargetUserName]
				   ,[DBUserName]
				   ,[LoginSid]
				   ,[TargetLoginName]
				   ,[TargetLoginSid]
				   ,[ColumnPermissions]
				   ,[LinkedServerName]
				   ,[ProviderName]
				   ,[MethodName]
				   ,[RowCounts]
				   ,[RequestID]
				   ,[XactSequence]
				   ,[EventSequence]
				   ,[BigintData1]
				   ,[BigintData2]
				   ,[GUID]
				   ,[IntegerData2]
				   ,[ObjectID2]
				   ,[Type]
				   ,[OwnerID]
				   ,[ParentName]
				   ,[IsSystem]
				   ,[Offset]
				   ,[SourceDatabaseID]
				   ,[SqlHandle]
				   ,[SessionLoginName]
				   ,[PlanHandle]
				   ,[GroupID])
		SELECT [TextData]
			  ,[BinaryData]
			  ,[DatabaseID]
			  ,[TransactionID]
			  ,[LineNumber]
			  ,[NTUserName]
			  ,[NTDomainName]
			  ,[HostName]
			  ,[ClientProcessID]
			  ,[ApplicationName]
			  ,[LoginName]
			  ,[SPID]
			  ,[Duration]
			  ,[StartTime]
			  ,[EndTime]
			  ,[Reads]
			  ,[Writes]
			  ,[CPU]
			  ,[Permissions]
			  ,[Severity]
			  ,[EventSubClass]
			  ,[ObjectID]
			  ,[Success]
			  ,[IndexID]
			  ,[IntegerData]
			  ,[ServerName]
			  ,[EventClass]
			  ,[ObjectType]
			  ,[NestLevel]
			  ,[State]
			  ,[Error]
			  ,[Mode]
			  ,[Handle]
			  ,AATD.[ObjectName]
			  ,AATD.[DatabaseName]
			  ,[FileName]
			  ,[OwnerName]
			  ,[RoleName]
			  ,[TargetUserName]
			  ,[DBUserName]
			  ,[LoginSid]
			  ,[TargetLoginName]
			  ,[TargetLoginSid]
			  ,[ColumnPermissions]
			  ,[LinkedServerName]
			  ,[ProviderName]
			  ,[MethodName]
			  ,[RowCounts]
			  ,[RequestID]
			  ,[XactSequence]
			  ,[EventSequence]
			  ,[BigintData1]
			  ,[BigintData2]
			  ,[GUID]
			  ,[IntegerData2]
			  ,[ObjectID2]
			  ,[Type]
			  ,[OwnerID]
			  ,AATD.[ParentName]
			  ,[IsSystem]
			  ,[Offset]
			  ,[SourceDatabaseID]
			  ,[SqlHandle]
			  ,[SessionLoginName]
			  ,[PlanHandle]
			  ,[GroupID]
		FROM #AccessAuditTraceData_load AATD
		WHERE TextData IS NOT NULL;
	END

	DROP TABLE #AccessAuditTraceData_load;

	FETCH NEXT FROM trace_file_cursor INTO @TRACE_FILE_NAME;
END


CLOSE trace_file_cursor;
DEALLOCATE trace_file_cursor;

EndOfStoredProcedure:


GO
