USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[FactBasicMeterRead](
	[AccountId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[MeterRegisterId] [int] NOT NULL,
	[BasicMeterReadKey] [int] NOT NULL,
	[ReadType] [nvarchar](100) NULL,
	[ReadSubtype] [nvarchar](100) NULL,
	[ReadValue] [decimal](18, 4) NULL,
	[ReadDateId] [int] NULL,
	[EstimatedRead] [nchar](3) NULL,
	[ReadPeriod] [int] NULL,
	[QualityMethod] [nvarchar](20) NULL,
	[AddFactor] [int] NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NOT NULL
) ON [DATA]

GO
CREATE CLUSTERED COLUMNSTORE INDEX [ClusteredColumnStoreIndex-FactBasicMeterRead] ON [DW].[FactBasicMeterRead] WITH (DROP_EXISTING = OFF) ON [DATA]
GO
