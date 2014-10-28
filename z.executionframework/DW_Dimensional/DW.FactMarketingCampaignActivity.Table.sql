USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[FactMarketingCampaignActivity](
	[MarketingCampaignId] [int] NULL,
	[ActivityTypeId] [int] NULL,
	[MarketingCampaignActivityKey] [nvarchar](255) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data]

GO
