USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[JobHistory](
	[instance_id] [int] NOT NULL,
	[job_id] [uniqueidentifier] NOT NULL,
	[name] [sysname] NOT NULL,
	[run_datetime] [datetime] NOT NULL,
	[run_duration] [varchar](8) NOT NULL,
	[run_status] [varchar](10) NULL,
 CONSTRAINT [PK_job_history] PRIMARY KEY CLUSTERED 
(
	[instance_id] ASC,
	[job_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
