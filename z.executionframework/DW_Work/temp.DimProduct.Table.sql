USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimProduct](
	[ProductKey] [nvarchar](30) NOT NULL,
	[ProductName] [nvarchar](100) NOT NULL,
	[ProductDesc] [nvarchar](100) NOT NULL,
	[ProductType] [nchar](6) NOT NULL,
	[FixedTariffAdjustPercentage] [decimal](5, 4) NOT NULL,
	[VariableTariffAdjustPercentage] [decimal](5, 4) NOT NULL
) ON [data]

GO
