USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[ar_adjust](
	[seq_ar_adjust_id] [numeric](18, 0) NULL,
	[seq_party_id] [numeric](18, 0) NULL,
	[seq_adj_reason_id] [numeric](18, 0) NULL,
	[adj_date] [datetime] NULL,
	[statement_id] [numeric](18, 0) NULL,
	[adj_amount] [numeric](17, 2) NULL,
	[posted_date] [datetime] NULL,
	[allocated] [varchar](1) NULL,
	[notes] [varchar](max) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_accounting_period_id] [numeric](18, 0) NULL,
	[allocated_amount] [money] NULL,
	[seq_bus_unit_id] [numeric](18, 0) NULL,
	[seq_ar_invoice_id] [numeric](18, 0) NULL,
	[seq_rcpt_id] [numeric](18, 0) NULL,
	[GL_posted_date] [datetime] NULL,
	[GL_accounting_period] [numeric](18, 0) NULL,
	[export_seq] [int] NULL,
	[invoice_message] [varchar](100) NULL,
	[tax_dtl_amount_1] [money] NULL,
	[tax_dtl_amount_2] [money] NULL,
	[tax_dtl_amount_3] [money] NULL,
	[tax_dtl_amount_4] [money] NULL,
	[tax_dtl_amount_5] [money] NULL,
	[tax_dtl_amount_6] [money] NULL,
	[write_off_export_id] [numeric](18, 0) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
