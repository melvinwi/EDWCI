USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[utl_transaction](
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
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_UTL_TRANSACTION] PRIMARY KEY CLUSTERED 
(
	[trans_id] ASC,
	[trans_seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [_dta_index_utl_transaction_12_1342627826__K29_K59_K6_K28_K30_1_2_3_10_11_12_17_32] ON [orion].[utl_transaction]
(
	[trans_type_id] ASC,
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC,
	[site_id] ASC,
	[meter_id] ASC,
	[seq_invoice_detail_id] ASC
)
INCLUDE ( 	[trans_id],
	[trans_seq],
	[transaction_date],
	[trans_description],
	[unit_quantity],
	[multiplier],
	[net_amount],
	[tax_rate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [_dta_index_utl_transaction_12_1342627826__K29_K6_K4_K30_1_2_3_10_11_12_17_32_59] ON [orion].[utl_transaction]
(
	[trans_type_id] ASC,
	[site_id] ASC,
	[sched_id] ASC,
	[seq_invoice_detail_id] ASC
)
INCLUDE ( 	[trans_id],
	[trans_seq],
	[transaction_date],
	[trans_description],
	[unit_quantity],
	[multiplier],
	[net_amount],
	[tax_rate],
	[Meta_LatestUpdate_TaskExecutionInstanceId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [_dta_index_utl_transaction_12_1342627826__K59_K28_K6_K4_K29_K30_1_2_3_10_11_12_17_32] ON [orion].[utl_transaction]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC,
	[meter_id] ASC,
	[site_id] ASC,
	[sched_id] ASC,
	[trans_type_id] ASC,
	[seq_invoice_detail_id] ASC
)
INCLUDE ( 	[trans_id],
	[trans_seq],
	[transaction_date],
	[trans_description],
	[unit_quantity],
	[multiplier],
	[net_amount],
	[tax_rate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_transaction_Meta_LatestUpdateId] ON [orion].[utl_transaction]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[utl_transaction](
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
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_UTL_TRANSACTION] PRIMARY KEY CLUSTERED 
(
	[trans_id] ASC,
	[trans_seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [_dta_index_utl_transaction_12_1342627826__K29_K59_K6_K28_K30_1_2_3_10_11_12_17_32] ON [orion].[utl_transaction]
(
	[trans_type_id] ASC,
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC,
	[site_id] ASC,
	[meter_id] ASC,
	[seq_invoice_detail_id] ASC
)
INCLUDE ( 	[trans_id],
	[trans_seq],
	[transaction_date],
	[trans_description],
	[unit_quantity],
	[multiplier],
	[net_amount],
	[tax_rate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [_dta_index_utl_transaction_12_1342627826__K29_K6_K4_K30_1_2_3_10_11_12_17_32_59] ON [orion].[utl_transaction]
(
	[trans_type_id] ASC,
	[site_id] ASC,
	[sched_id] ASC,
	[seq_invoice_detail_id] ASC
)
INCLUDE ( 	[trans_id],
	[trans_seq],
	[transaction_date],
	[trans_description],
	[unit_quantity],
	[multiplier],
	[net_amount],
	[tax_rate],
	[Meta_LatestUpdate_TaskExecutionInstanceId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [_dta_index_utl_transaction_12_1342627826__K59_K28_K6_K4_K29_K30_1_2_3_10_11_12_17_32] ON [orion].[utl_transaction]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC,
	[meter_id] ASC,
	[site_id] ASC,
	[sched_id] ASC,
	[trans_type_id] ASC,
	[seq_invoice_detail_id] ASC
)
INCLUDE ( 	[trans_id],
	[trans_seq],
	[transaction_date],
	[trans_description],
	[unit_quantity],
	[multiplier],
	[net_amount],
	[tax_rate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_transaction_Meta_LatestUpdateId] ON [orion].[utl_transaction]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
