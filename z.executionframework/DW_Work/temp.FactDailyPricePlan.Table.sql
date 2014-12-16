USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[FactDailyPricePlan](
	[AccountId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[PricePlanId] [int] NOT NULL,
	[ContractFRMPDateId] [int] NOT NULL,
	[ContractTerminatedDateId] [int] NOT NULL,
	[ContractStatus] [nchar](10) NOT NULL,
	[DailyPricePlanStartDateId] [int] NOT NULL,
	[DailyPricePlanEndDateId] [int] NOT NULL,
	[DailyPricePlanKey] [int] NOT NULL
) ON [data]

GO
