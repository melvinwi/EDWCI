USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[FactMarketTransaction](
	[AccountId] [int] NULL DEFAULT (NULL),
	[ServiceId] [int] NULL DEFAULT (NULL),
	[ChangeReasonId] [int] NULL DEFAULT (NULL),
	[TransactionDateId] [int] NULL DEFAULT (NULL),
	[TransactionType] [nvarchar](100) NULL DEFAULT (NULL),
	[TransactionStatus] [nvarchar](100) NULL DEFAULT (NULL),
	[TransactionKey] [int] NULL DEFAULT (NULL),
	[ParticipantCode] [nvarchar](20) NULL DEFAULT (NULL),
	[NEMTransactionKey] [nvarchar](100) NULL,
	[NEMInitialTransactionKey] [nvarchar](100) NULL,
	[TransactionCounter] [tinyint] NULL DEFAULT (NULL),
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NOT NULL,
	[TransactionTime] [time](7) NULL
) ON [data]

GO
CREATE CLUSTERED COLUMNSTORE INDEX [ClusteredColumnStoreIndex-FactMarketTransaction] ON [DW].[FactMarketTransaction] WITH (DROP_EXISTING = OFF) ON [data]
GO
