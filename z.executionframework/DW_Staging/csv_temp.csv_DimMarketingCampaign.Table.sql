USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [csv_temp].[csv_DimMarketingCampaign](
	[MarketingCampaignKey] [int] NULL,
	[MarketingCampaignShortDesc] [nvarchar](20) NULL,
	[MarketingCampaignDesc] [nvarchar](4000) NULL,
	[MarketingCampaignStartDate] [nvarchar](10) NULL,
	[MarketingCampaignEndDate] [nvarchar](10) NULL,
	[ContactType] [nvarchar](50) NULL,
	[PrivacyAssessmentKey] [nvarchar](50) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data]

GO
