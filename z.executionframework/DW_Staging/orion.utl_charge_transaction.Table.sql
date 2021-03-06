USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[utl_charge_transaction](
	[charge_trans_id] [numeric](18, 0) NOT NULL,
	[charge_date] [datetime] NULL,
	[seq_invoice_header_id] [numeric](18, 0) NULL,
	[seq_invoice_detail_id] [numeric](18, 0) NULL,
	[seq_party_id] [numeric](18, 0) NULL,
	[seq_charge_item_id] [numeric](18, 0) NULL,
	[seq_client_charge_id] [numeric](18, 0) NULL,
	[charge_item_code] [varchar](10) NULL,
	[charge_item_desc] [varchar](100) NULL,
	[invoice_desc] [varchar](255) NULL,
	[net_amount] [money] NULL,
	[tax_amount] [money] NULL,
	[total_amount] [money] NULL,
	[gl_code] [varchar](50) NULL,
	[reversal] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](50) NULL,
	[insert_process] [varchar](50) NULL,
	[update_datetime] [varchar](20) NULL,
	[update_user] [varchar](50) NULL,
	[update_process] [varchar](50) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [utl_charge_trans_pkey] PRIMARY KEY CLUSTERED 
(
	[charge_trans_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_charge_transaction_Meta_LatestUpdateId] ON [orion].[utl_charge_transaction]
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
CREATE TABLE [orion].[utl_charge_transaction](
	[charge_trans_id] [numeric](18, 0) NOT NULL,
	[charge_date] [datetime] NULL,
	[seq_invoice_header_id] [numeric](18, 0) NULL,
	[seq_invoice_detail_id] [numeric](18, 0) NULL,
	[seq_party_id] [numeric](18, 0) NULL,
	[seq_charge_item_id] [numeric](18, 0) NULL,
	[seq_client_charge_id] [numeric](18, 0) NULL,
	[charge_item_code] [varchar](10) NULL,
	[charge_item_desc] [varchar](100) NULL,
	[invoice_desc] [varchar](255) NULL,
	[net_amount] [money] NULL,
	[tax_amount] [money] NULL,
	[total_amount] [money] NULL,
	[gl_code] [varchar](50) NULL,
	[reversal] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](50) NULL,
	[insert_process] [varchar](50) NULL,
	[update_datetime] [varchar](20) NULL,
	[update_user] [varchar](50) NULL,
	[update_process] [varchar](50) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [utl_charge_trans_pkey] PRIMARY KEY CLUSTERED 
(
	[charge_trans_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_charge_transaction_Meta_LatestUpdateId] ON [orion].[utl_charge_transaction]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
