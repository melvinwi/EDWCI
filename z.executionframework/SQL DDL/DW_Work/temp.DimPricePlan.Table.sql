USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimPricePlan](
	[PricePlanKey] [int] NULL,
	[PricePlanCode] [nvarchar](20) NULL,
	[PricePlanName] [nvarchar](100) NULL,
	[PricePlanDiscountPercentage] [decimal](5, 4) NULL,
	[PricePlanValueRatio] [decimal](3, 2) NULL
) ON [data]

GO
ALTER TABLE [temp].[DimPricePlan] ADD  DEFAULT (NULL) FOR [PricePlanKey]
GO
ALTER TABLE [temp].[DimPricePlan] ADD  DEFAULT (NULL) FOR [PricePlanCode]
GO
ALTER TABLE [temp].[DimPricePlan] ADD  DEFAULT (NULL) FOR [PricePlanValueRatio]
GO
