USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [csv_temp].[DimMarketingOffer](
	[MarketingOfferKey] [int] NOT NULL,
	[MarketingOfferShortDesc] [nvarchar](20) NULL,
	[MarketingOfferDesc] [nvarchar](4000) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
