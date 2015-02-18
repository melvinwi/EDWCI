USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_transaction](
	[trans_id] [numeric](18, 0) NULL,
	[trans_seq] [numeric](18, 0) NULL,
	[transaction_date] [datetime] NULL,
	[sched_id] [numeric](18, 0) NULL,
	[seq_party_id] [numeric](18, 0) NULL,
	[site_id] [numeric](18, 0) NULL,
	[seq_product_item_id] [numeric](18, 0) NULL,
	[period_id] [numeric](18, 0) NULL,
	[band_det_id] [numeric](18, 0) NULL,
	[trans_description] [varchar](100) NULL,
	[unit_quantity] [numeric](18, 4) NULL,
	[multiplier] [numeric](12, 4) NULL,
	[unit_rate] [numeric](18, 7) NULL,
	[gross_amount] [money] NULL,
	[tax_amount] [money] NULL,
	[discount_amount] [money] NULL,
	[net_amount] [money] NULL,
	[reversal] [char](1) NULL,
	[invoiced] [char](1) NULL,
	[seq_invoice_run_id] [numeric](18, 0) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[meter_id] [numeric](18, 0) NULL,
	[trans_type_id] [numeric](18, 0) NULL,
	[seq_invoice_detail_id] [numeric](18, 0) NULL,
	[discount_rate] [numeric](18, 4) NULL,
	[tax_rate] [money] NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[start_read] [numeric](18, 4) NULL,
	[end_read] [numeric](18, 4) NULL,
	[trans_loss_factor] [numeric](10, 5) NULL,
	[dist_loss_factor] [numeric](10, 5) NULL,
	[pp_simple_sched_id] [numeric](18, 0) NULL,
	[tco_id] [numeric](18, 0) NULL,
	[accnt_prod_addon_id] [numeric](18, 0) NULL,
	[fdr_date] [datetime] NULL,
	[adj_trans_yn] [varchar](1) NULL,
	[adj_trans_id] [numeric](18, 0) NULL,
	[adj_trans_seq] [numeric](18, 0) NULL,
	[tax_rate_history_id] [numeric](18, 0) NULL,
	[ntinv_id] [numeric](18, 0) NULL,
	[tax_dtl_amount_1] [money] NULL,
	[tax_dtl_amount_2] [money] NULL,
	[tax_dtl_amount_3] [money] NULL,
	[tax_dtl_amount_4] [money] NULL,
	[tax_dtl_amount_5] [money] NULL,
	[tax_dtl_amount_6] [money] NULL,
	[start_index_read] [numeric](18, 6) NULL,
	[start_index_read_date] [datetime] NULL,
	[end_index_read] [numeric](18, 6) NULL,
	[end_index_read_date] [datetime] NULL,
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
CREATE TABLE [orion_temp].[utl_transaction](
	[trans_id] [numeric](18, 0) NOT NULL,
	[trans_seq] [numeric](18, 0) NOT NULL,
	[transaction_date] [datetime] NULL,
	[sched_id] [numeric](18, 0) NULL,
	[seq_party_id] [numeric](18, 0) NULL,
	[site_id] [numeric](18, 0) NULL,
	[seq_product_item_id] [numeric](18, 0) NULL,
	[period_id] [numeric](18, 0) NULL,
	[band_det_id] [numeric](18, 0) NULL,
	[trans_description] [varchar](100) NULL,
	[unit_quantity] [numeric](18, 4) NULL,
	[multiplier] [numeric](12, 4) NULL,
	[unit_rate] [numeric](18, 7) NULL,
	[gross_amount] [money] NULL,
	[tax_amount] [money] NULL,
	[discount_amount] [money] NULL,
	[net_amount] [money] NULL,
	[reversal] [char](1) NULL,
	[invoiced] [char](1) NULL,
	[seq_invoice_run_id] [numeric](18, 0) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[meter_id] [numeric](18, 0) NULL,
	[trans_type_id] [numeric](18, 0) NULL,
	[seq_invoice_detail_id] [numeric](18, 0) NULL,
	[discount_rate] [numeric](18, 4) NULL,
	[tax_rate] [money] NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[start_read] [numeric](18, 4) NULL,
	[end_read] [numeric](18, 4) NULL,
	[trans_loss_factor] [numeric](10, 5) NULL,
	[dist_loss_factor] [numeric](10, 5) NULL,
	[pp_simple_sched_id] [numeric](18, 0) NULL,
	[tco_id] [numeric](18, 0) NULL,
	[accnt_prod_addon_id] [numeric](18, 0) NULL,
	[fdr_date] [datetime] NULL,
	[adj_trans_yn] [varchar](1) NULL,
	[adj_trans_id] [numeric](18, 0) NULL,
	[adj_trans_seq] [numeric](18, 0) NULL,
	[tax_rate_history_id] [numeric](18, 0) NULL,
	[ntinv_id] [numeric](18, 0) NULL,
	[tax_dtl_amount_1] [money] NULL,
	[tax_dtl_amount_2] [money] NULL,
	[tax_dtl_amount_3] [money] NULL,
	[tax_dtl_amount_4] [money] NULL,
	[tax_dtl_amount_5] [money] NULL,
	[tax_dtl_amount_6] [money] NULL,
	[start_index_read] [numeric](18, 6) NULL,
	[start_index_read_date] [datetime] NULL,
	[end_index_read] [numeric](18, 6) NULL,
	[end_index_read_date] [datetime] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
