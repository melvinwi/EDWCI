USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[JobMonitor](
	[job_id] [uniqueidentifier] NOT NULL,
	[name] [sysname] NOT NULL,
	[status] [char](1) NOT NULL CONSTRAINT [DF_job_status]  DEFAULT (' '),
	[execution_threshold] [int] NULL,
	[notify_appteam] [varchar](200) NULL,
	[alert_freq] [int] NULL,
	[max_number_of_alerts] [int] NULL,
	[alert_count] [int] NULL,
	[last_alert] [datetime] NULL,
	[modified_date] [datetime] NOT NULL CONSTRAINT [DF_job_status_modified_date]  DEFAULT (getdate()),
	[modified_by] [varchar](50) NOT NULL CONSTRAINT [DF_job_status_modified_by]  DEFAULT (suser_sname()),
 CONSTRAINT [PK_job_monitor] PRIMARY KEY CLUSTERED 
(
	[job_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
