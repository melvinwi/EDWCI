USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MaintainMailHistory] 
AS

-- Lumo Energy | Database Administration
-- Maintains mail history and logs by purging data older than nominated days.
--
-- 2012-10-11 Darren.Pilkington Initial Release
--


SET NOCOUNT ON

DECLARE @MAIL_HISTORY_RETENTION AS INTEGER;
DECLARE @KEEPDATE DATETIME;

SET @MAIL_HISTORY_RETENTION = CAST((select parameter_value from dba_admin.dbo.systemparameters where parameter_name = 'RETENTION_MAIL_HISTORY')as INT);
SET @KEEPDATE = (SELECT DATEADD(mi,DATEDIFF(mi,0,GETDATE())-(@MAIL_HISTORY_RETENTION*(60*24)),0));

PRINT 'DELETING MAIL BEFORE: '+CAST(@KeepDate AS VARCHAR(50));

-- Delete Old Mail Messages
EXECUTE msdb.dbo.sysmail_delete_mailitems_sp @sent_before = @KeepDate;

-- Delete Old Log Entries
EXECUTE msdb.dbo.sysmail_delete_log_sp @logged_before = @KeepDate;
GO
