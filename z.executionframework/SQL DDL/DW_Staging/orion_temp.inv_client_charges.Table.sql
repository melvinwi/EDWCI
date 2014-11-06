USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[inv_client_charges](
	[seq_client_charge_id] [numeric](18, 0) NULL,
	[seq_charge_item_id] [numeric](18, 0) NULL,
	[seq_party_id] [numeric](18, 0) NULL,
	[seq_invoice_header_id] [numeric](18, 0) NULL,
	[seq_invoice_detail_id] [numeric](18, 0) NULL,
	[charge_date] [datetime] NULL,
	[charge_amount] [money] NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[invoice_description] [varchar](255) NULL,
	[seq_recurring_charge_id] [numeric](18, 0) NULL,
	[notes] [varchar](255) NULL,
	[approved] [varchar](1) NULL,
	[approved_date] [datetime] NULL,
	[approved_user] [varchar](20) NULL,
	[seq_product_item_id] [numeric](18, 0) NULL,
	[ntinv_id] [numeric](18, 0) NULL,
	[tax_dtl_amount_1] [money] NULL,
	[tax_dtl_amount_2] [money] NULL,
	[tax_dtl_amount_3] [money] NULL,
	[tax_dtl_amount_4] [money] NULL,
	[tax_dtl_amount_5] [money] NULL,
	[tax_dtl_amount_6] [money] NULL,
	[tax_rate_history_id] [numeric](18, 0) NULL,
	[inv_smoothing_washup_id] [numeric](18, 0) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
