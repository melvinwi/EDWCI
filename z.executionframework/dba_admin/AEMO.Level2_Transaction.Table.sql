USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AEMO].[Level2_Transaction](
	[transactionID] [nvarchar](36) NOT NULL,
	[transactionDate] [datetime2](0) NULL,
	[initiatingTransactionID] [nvarchar](36) NULL,
	[ReportName] [nvarchar](80) NULL,
	[SettlementCase] [int] NULL,
	[FromDate] [date] NULL,
	[ToDate] [date] NULL,
	[LastSequenceNumber] [int] NULL,
	[TransmissionNodeIdentifier] [nvarchar](4) NULL,
	[LR] [nvarchar](10) NULL,
	[MDP] [nvarchar](10) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY]

GO
