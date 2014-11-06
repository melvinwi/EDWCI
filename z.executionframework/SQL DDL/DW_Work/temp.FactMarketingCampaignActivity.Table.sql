USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[FactMarketingCampaignActivity](
	[MarketingCampaignId] [int] NULL,
	[ActivityTypeId] [int] NULL,
	[MarketingCampaignActivityKey] [nvarchar](255) NULL
) ON [data]

GO
