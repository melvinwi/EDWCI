USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DatabaseCheckVLDBLog](
	[log_record_no] [int] IDENTITY(1,1) NOT NULL,
	[database_name] [sysname] NOT NULL,
	[object_name] [nvarchar](128) NOT NULL,
	[start_time] [datetime] NOT NULL,
	[end_time] [datetime] NULL,
	[result] [int] NULL
) ON [PRIMARY]

GO
