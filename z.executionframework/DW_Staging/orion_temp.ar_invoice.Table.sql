USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[ar_invoice](
	[seq_ar_invoice_id] [numeric](18, 0) NULL,
	[seq_party_id] [numeric](18, 0) NULL,
	[allocated] [varchar](1) NULL,
	[posted_date] [datetime] NULL,
	[opening_balance] [numeric](17, 2) NULL,
	[adjustment_amount] [numeric](17, 2) NULL,
	[receipt_amount] [numeric](17, 2) NULL,
	[new_charge_amount] [numeric](17, 2) NULL,
	[tax_amount] [numeric](17, 2) NULL,
	[closing_balance] [numeric](17, 2) NULL,
	[prompt_payment_discount] [numeric](17, 2) NULL,
	[paid_promptly] [varchar](1) NULL,
	[invoice_reference] [varchar](40) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[reversal] [varchar](1) NULL,
	[seq_accounting_period_id] [numeric](18, 0) NULL,
	[allocated_amount] [money] NULL,
	[invoice_due_date] [datetime] NULL,
	[fully_allocated_date] [datetime] NULL,
	[eligible_for_ppd] [varchar](1) NULL,
	[GL_posted_date] [datetime] NULL,
	[GL_accounting_period] [numeric](18, 0) NULL,
	[export_seq] [int] NULL,
	[batch_alloc_date] [datetime] NULL,
	[invoice_ppd_date] [datetime] NULL,
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
CREATE TABLE [orion_temp].[ar_invoice](
	[seq_ar_invoice_id] [numeric](18, 0) NOT NULL,
	[seq_party_id] [numeric](18, 0) NULL,
	[allocated] [varchar](1) NULL,
	[posted_date] [datetime] NULL,
	[opening_balance] [numeric](17, 2) NULL,
	[adjustment_amount] [numeric](17, 2) NULL,
	[receipt_amount] [numeric](17, 2) NULL,
	[new_charge_amount] [numeric](17, 2) NULL,
	[tax_amount] [numeric](17, 2) NULL,
	[closing_balance] [numeric](17, 2) NULL,
	[prompt_payment_discount] [numeric](17, 2) NULL,
	[paid_promptly] [varchar](1) NULL,
	[invoice_reference] [varchar](40) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[reversal] [varchar](1) NULL,
	[seq_accounting_period_id] [numeric](18, 0) NULL,
	[allocated_amount] [money] NULL,
	[invoice_due_date] [datetime] NULL,
	[fully_allocated_date] [datetime] NULL,
	[eligible_for_ppd] [varchar](1) NULL,
	[GL_posted_date] [datetime] NULL,
	[GL_accounting_period] [numeric](18, 0) NULL,
	[export_seq] [int] NULL,
	[batch_alloc_date] [datetime] NULL,
	[invoice_ppd_date] [datetime] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
