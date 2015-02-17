USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[inv_charge_item](
	[seq_charge_item_id] [numeric](18, 0) NULL,
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
CREATE TABLE [orion_temp].[inv_charge_item](
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
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
