USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_charge_transaction](
	[charge_trans_id] [numeric](18, 0) NULL,
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
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
