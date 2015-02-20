USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [csv].[FactMarketingCampaignActivity](
	[MarketingCampaignKey] [int] NULL,
	[MarketingOfferKey] [int] NULL,
	[CustomerCode] [nvarchar](8) NULL,
	[ActivityDateId] [nvarchar](10) NULL,
	[ActivityTime] [nvarchar](8) NULL,
	[ActivityType] [nvarchar](40) NULL,
	[MarketingCampaignActivityKey] [nvarchar](255) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
CREATE NONCLUSTERED INDEX [IX_csv_FactMarketingCampaignActivity_Meta_LatestUpdateId] ON [csv].[FactMarketingCampaignActivity]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
