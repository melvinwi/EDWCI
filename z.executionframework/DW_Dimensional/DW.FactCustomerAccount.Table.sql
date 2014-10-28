USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[FactCustomerAccount](
	[CustomerId] [int] NOT NULL,
	[AccountId] [int] NOT NULL,
	[AccountRelationshipCounter] [tinyint] NOT NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NOT NULL
) ON [data]

GO
CREATE CLUSTERED COLUMNSTORE INDEX [ClusteredColumnStoreIndex-FactCustomerAccount] ON [DW].[FactCustomerAccount] WITH (DROP_EXISTING = OFF) ON [data]
GO
