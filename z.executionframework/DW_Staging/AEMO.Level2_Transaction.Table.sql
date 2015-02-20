USE [DW_Staging]
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
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_Level2_Transaction] PRIMARY KEY CLUSTERED 
(
	[transactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
USE [DW_Staging]
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
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_Level2_Transaction] PRIMARY KEY CLUSTERED 
(
	[transactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
CREATE NONCLUSTERED INDEX [IX_AEMO_Level2_Transaction_Meta_LatestUpdateId] ON [AEMO].[Level2_Transaction]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
