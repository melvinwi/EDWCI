USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[FactMarketTransaction](
	[AccountId] [int] NULL,
	[ServiceId] [int] NULL,
	[ChangeReasonId] [int] NULL,
	[TransactionDateId] [int] NULL,
	[TransactionType] [nvarchar](100) NULL,
	[TransactionStatus] [nvarchar](100) NULL,
	[TransactionKey] [int] NULL,
	[ParticipantCode] [nvarchar](20) NULL,
	[NEMTransactionKey] [nvarchar](100) NULL,
	[NEMInitialTransactionKey] [nvarchar](100) NULL,
	[TransactionCounter] [tinyint] NULL,
	[TransactionTime] [time](7) NULL
) ON [data]

GO
ALTER TABLE [temp].[FactMarketTransaction] ADD  DEFAULT (NULL) FOR [AccountId]
GO
ALTER TABLE [temp].[FactMarketTransaction] ADD  DEFAULT (NULL) FOR [ServiceId]
GO
ALTER TABLE [temp].[FactMarketTransaction] ADD  DEFAULT (NULL) FOR [ChangeReasonId]
GO
ALTER TABLE [temp].[FactMarketTransaction] ADD  DEFAULT (NULL) FOR [TransactionDateId]
GO
ALTER TABLE [temp].[FactMarketTransaction] ADD  DEFAULT (NULL) FOR [TransactionType]
GO
ALTER TABLE [temp].[FactMarketTransaction] ADD  DEFAULT (NULL) FOR [TransactionStatus]
GO
ALTER TABLE [temp].[FactMarketTransaction] ADD  DEFAULT (NULL) FOR [TransactionKey]
GO
ALTER TABLE [temp].[FactMarketTransaction] ADD  DEFAULT (NULL) FOR [ParticipantCode]
GO
ALTER TABLE [temp].[FactMarketTransaction] ADD  DEFAULT (NULL) FOR [NEMTransactionKey]
GO
ALTER TABLE [temp].[FactMarketTransaction] ADD  DEFAULT (NULL) FOR [NEMInitialTransactionKey]
GO
ALTER TABLE [temp].[FactMarketTransaction] ADD  DEFAULT (NULL) FOR [TransactionCounter]
GO
USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[FactMarketTransaction](
	[AccountId] [int] NULL DEFAULT (NULL),
	[ServiceId] [int] NULL DEFAULT (NULL),
	[ChangeReasonId] [int] NULL DEFAULT (NULL),
	[TransactionDateId] [int] NULL DEFAULT (NULL),
	[TransactionType] [nvarchar](100) NULL DEFAULT (NULL),
	[TransactionStatus] [nvarchar](100) NULL DEFAULT (NULL),
	[TransactionKey] [int] NULL DEFAULT (NULL),
	[ParticipantCode] [nvarchar](20) NULL DEFAULT (NULL),
	[NEMTransactionKey] [nvarchar](100) NULL DEFAULT (NULL),
	[NEMInitialTransactionKey] [nvarchar](100) NULL DEFAULT (NULL),
	[TransactionCounter] [tinyint] NULL DEFAULT (NULL),
	[TransactionTime] [time](7) NULL,
	[MoveIn] [nchar](3) NULL
) ON [DATA]

GO
