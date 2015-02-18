USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[FactContract](
	[AccountId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[PricePlanId] [int] NOT NULL,
	[ContractDetailsId] [int] NOT NULL,
	[ContractConnectedDateId] [int] NULL,
	[ContractFRMPDateId] [int] NULL,
	[ContractStartDateId] [int] NOT NULL,
	[ContractEndDateId] [int] NOT NULL,
	[ContractTerminatedDateId] [int] NOT NULL,
	[ContractKey] [int] NOT NULL,
	[ContractCounter] [tinyint] NOT NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NOT NULL
) ON [DATA]

GO
CREATE CLUSTERED COLUMNSTORE INDEX [ClusteredColumnStoreIndex-FactContract] ON [DW].[FactContract] WITH (DROP_EXISTING = OFF) ON [DATA]
GO
