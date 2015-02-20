USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[utl_pp_simple_schedule_rate](
	[pp_simple_sched_id] [numeric](18, 0) NOT NULL,
	[start_date] [datetime] NOT NULL,
	[end_date] [datetime] NULL,
	[price_step0] [numeric](18, 7) NULL,
	[price_step1] [numeric](18, 7) NULL,
	[price_step2] [numeric](18, 7) NULL,
	[price_step3] [numeric](18, 7) NULL,
	[price_step4] [numeric](18, 7) NULL,
	[cost_price_step0] [numeric](18, 7) NULL,
	[cost_price_step1] [numeric](18, 7) NULL,
	[cost_price_step2] [numeric](18, 7) NULL,
	[cost_price_step3] [numeric](18, 7) NULL,
	[cost_price_step4] [numeric](18, 7) NULL,
	[units_step1] [money] NULL,
	[units_step2] [money] NULL,
	[units_step3] [money] NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[price_step5] [numeric](18, 7) NULL,
	[cost_price_step5] [numeric](18, 7) NULL,
	[units_step4] [money] NULL,
	[minimum_charge_per_day] [numeric](16, 6) NULL,
	[minimum_cost_charge_per_day] [numeric](16, 6) NULL,
	[rate_reference] [varchar](255) NULL,
	[rate_card_id] [numeric](18, 0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_utl_pp_simple_schedule_rate] PRIMARY KEY CLUSTERED 
(
	[pp_simple_sched_id] ASC,
	[start_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

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
CREATE TABLE [orion].[utl_pp_simple_schedule_rate](
	[pp_simple_sched_id] [numeric](18, 0) NOT NULL,
	[start_date] [datetime] NOT NULL,
	[end_date] [datetime] NULL,
	[price_step0] [numeric](18, 7) NULL,
	[price_step1] [numeric](18, 7) NULL,
	[price_step2] [numeric](18, 7) NULL,
	[price_step3] [numeric](18, 7) NULL,
	[price_step4] [numeric](18, 7) NULL,
	[cost_price_step0] [numeric](18, 7) NULL,
	[cost_price_step1] [numeric](18, 7) NULL,
	[cost_price_step2] [numeric](18, 7) NULL,
	[cost_price_step3] [numeric](18, 7) NULL,
	[cost_price_step4] [numeric](18, 7) NULL,
	[units_step1] [money] NULL,
	[units_step2] [money] NULL,
	[units_step3] [money] NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[price_step5] [numeric](18, 7) NULL,
	[cost_price_step5] [numeric](18, 7) NULL,
	[units_step4] [money] NULL,
	[minimum_charge_per_day] [numeric](16, 6) NULL,
	[minimum_cost_charge_per_day] [numeric](16, 6) NULL,
	[rate_reference] [varchar](255) NULL,
	[rate_card_id] [numeric](18, 0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_utl_pp_simple_schedule_rate] PRIMARY KEY CLUSTERED 
(
	[pp_simple_sched_id] ASC,
	[start_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_pp_simple_schedule_rate_Meta_LatestUpdateId] ON [orion].[utl_pp_simple_schedule_rate]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
