USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[utl_pp_simple_schedule](
	[pp_simple_sched_id] [numeric](18, 0) NOT NULL,
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
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [pk_tab_607459] PRIMARY KEY CLUSTERED 
(
	[pp_simple_sched_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_pp_simple_schedule_Meta_LatestUpdateId] ON [orion].[utl_pp_simple_schedule]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
