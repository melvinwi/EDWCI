USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_MaintainJobHistory] 
AS


-- Lumo Energy| Database Administration
-- SQL Server Agent Job History Catalog Maintenance
--
-- 2010-07-19 Darren.Pilkington Initial Release
-- 2012-07-13 Darren.Pilkington Enable use on SQL Server 2012
--
-- This procedure will maintain the size of the SQL Server Agent Job history tables 
-- by deleting the entries for jobs older than the specified retention range.
-- We make use of the supplied msdb.dbo.sp_purge_jobhistory

SET NOCOUNT ON
DECLARE @CutoffDate DATETIME;
DECLARE @RetentionJobHistory VARCHAR(250);

SET @RetentionJobHistory = CAST((SELECT parameter_value FROM dba_admin.dbo.SystemParameters WHERE parameter_name = 'RETENTION_JOB_HISTORY')AS INT);
SET @Cutoffdate = DATEADD(dd,DATEDIFF(dd,0,GETDATE())-@RetentionJobHistory,0);

PRINT 'Purge job history before Cutoff Date = ' + CONVERT(VARCHAR(10),@CutoffDate ,121);

EXEC msdb.dbo.sp_purge_jobhistory @oldest_date = @CutoffDate;
GO
