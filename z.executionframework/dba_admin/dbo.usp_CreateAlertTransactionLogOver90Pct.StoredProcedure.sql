USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_CreateAlertTransactionLogOver90Pct]
AS
DECLARE @instancename SYSNAME;
DECLARE @database_name SYSNAME;  
DECLARE @alert_name_v SYSNAME; 
DECLARE @performance_condition_v NVARCHAR(512); 
DECLARE @notification_message_v NVARCHAR(512);

SET @instancename = SUBSTRING(@@SERVERNAME,CHARINDEX('\',@@SERVERNAME, 1)+1,100);

DECLARE database_name_cursor CURSOR FOR  
	SELECT	name 
	FROM	sys.databases
	WHERE	source_database_id IS NULL
	AND		name <> 'model';

OPEN database_name_cursor   
FETCH NEXT FROM database_name_cursor INTO @database_name   

WHILE @@FETCH_STATUS = 0   
BEGIN  
	SET @alert_name_v='Transaction Log over 90 Percent '+@database_name;
	SET @performance_condition_v='MSSQL$'+  @instancename +':Databases|Percent Log Used|'+@database_name+'|>|90';
	SET @notification_message_v=@@SERVERNAME+' : database '+ @database_name+' : Transaction Log over 90% used.';

	IF (select COUNT(*) from  msdb.dbo.sysalerts WHERE name = @alert_name_v) = 0
	BEGIN
		EXEC msdb.dbo.sp_add_alert 
			@name = @alert_name_v, 
			@message_id = 0, 
			@severity = 0, 
			@enabled = 1, 
			@delay_between_responses = 600, 
			@include_event_description_in = 1, 
			@notification_message = @notification_message_v, 
			@category_name=N'[Uncategorized]', 
			@performance_condition = @performance_condition_v, 
			@job_id=N'00000000-0000-0000-0000-000000000000'

		EXEC msdb.dbo.sp_add_notification 
			@alert_name=@alert_name_v,
			@operator_name=N'Database Administration', 
			@notification_method = 1;
		
		PRINT 'Alert for Database: '+@database_name+' has been created.'
	END		
	ELSE
	BEGIN
		PRINT 'Alert for Database: '+@database_name+' already exists.';
	END
	
FETCH NEXT FROM database_name_cursor INTO @database_name  
END   

CLOSE database_name_cursor   
DEALLOCATE database_name_cursor




GO
