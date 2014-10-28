USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [csv_temp].[csv_DimMarketingOffer](
	[MarketingOfferKey] [int] NULL,
	[MarketingOfferShortDesc] [nvarchar](20) NULL,
	[MarketingOfferDesc] [nvarchar](4000) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data]

GO
