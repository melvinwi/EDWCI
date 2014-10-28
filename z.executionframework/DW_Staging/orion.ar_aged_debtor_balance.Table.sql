USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[ar_aged_debtor_balance](
	[seq_party_id] [numeric](18, 0) NOT NULL,
	[current_period] [numeric](17, 2) NULL,
	[days_30] [numeric](17, 2) NULL,
	[days_60] [numeric](17, 2) NULL,
	[days_90] [numeric](17, 2) NULL,
	[days_90_plus] [numeric](17, 2) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[debtor_anl_1] [money] NULL,
	[debtor_anl_2] [money] NULL,
	[debtor_anl_3] [money] NULL,
	[debtor_anl_4] [money] NULL,
	[debtor_anl_5] [money] NULL,
	[debtor_anl_6] [money] NULL,
	[debtor_anl_7] [money] NULL,
	[debtor_anl_8] [money] NULL,
	[debtor_anl_9] [money] NULL,
	[debtor_anl_10] [money] NULL,
	[cm_overdue] [money] NULL,
	[cm_current] [money] NULL,
	[bad_debt_provision] [numeric](18, 2) NULL,
	[bad_debt_group_id] [numeric](18, 0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_AR_AGED_DEBTOR_BALANCE] PRIMARY KEY CLUSTERED 
(
	[seq_party_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
