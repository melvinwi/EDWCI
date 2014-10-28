USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[utl_conc_trans](
	[trans_id] [numeric](18, 0) NOT NULL,
	[trans_date] [datetime] NULL,
	[concession_id] [numeric](18, 0) NULL,
	[conc_card_id] [numeric](18, 0) NULL,
	[seq_product_item_id] [numeric](18, 0) NULL,
	[period_id] [numeric](18, 0) NULL,
	[seq_invoice_header_id] [numeric](18, 0) NULL,
	[invoiced_cust] [varchar](1) NULL,
	[dcs_invoice_number] [varchar](50) NULL,
	[dcs_invoice_date] [datetime] NULL,
	[invoiced_dcs] [varchar](1) NULL,
	[net_amount] [money] NULL,
	[trans_desc] [varchar](255) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_ar_adjust_id] [numeric](18, 0) NULL,
	[manual_trans] [varchar](1) NULL,
	[days] [numeric](8, 4) NULL DEFAULT ((0)),
	[unit_rate] [money] NULL DEFAULT (NULL),
	[unit_quantity] [numeric](18, 9) NULL DEFAULT (NULL),
	[backdate_conc_id] [numeric](18, 0) NULL,
	[conc_buffer_amt] [money] NULL DEFAULT ((0)),
	[seq_ar_conc_adjust_id] [numeric](18, 0) NULL,
	[net_amount_ppd] [money] NULL,
	[net_amount_no_ppd] [money] NULL,
	[admin_fee] [numeric](18, 4) NULL,
	[multiplier] [numeric](18, 2) NULL,
	[conc_start_date] [datetime] NULL,
	[conc_end_date] [datetime] NULL,
	[base_period_id] [numeric](16, 0) NULL,
	[base_invoice_header_id] [numeric](16, 0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [pk_utl_conc_trans] PRIMARY KEY CLUSTERED 
(
	[trans_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_conc_trans_Meta_LatestUpdateId] ON [orion].[utl_conc_trans]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
