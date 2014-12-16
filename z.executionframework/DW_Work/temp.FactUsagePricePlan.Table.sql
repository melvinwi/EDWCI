USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[FactUsagePricePlan](
	[AccountId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[PricePlanId] [int] NOT NULL,
	[MeterRegisterId] [int] NOT NULL,
	[ContractFRMPDateId] [int] NOT NULL,
	[ContractTerminatedDateId] [int] NOT NULL,
	[ContractStatus] [nchar](10) NOT NULL,
	[UsagePricePlanStartDateId] [int] NOT NULL,
	[UsagePricePlanEndDateId] [int] NOT NULL,
	[UsagePricePlanKey] [nvarchar](20) NOT NULL
) ON [data]

GO
