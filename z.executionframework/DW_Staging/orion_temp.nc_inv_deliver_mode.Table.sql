USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[nc_inv_deliver_mode](
	[seq_inv_del_mode_id] [numeric](18, 0) NULL,
	[inv_del_mode_code] [varchar](10) NULL,
	[inv_del_mode_desc] [varchar](100) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[del_meth_id] [numeric](18, 0) NULL,
	[oss_desc] [varchar](1000) NULL,
	[oss_text] [varchar](100) NULL,
	[category_code] [varchar](20) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
