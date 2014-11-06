USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_pp_simple_schedule](
	[pp_simple_sched_id] [numeric](18, 0) NULL,
	[network_id] [numeric](18, 0) NULL,
	[pp_simple_sched_code] [varchar](20) NULL,
	[pp_simple_sched_desc] [varchar](100) NULL,
	[sched_type_id] [numeric](18, 0) NULL,
	[pattern_class] [varchar](20) NULL,
	[invoice_desc] [varchar](60) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[price_class_id] [numeric](18, 0) NULL,
	[tou_usage_price_plan] [varchar](1) NULL,
	[meter_type_id] [numeric](18, 0) NULL,
	[seq_rev_account_id] [numeric](18, 0) NULL,
	[seq_cost_account_id] [numeric](18, 0) NULL,
	[period_of_avail_id] [numeric](18, 0) NULL,
	[site_id] [numeric](18, 0) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
