USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_pp_schedule_type](
	[__$start_lsn] [binary](10) NULL,
	[__$seqval] [binary](10) NULL,
	[__$operation] [int] NULL,
	[__$update_mask] [varbinary](128) NULL,
	[sched_type_id] [numeric](18, 0) NULL,
	[sched_class_id] [numeric](18, 0) NULL,
	[seq_product_type_id] [numeric](18, 0) NULL,
	[sched_type_code] [varchar](10) NULL,
	[sched_type_desc] [varchar](100) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[default_option] [char](1) NULL,
	[trans_type_id] [numeric](18, 0) NULL,
	[seq_account_id] [numeric](18, 0) NULL,
	[use_simple_schedule] [varchar](1) NULL,
	[minimum_charge_freq] [varchar](20) NULL,
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
CREATE TABLE [orion_temp].[utl_pp_schedule_type](
	[__$start_lsn] [binary](10) NULL,
	[__$seqval] [binary](10) NULL,
	[__$operation] [int] NULL,
	[__$update_mask] [varbinary](128) NULL,
	[sched_type_id] [numeric](18, 0) NOT NULL,
	[sched_class_id] [numeric](18, 0) NULL,
	[seq_product_type_id] [numeric](18, 0) NULL,
	[sched_type_code] [varchar](10) NULL,
	[sched_type_desc] [varchar](100) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[default_option] [char](1) NULL,
	[trans_type_id] [numeric](18, 0) NULL,
	[seq_account_id] [numeric](18, 0) NULL,
	[use_simple_schedule] [varchar](1) NULL,
	[minimum_charge_freq] [varchar](20) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
