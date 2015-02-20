USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableStatisticsLog](
	[log_record_no] [int] IDENTITY(1,1) NOT NULL,
	[database_name] [nvarchar](128) NOT NULL,
	[schema_name] [nvarchar](50) NULL,
	[table_name] [nvarchar](128) NOT NULL,
	[index_name] [nvarchar](500) NULL,
	[start_time] [datetime] NULL,
	[end_time] [datetime] NULL,
	[timetaken_seconds] [numeric](10, 0) NULL,
	[fragpercent] [numeric](5, 2) NULL,
	[update_dt] [datetime] NULL CONSTRAINT [DF_TableStatisticsLog_update_dt]  DEFAULT (getdate())
) ON [PRIMARY]

GO
