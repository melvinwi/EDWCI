USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DatabaseStatisticsLog](
	[log_record_no] [int] IDENTITY(1,1) NOT NULL,
	[database_name] [nvarchar](128) NOT NULL,
	[start_time] [datetime] NOT NULL,
	[end_time] [datetime] NULL
) ON [PRIMARY]

GO
