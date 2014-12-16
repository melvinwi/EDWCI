USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[FactSalesActivity](
	[AccountId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[PricePlanId] [int] NOT NULL,
	[RepresentativeId] [int] NOT NULL,
	[OrganisationId] [int] NOT NULL,
	[SalesActivityType] [nvarchar](100) NOT NULL,
	[SalesActivityDateId] [int] NOT NULL,
	[SalesActivityTime] [time](7) NOT NULL,
	[SalesActivityKey] [nvarchar](100) NOT NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data]

GO
CREATE CLUSTERED COLUMNSTORE INDEX [ClusteredColumnStoreIndex-FactSalesActivity] ON [DW].[FactSalesActivity] WITH (DROP_EXISTING = OFF) ON [data]
GO
