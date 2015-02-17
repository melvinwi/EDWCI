USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[inv_client_charges](
	[seq_client_charge_id] [numeric](18, 0) NOT NULL,
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
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_INV_CLIENT_CHARGES] PRIMARY KEY CLUSTERED 
(
	[seq_client_charge_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_inv_client_charges_Meta_LatestUpdateId] ON [orion].[inv_client_charges]
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
CREATE TABLE [orion].[inv_client_charges](
	[seq_client_charge_id] [numeric](18, 0) NOT NULL,
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
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_INV_CLIENT_CHARGES] PRIMARY KEY CLUSTERED 
(
	[seq_client_charge_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_inv_client_charges_Meta_LatestUpdateId] ON [orion].[inv_client_charges]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
