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
