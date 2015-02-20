USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [csv].[DimMarketingCampaign](
	[MarketingCampaignKey] [int] NOT NULL,
	[MarketingCampaignShortDesc] [nvarchar](20) NULL,
	[MarketingCampaignDesc] [nvarchar](4000) NULL,
	[MarketingCampaignStartDate] [nvarchar](10) NULL,
	[MarketingCampaignEndDate] [nvarchar](10) NULL,
	[ContactType] [nvarchar](50) NULL,
	[PrivacyAssessmentKey] [nvarchar](50) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_csv_DimMarketingCampaign] PRIMARY KEY CLUSTERED 
(
	[MarketingCampaignKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
CREATE NONCLUSTERED INDEX [IX_csv_DimMarketingCampaign_Meta_LatestUpdateId] ON [csv].[DimMarketingCampaign]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
