USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_network_node_sched](
	[netnode_sched_id] [numeric](18, 0) NOT NULL,
	[network_node_id] [numeric](18, 0) NULL,
	[loss_factor] [numeric](18, 4) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
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
