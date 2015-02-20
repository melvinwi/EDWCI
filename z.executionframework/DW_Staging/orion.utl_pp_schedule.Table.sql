USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[utl_pp_schedule](
	[sched_id] [numeric](18, 0) NOT NULL,
	[price_plan_id] [numeric](18, 0) NULL,
	[sched_type_id] [numeric](18, 0) NULL,
	[meter_type_id] [numeric](18, 0) NULL,
	[capacity_id] [numeric](18, 0) NULL,
	[band_header_id] [numeric](18, 0) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[contractable] [char](1) NULL,
	[summ_all_in_class] [char](1) NULL,
	[invoice_desc] [varchar](100) NULL,
	[seq_account_id] [numeric](18, 0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_utl_pp_schedule] PRIMARY KEY CLUSTERED 
(
	[sched_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_pp_schedule_Meta_LatestUpdateId] ON [orion].[utl_pp_schedule]
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
CREATE TABLE [orion].[utl_pp_schedule](
	[sched_id] [numeric](18, 0) NOT NULL,
	[price_plan_id] [numeric](18, 0) NULL,
	[sched_type_id] [numeric](18, 0) NULL,
	[meter_type_id] [numeric](18, 0) NULL,
	[capacity_id] [numeric](18, 0) NULL,
	[band_header_id] [numeric](18, 0) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[contractable] [char](1) NULL,
	[summ_all_in_class] [char](1) NULL,
	[invoice_desc] [varchar](100) NULL,
	[seq_account_id] [numeric](18, 0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_utl_pp_schedule] PRIMARY KEY CLUSTERED 
(
	[sched_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_pp_schedule_Meta_LatestUpdateId] ON [orion].[utl_pp_schedule]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
