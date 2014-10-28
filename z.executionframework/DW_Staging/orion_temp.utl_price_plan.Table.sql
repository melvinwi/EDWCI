USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_price_plan](
	[price_plan_id] [numeric](18, 0) NULL,
	[seq_product_type_id] [numeric](18, 0) NULL,
	[price_plan_code] [varchar](20) NULL,
	[price_plan_desc] [varchar](100) NULL,
	[discount_pct] [numeric](19, 4) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[default_option] [char](1) NULL,
	[network_id] [numeric](18, 0) NULL,
	[seq_bus_unit_id] [numeric](18, 0) NULL,
	[rebate_percentage] [numeric](12, 4) NULL,
	[off_peak_rebate_percentage] [numeric](12, 4) NULL,
	[rebate_limit] [numeric](18, 0) NULL,
	[invoice_message] [varchar](max) NULL,
	[inv_msg_start_date] [datetime] NULL,
	[inv_msg_end_date] [datetime] NULL,
	[price_category_id] [numeric](18, 0) NULL,
	[product_sub_type] [varchar](20) NULL,
	[site_id] [numeric](18, 0) NULL,
	[tel_pp_id] [numeric](18, 0) NULL,
	[product_addon_type] [varchar](20) NULL,
	[external_reference] [varchar](50) NULL,
	[green_percent] [numeric](19, 4) NULL,
	[bundled_flag] [varchar](1) NULL,
	[cpi_pass_flag] [varchar](1) NULL,
	[network_cost_flag] [varchar](1) NULL,
	[upgrade_price_plan_id] [numeric](18, 0) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
