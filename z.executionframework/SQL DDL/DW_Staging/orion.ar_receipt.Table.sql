USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[ar_receipt](
	[seq_rcpt_id] [numeric](18, 0) NOT NULL,
	[seq_rcpt_batch_id] [numeric](18, 0) NULL,
	[account_name] [varchar](100) NULL,
	[bank_branch] [varchar](100) NULL,
	[seq_bank_id] [numeric](18, 0) NULL,
	[seq_party_id] [numeric](18, 0) NULL,
	[statement_id] [numeric](18, 0) NULL,
	[rcpt_date] [datetime] NULL,
	[rcpt_amount] [numeric](17, 2) NULL,
	[allocated] [varchar](1) NULL,
	[posted_date] [datetime] NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[reference] [varchar](200) NULL,
	[seq_accounting_period_id] [numeric](18, 0) NULL,
	[credit_card_no] [varchar](8000) NULL,
	[credit_card_expiry] [varchar](5) NULL,
	[allocated_amount] [money] NULL,
	[credit_card_type_code] [varchar](20) NULL,
	[credit_card_verif_no] [varchar](4) NULL,
	[credit_card_name] [varchar](100) NULL,
	[pension_no] [varchar](20) NULL,
	[GL_posted_date] [datetime] NULL,
	[GL_accounting_period] [numeric](18, 0) NULL,
	[export_seq] [int] NULL,
	[ocr_payment_det_id] [numeric](18, 0) NULL,
	[location_code] [varchar](20) NULL,
	[authentication_no] [varchar](100) NULL,
	[encrypt_credit_card_no] [varbinary](2000) NULL,
	[cc_result_code] [varchar](20) NULL,
	[cc_result_msg] [varchar](500) NULL,
	[cc_trans_id] [varchar](100) NULL,
	[credit_card_post_code] [varchar](10) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_AR_RECEIPT] PRIMARY KEY CLUSTERED 
(
	[seq_rcpt_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_ar_receipt_Meta_LatestUpdateId] ON [orion].[ar_receipt]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
