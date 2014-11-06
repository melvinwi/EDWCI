USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [csv].[csv_FactMarketingCampaignActivity](
	[MarketingCampaignKey] [int] NULL,
	[MarketingOfferKey] [int] NULL,
	[CustomerCode] [nvarchar](8) NULL,
	[ActivityDateId] [nvarchar](10) NULL,
	[ActivityTime] [nvarchar](8) NULL,
	[ActivityType] [nvarchar](40) NULL,
	[MarketingCampaignActivityKey] [nvarchar](255) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data]

GO
