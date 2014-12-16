USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[FactSalesActivity](
	[AccountId] [int] NULL,
	[ServiceId] [int] NULL,
	[ProductId] [int] NULL,
	[PricePlanId] [int] NULL,
	[RepresentativeId] [int] NULL,
	[OrganisationId] [int] NULL,
	[SalesActivityType] [nvarchar](100) NULL,
	[SalesActivityDateId] [int] NULL,
	[SalesActivityTime] [time](7) NULL,
	[SalesActivityKey] [nvarchar](100) NULL
) ON [data]

GO
