USE [DW_Staging]
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
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_Level2_CSVData] PRIMARY KEY CLUSTERED 
(
	[SettlementCase] ASC,
	[SettlementDate] ASC,
	[NMI] ASC,
	[SeqNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
