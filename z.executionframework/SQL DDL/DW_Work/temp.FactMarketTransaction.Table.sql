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
	[TransactionCounter] [tinyint] NULL DEFAULT (NULL)
) ON [data]

GO
