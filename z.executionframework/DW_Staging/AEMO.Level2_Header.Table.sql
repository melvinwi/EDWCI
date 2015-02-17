USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AEMO].[Level2_Header](
	[MessageID] [nvarchar](36) NOT NULL,
	[From] [nvarchar](10) NULL,
	[To] [nvarchar](10) NULL,
	[MessageDate] [datetime2](0) NULL,
	[TransactionGroup] [nvarchar](10) NULL,
	[Priority] [nvarchar](10) NULL,
	[SecurityContext] [nvarchar](15) NULL,
	[Market] [nvarchar](10) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_Level2_Header] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AEMO].[Level2_Header](
	[MessageID] [nvarchar](36) NOT NULL,
	[From] [nvarchar](10) NULL,
	[To] [nvarchar](10) NULL,
	[MessageDate] [datetime2](0) NULL,
	[TransactionGroup] [nvarchar](10) NULL,
	[Priority] [nvarchar](10) NULL,
	[SecurityContext] [nvarchar](15) NULL,
	[Market] [nvarchar](10) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_Level2_Header] PRIMARY KEY CLUSTERED 
(
	[MessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
CREATE NONCLUSTERED INDEX [IX_AEMO_Level2_Header_Meta_LatestUpdateId] ON [AEMO].[Level2_Header]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
