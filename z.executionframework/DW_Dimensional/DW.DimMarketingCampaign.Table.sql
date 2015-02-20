USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[DimMarketingCampaign](
	[MarketingCampaignId] [int] IDENTITY(1,1) NOT NULL,
	[MarketingCampaignKey] [int] NULL,
	[MarketingCampaignShortDesc] [nvarchar](20) NULL,
	[MarketingCampaignDesc] [nvarchar](4000) NULL,
	[MarketingCampaignStartDate] [date] NULL,
	[MarketingCampaignEndDate] [date] NULL,
	[ContactType] [nvarchar](50) NULL,
	[PrivacyAssessmentKey] [nvarchar](50) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_DW.DimMarketingCampaign] PRIMARY KEY CLUSTERED 
(
	[MarketingCampaignId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
