USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_conc_trans](
	[trans_id] [numeric](18, 0) NULL,
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
	[days] [numeric](8, 4) NULL,
	[unit_rate] [money] NULL,
	[unit_quantity] [numeric](18, 9) NULL,
	[backdate_conc_id] [numeric](18, 0) NULL,
	[conc_buffer_amt] [money] NULL,
	[seq_ar_conc_adjust_id] [numeric](18, 0) NULL,
	[net_amount_ppd] [money] NULL,
	[net_amount_no_ppd] [money] NULL,
	[admin_fee] [numeric](18, 4) NULL,
	[multiplier] [numeric](18, 2) NULL,
	[conc_start_date] [datetime] NULL,
	[conc_end_date] [datetime] NULL,
	[base_period_id] [numeric](16, 0) NULL,
	[base_invoice_header_id] [numeric](16, 0) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [orion_temp].[utl_conc_trans] ADD  DEFAULT ((0)) FOR [days]
GO
ALTER TABLE [orion_temp].[utl_conc_trans] ADD  DEFAULT (NULL) FOR [unit_rate]
GO
ALTER TABLE [orion_temp].[utl_conc_trans] ADD  DEFAULT (NULL) FOR [unit_quantity]
GO
ALTER TABLE [orion_temp].[utl_conc_trans] ADD  DEFAULT ((0)) FOR [conc_buffer_amt]
GO
USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_conc_trans](
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
	[days] [numeric](8, 4) NULL,
	[unit_rate] [money] NULL,
	[unit_quantity] [numeric](18, 9) NULL,
	[backdate_conc_id] [numeric](18, 0) NULL,
	[conc_buffer_amt] [money] NULL,
	[seq_ar_conc_adjust_id] [numeric](18, 0) NULL,
	[net_amount_ppd] [money] NULL,
	[net_amount_no_ppd] [money] NULL,
	[admin_fee] [numeric](18, 4) NULL,
	[multiplier] [numeric](18, 2) NULL,
	[conc_start_date] [datetime] NULL,
	[conc_end_date] [datetime] NULL,
	[base_period_id] [numeric](16, 0) NULL,
	[base_invoice_header_id] [numeric](16, 0) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [orion_temp].[utl_conc_trans] ADD  DEFAULT ((0)) FOR [days]
GO
ALTER TABLE [orion_temp].[utl_conc_trans] ADD  DEFAULT (NULL) FOR [unit_rate]
GO
ALTER TABLE [orion_temp].[utl_conc_trans] ADD  DEFAULT (NULL) FOR [unit_quantity]
GO
ALTER TABLE [orion_temp].[utl_conc_trans] ADD  DEFAULT ((0)) FOR [conc_buffer_amt]
GO
