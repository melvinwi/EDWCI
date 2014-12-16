USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[FactPricePlanRate](
	[PricePlanId] [int] NOT NULL,
	[UnitTypeId] [int] NOT NULL,
	[PricePlanRateKey] [nvarchar](30) NOT NULL,
	[RateStartDateId] [int] NOT NULL,
	[RateEndDateId] [int] NOT NULL,
	[StepStart] [decimal](18, 7) NOT NULL,
	[StepEnd] [decimal](18, 7) NOT NULL,
	[Rate] [money] NOT NULL,
	[MinimumCharge] [money] NOT NULL,
	[RateType] [nvarchar](100) NOT NULL,
	[InvoiceDescription] [nvarchar](100) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NOT NULL
) ON [data]

GO
CREATE CLUSTERED COLUMNSTORE INDEX [ClusteredColumnStoreIndex-FactPricePlanRate] ON [DW].[FactPricePlanRate] WITH (DROP_EXISTING = OFF) ON [data]
GO
