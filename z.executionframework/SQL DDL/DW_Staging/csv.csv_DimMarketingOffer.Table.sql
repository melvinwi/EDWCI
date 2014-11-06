USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [csv].[csv_DimMarketingOffer](
	[MarketingOfferKey] [int] NOT NULL,
	[MarketingOfferShortDesc] [nvarchar](20) NULL,
	[MarketingOfferDesc] [nvarchar](4000) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_csv_DimMarketingOffer] PRIMARY KEY CLUSTERED 
(
	[MarketingOfferKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
