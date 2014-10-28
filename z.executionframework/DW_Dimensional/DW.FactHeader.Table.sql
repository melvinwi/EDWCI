USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[FactHeader](
	[AccountId] [int] NULL,
	[IssueDateId] [int] NULL,
	[DueDateId] [int] NULL,
	[HeaderType] [nchar](7) NULL,
	[PaidOnTime] [nchar](3) NULL,
	[HeaderKey] [nvarchar](20) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data]

GO
CREATE CLUSTERED COLUMNSTORE INDEX [ClusteredColumnStoreIndex-FactHeader] ON [DW].[FactHeader] WITH (DROP_EXISTING = OFF) ON [data]
GO
