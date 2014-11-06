USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimMarketingCampaign](
	[MarketingCampaignKey] [int] NULL,
	[MarketingCampaignShortDesc] [nvarchar](20) NULL,
	[MarketingCampaignDesc] [nvarchar](4000) NULL,
	[MarketingCampaignStartDate] [date] NULL,
	[MarketingCampaignEndDate] [date] NULL,
	[ContactType] [nvarchar](50) NULL,
	[PrivacyAssessmentKey] [nvarchar](50) NULL
) ON [data]

GO
