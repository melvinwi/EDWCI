USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[inv_invoice_detail](
	[seq_invoice_header_id] [numeric](18, 0) NULL,
	[seq_invoice_detail_id] [numeric](18, 0) NOT NULL,
	[transaction_reference] [varchar](40) NULL,
	[transaction_date] [datetime] NULL,
	[any_text1] [varchar](100) NULL,
	[any_num1] [money] NULL,
	[any_text2] [varchar](100) NULL,
	[any_num2] [money] NULL,
	[any_text3] [varchar](100) NULL,
	[any_num3] [money] NULL,
	[any_text4] [varchar](100) NULL,
	[any_num4] [money] NULL,
	[item_code] [varchar](40) NULL,
	[detail_desc] [varchar](255) NULL,
	[quantity] [money] NULL,
	[multiplier] [numeric](12, 4) NULL,
	[unit_price] [money] NULL,
	[net_amount] [money] NULL,
	[tax_amount] [money] NULL,
	[total_amount] [money] NULL,
	[discount_amount] [money] NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_bus_unit_id] [numeric](18, 0) NULL,
	[seq_client_charge_id] [numeric](18, 0) NULL,
	[seq_product_type_id] [numeric](18, 0) NULL,
	[gst_inclusive] [varchar](1) NULL,
	[tax_dtl_amount_1] [money] NULL,
	[tax_dtl_amount_2] [money] NULL,
	[tax_dtl_amount_3] [money] NULL,
	[tax_dtl_amount_4] [money] NULL,
	[tax_dtl_amount_5] [money] NULL,
	[tax_dtl_amount_6] [money] NULL,
	[seq_product_item_id] [numeric](18, 0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_INV_INVOICE_DETAIL] PRIMARY KEY CLUSTERED 
(
	[seq_invoice_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_inv_invoice_detail_Meta_LatestUpdateId] ON [orion].[inv_invoice_detail]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
