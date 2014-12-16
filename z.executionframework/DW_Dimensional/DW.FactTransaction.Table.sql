USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[FactTransaction](
	[AccountId] [int] NULL,
	[ServiceId] [int] NULL,
	[ProductId] [int] NULL,
	[FinancialAccountId] [int] NULL,
	[TransactionDateId] [int] NULL,
	[VersionId] [int] NULL,
	[UnitTypeId] [int] NULL,
	[Units] [decimal](18, 4) NULL,
	[Value] [money] NULL,
	[Currency] [nchar](3) NULL,
	[Tax] [money] NULL,
	[TransactionType] [nvarchar](100) NULL,
	[TransactionDesc] [nvarchar](100) NULL,
	[TransactionKey] [nvarchar](20) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
	[MeterRegisterId] [int] NULL,
	[TransactionSubtype] [nvarchar](30) NULL,
	[Reversal] [nchar](3) NULL,
	[Reversed] [nchar](3) NULL,
	[StartRead] [decimal](18, 4) NULL,
	[EndRead] [decimal](18, 4) NULL,
	[StartDateId] [int] NULL,
	[EndDateId] [int] NULL
) ON [data]

GO
CREATE CLUSTERED COLUMNSTORE INDEX [ClusteredColumnStoreIndex-FactTransaction] ON [DW].[FactTransaction] WITH (DROP_EXISTING = OFF) ON [data]
GO
