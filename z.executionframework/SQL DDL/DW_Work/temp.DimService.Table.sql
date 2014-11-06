USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimService](
	[ServiceKey] [int] NULL,
	[MarketIdentifier] [nvarchar](30) NULL,
	[ServiceType] [nvarchar](11) NULL,
	[LossFactor] [decimal](6, 4) NULL,
	[EstimatedDailyConsumption] [decimal](18, 6) NULL,
	[MeteringType] [nchar](6) NULL,
	[ResidentialSuburb] [nvarchar](100) NULL,
	[ResidentialPostcode] [nchar](4) NULL,
	[ResidentialState] [nchar](3) NULL,
	[NextScheduledReadDate] [date] NULL,
	[FRMPDate] [date] NULL
) ON [data]

GO
