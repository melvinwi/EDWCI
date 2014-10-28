USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[FactAgedTrialBalance](
	[AccountId] [int] NULL DEFAULT (NULL),
	[ATBDateId] [int] NULL DEFAULT (NULL),
	[CurrentPeriod] [money] NULL DEFAULT (NULL),
	[Days1To30] [money] NULL DEFAULT (NULL),
	[Days31To60] [money] NULL DEFAULT (NULL),
	[Days61To90] [money] NULL DEFAULT (NULL),
	[Days90Plus] [money] NULL DEFAULT (NULL)
) ON [data]

GO
