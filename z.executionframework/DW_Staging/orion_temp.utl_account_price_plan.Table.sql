USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_account_price_plan](
	[acnt_price_plan_id] [numeric](18, 0) NULL,
	[price_plan_id] [numeric](18, 0) NULL,
	[seq_product_item_id] [numeric](18, 0) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[provisional] [varchar](1) NULL,
	[external_reference] [varchar](50) NULL,
	[requested_start_date] [datetime] NULL,
	[rate_card_id] [numeric](18, 0) NULL,
	[cpi_value] [numeric](16, 4) NULL,
	[network_cost_id] [numeric](18, 0) NULL,
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
CREATE TABLE [orion_temp].[utl_account_price_plan](
	[acnt_price_plan_id] [numeric](18, 0) NOT NULL,
	[price_plan_id] [numeric](18, 0) NULL,
	[seq_product_item_id] [numeric](18, 0) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[provisional] [varchar](1) NULL,
	[external_reference] [varchar](50) NULL,
	[requested_start_date] [datetime] NULL,
	[rate_card_id] [numeric](18, 0) NULL,
	[cpi_value] [numeric](16, 4) NULL,
	[network_cost_id] [numeric](18, 0) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
