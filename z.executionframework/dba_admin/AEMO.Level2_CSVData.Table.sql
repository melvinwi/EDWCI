USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AEMO].[Level2_CSVData](
	[MessageID] [nvarchar](36) NULL,
	[transactionID] [nvarchar](36) NULL,
	[SettlementCase] [int] NOT NULL,
	[TNI] [nvarchar](4) NULL,
	[LR] [nvarchar](10) NULL,
	[MDP] [nvarchar](10) NULL,
	[SettlementDate] [date] NOT NULL,
	[NMI] [nvarchar](11) NOT NULL,
	[DataType] [nchar](1) NULL,
	[MSATS_Est] [nchar](1) NULL,
	[Total_Energy] [numeric](10, 3) NULL,
	[SeqNo] [int] NOT NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY]

GO
