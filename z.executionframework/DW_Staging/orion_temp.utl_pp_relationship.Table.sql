USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_pp_relationship](
	[__$start_lsn] [binary](10) NULL,
	[__$seqval] [binary](10) NULL,
	[__$operation] [int] NULL,
	[__$update_mask] [varbinary](128) NULL,
	[price_plan_id] [numeric](18, 0) NULL,
	[pp_simple_sched_id] [numeric](18, 0) NULL,
	[allowed] [char](1) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[default_plan] [varchar](1) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
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
CREATE TABLE [orion_temp].[utl_pp_relationship](
	[__$start_lsn] [binary](10) NULL,
	[__$seqval] [binary](10) NULL,
	[__$operation] [int] NULL,
	[__$update_mask] [varbinary](128) NULL,
	[price_plan_id] [numeric](18, 0) NULL,
	[pp_simple_sched_id] [numeric](18, 0) NULL,
	[allowed] [char](1) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[default_plan] [varchar](1) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
