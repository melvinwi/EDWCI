USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[usp_StatisticsUpdate] 
as

-- Lumo Energy | Database Administration
-- usp_stats_update_instance_DBs
--
-- 2014-04-17 Darren Pilkington Initial release
--

/*
cycle through online databases,
checking the tables stats_update_ignore and stats_update_parameters
and calling dbo.usp_statistics_update_single_db to perform work

purge old history
*/

SET NOCOUNT ON

DECLARE @db_name NVARCHAR(128);
DECLARE @retention_days SMALLINT;
DECLARE @sqlcmd NVARCHAR(1024);
DECLARE @current_log_record INT;

-- Create cursor to scroll through online DBs not explictly set to be ignored
DECLARE cr_stats_dbs CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR
    SELECT name 
    FROM sys.databases
    WHERE state_desc = 'ONLINE'
	AND is_read_only <> 1
	AND name NOT IN (SELECT database_name FROM dba_admin.dbo.DatabaseStatisticsIgnore WHERE ignore_statistics = 'Y')
    ORDER BY name;

OPEN cr_stats_dbs
FETCH NEXT FROM cr_stats_DBs INTO @db_name

-- scroll through DBs
WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO [dba_admin].[dbo].[DatabaseStatisticsLog] (database_name,start_time)
	VALUES (@db_name, GETDATE());
	
	SET @current_log_record = CAST(@@IDENTITY AS INT);

	SET @sqlcmd = 'EXEC '+@db_name+'..sp_updatestats';
	EXEC (@sqlcmd);

	UPDATE [dba_admin].[dbo].[DatabaseStatisticsLog]
	SET end_time = GETDATE()
	WHERE log_record_no = @current_log_record;

	FETCH NEXT FROM cr_stats_dbs INTO @db_name
END

CLOSE cr_stats_dbs
DEALLOCATE cr_stats_dbs


-- PURGE DefragLog HISTORY

--DECLARE @defrag_LOG_HISTORY_RETENTION AS INTEGER;
--DECLARE @KEEPDATE DATETIME;


/****	purge old records from dbo.stats_update_log	***/

----	set @retention_days to configured value, or if none then set to 30
--select @retention_days = 
--convert(smallint, (select coalesce((select parameter_value from dbo.SystemParameters where parameter_name = 'RETENTION_DAYS_stats_update'),30)))

--delete from dba_admin.dbo.stats_update_log
--where startTime < dateadd(dd, -@retention_days , getdate())




GO
