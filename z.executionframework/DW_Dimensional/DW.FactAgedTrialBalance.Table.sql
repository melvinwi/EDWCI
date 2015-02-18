USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[FactAgedTrialBalance](
	[AccountId] [int] NULL DEFAULT (NULL),
	[ATBDateId] [int] NULL DEFAULT (NULL),
	[CurrentPeriod] [money] NULL DEFAULT (NULL),
	[Days1To30] [money] NULL DEFAULT (NULL),
	[Days31To60] [money] NULL DEFAULT (NULL),
	[Days61To90] [money] NULL DEFAULT (NULL),
	[Days90Plus] [money] NULL DEFAULT (NULL),
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
CREATE CLUSTERED COLUMNSTORE INDEX [ClusteredColumnStoreIndex-FactAgedTrialBalance] ON [DW].[FactAgedTrialBalance] WITH (DROP_EXISTING = OFF) ON [DATA]
GO
