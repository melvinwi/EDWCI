USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[ar_adjust_reason](
	[seq_adj_reason_id] [numeric](18, 0) NULL,
	[seq_account_id] [numeric](18, 0) NULL,
	[seq_adj_class_id] [numeric](18, 0) NULL,
	[cust_tran_multiplier] [int] NULL,
	[adj_code] [varchar](10) NULL,
	[adj_desc] [varchar](100) NULL,
	[adj_statement_desc] [varchar](100) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[gst_inclusive] [varchar](1) NULL,
	[user_select] [varchar](1) NULL,
	[rev_seq_adj_reason_id] [numeric](18, 0) NULL,
	[invoice_adj_only] [varchar](1) NULL,
	[wo_seq_adj_reason_id] [numeric](18, 0) NULL,
	[alloc_from_rcpt_only] [varchar](1) NULL,
	[auto_approval_threshold] [numeric](18, 2) NULL,
	[inv_split] [varchar](1) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[ar_adjust_reason](
	[seq_adj_reason_id] [numeric](18, 0) NOT NULL,
	[seq_account_id] [numeric](18, 0) NULL,
	[seq_adj_class_id] [numeric](18, 0) NULL,
	[cust_tran_multiplier] [int] NULL,
	[adj_code] [varchar](10) NULL,
	[adj_desc] [varchar](100) NULL,
	[adj_statement_desc] [varchar](100) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[gst_inclusive] [varchar](1) NULL,
	[user_select] [varchar](1) NULL,
	[rev_seq_adj_reason_id] [numeric](18, 0) NULL,
	[invoice_adj_only] [varchar](1) NULL,
	[wo_seq_adj_reason_id] [numeric](18, 0) NULL,
	[alloc_from_rcpt_only] [varchar](1) NULL,
	[auto_approval_threshold] [numeric](18, 2) NULL,
	[inv_split] [varchar](1) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
