USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_pp_schedule](
	[__$start_lsn] [binary](10) NULL,
	[__$seqval] [binary](10) NULL,
	[__$operation] [int] NULL,
	[__$update_mask] [varbinary](128) NULL,
	[sched_id] [numeric](18, 0) NULL,
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
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
