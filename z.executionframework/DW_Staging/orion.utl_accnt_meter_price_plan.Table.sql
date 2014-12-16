USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[utl_accnt_meter_price_plan](
	[accnt_meter_price_plan_id] [numeric](18, 0) NOT NULL,
	[seq_product_item_id] [numeric](18, 0) NULL,
	[meter_id] [numeric](18, 0) NULL,
	[meter_pp_type_id] [numeric](18, 0) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[pp_simple_sched_id] [numeric](18, 0) NULL,
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](50) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](50) NULL,
	[update_process] [varchar](20) NULL,
	[pp_cost_simple_sched_id] [numeric](18, 0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [utl_accnt_meter_pp_pkey] PRIMARY KEY CLUSTERED 
(
	[accnt_meter_price_plan_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
