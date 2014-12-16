USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_virtual_meter_type](
	[virtual_meter_type_id] [numeric](18, 0) NULL,
	[virtual_meter_type_code] [varchar](20) NULL,
	[virtual_meter_type_desc] [varchar](100) NULL,
	[gen_req_cons] [varchar](1) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[sched_type_code] [varchar](20) NULL,
	[autogen_vmr] [varchar](20) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data]

GO
SET ANSI_PADDING OFF
GO
