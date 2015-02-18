USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_pp_schedule_class](
	[__$start_lsn] [binary](10) NULL,
	[__$seqval] [binary](10) NULL,
	[__$operation] [int] NULL,
	[__$update_mask] [varbinary](128) NULL,
	[sched_class_id] [numeric](18, 0) NOT NULL,
	[sched_class_code] [varchar](10) NULL,
	[sched_class_desc] [varchar](100) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
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
CREATE TABLE [orion_temp].[utl_pp_schedule_class](
	[__$start_lsn] [binary](10) NULL,
	[__$seqval] [binary](10) NULL,
	[__$operation] [int] NULL,
	[__$update_mask] [varbinary](128) NULL,
	[sched_class_id] [numeric](18, 0) NOT NULL,
	[sched_class_code] [varchar](10) NULL,
	[sched_class_desc] [varchar](100) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
