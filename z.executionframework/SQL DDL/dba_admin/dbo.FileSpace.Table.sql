USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FileSpace](
	[database_name] [sysname] NOT NULL,
	[physical_name] [nvarchar](260) NOT NULL,
	[logical_name] [sysname] NOT NULL,
	[type_desc] [nvarchar](60) NOT NULL,
	[filegroup] [sysname] NULL,
	[size_kb] [bigint] NOT NULL,
	[used_kb] [bigint] NULL,
	[snapshot_size_kb] [bigint] NULL,
	[collection_time] [datetime] NOT NULL CONSTRAINT [DF_FileSpace_collection_time]  DEFAULT (getdate())
) ON [PRIMARY]

GO
