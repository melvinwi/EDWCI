USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimPricePlan](
	[PricePlanKey] [nvarchar](30) NULL,
	[PricePlanCode] [nvarchar](20) NULL,
	[PricePlanName] [nvarchar](100) NULL,
	[PricePlanDiscountPercentage] [decimal](5, 4) NULL,
	[PricePlanValueRatio] [decimal](3, 2) NULL,
	[PricePlanType] [nchar](5) NULL,
	[Bundled] [nvarchar](11) NULL,
	[ParentPricePlanCode] [nvarchar](20) NULL
) ON [data]

GO
USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimPricePlan](
	[PricePlanKey] [nvarchar](30) NULL,
	[PricePlanCode] [nvarchar](20) NULL,
	[PricePlanName] [nvarchar](100) NULL,
	[PricePlanDiscountPercentage] [decimal](5, 4) NULL,
	[PricePlanValueRatio] [decimal](3, 2) NULL,
	[PricePlanType] [nchar](5) NULL,
	[Bundled] [nvarchar](11) NULL,
	[ParentPricePlanCode] [nvarchar](20) NULL
) ON [DATA]

GO
