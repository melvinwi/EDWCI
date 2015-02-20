USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[inv_charge_item](
	[seq_charge_item_id] [numeric](18, 0) NOT NULL,
	[seq_charge_group_id] [numeric](18, 0) NULL,
	[charge_item_code] [varchar](10) NULL,
	[charge_item_desc] [varchar](100) NOT NULL,
	[invoice_desc] [varchar](255) NULL,
	[charge_amount] [money] NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_account_id] [numeric](18, 0) NULL,
	[incl_in_discount_calcs] [varchar](1) NULL,
	[apply_tax] [varchar](1) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_INV_CHARGE_ITEM] PRIMARY KEY CLUSTERED 
(
	[seq_charge_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_inv_charge_item_Meta_LatestUpdateId] ON [orion].[inv_charge_item]
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
CREATE TABLE [orion].[inv_charge_item](
	[seq_charge_item_id] [numeric](18, 0) NOT NULL,
	[seq_charge_group_id] [numeric](18, 0) NULL,
	[charge_item_code] [varchar](10) NULL,
	[charge_item_desc] [varchar](100) NOT NULL,
	[invoice_desc] [varchar](255) NULL,
	[charge_amount] [money] NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_account_id] [numeric](18, 0) NULL,
	[incl_in_discount_calcs] [varchar](1) NULL,
	[apply_tax] [varchar](1) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_INV_CHARGE_ITEM] PRIMARY KEY CLUSTERED 
(
	[seq_charge_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_inv_charge_item_Meta_LatestUpdateId] ON [orion].[inv_charge_item]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
