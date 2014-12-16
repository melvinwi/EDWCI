USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_network_node](
	[network_node_id] [numeric](18, 0) NULL,
	[network_id] [numeric](18, 0) NULL,
	[network_node_code] [varchar](20) NULL,
	[network_node_desc] [varchar](100) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[loss_factor] [numeric](18, 4) NULL,
	[temperature] [money] NULL,
	[gas_calorific_value] [money] NULL,
	[region_id] [numeric](18, 0) NULL,
	[incumbent_id] [numeric](18, 0) NULL,
	[network_section_id] [numeric](18, 0) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data]

GO
SET ANSI_PADDING OFF
GO
