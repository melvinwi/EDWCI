USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AEMO_temp].[Level2_Header](
	[MessageID] [nvarchar](36) NOT NULL,
	[From] [nvarchar](10) NULL,
	[To] [nvarchar](10) NULL,
	[MessageDate] [datetime2](0) NULL,
	[TransactionGroup] [nvarchar](10) NULL,
	[Priority] [nvarchar](10) NULL,
	[SecurityContext] [nvarchar](15) NULL,
	[Market] [nvarchar](10) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
	[Meta_InsertOrder] [int] IDENTITY(1,1) NOT NULL
) ON [data]

GO
