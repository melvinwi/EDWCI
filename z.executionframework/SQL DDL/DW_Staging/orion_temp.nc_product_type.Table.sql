USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[nc_product_type](
	[seq_product_type_id] [numeric](18, 0) NULL,
	[product_type_code] [varchar](10) NULL,
	[product_type_desc] [varchar](100) NULL,
	[pcms_prefix_code] [varchar](10) NULL,
	[pb_object] [varchar](100) NULL,
	[icon] [varchar](100) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[default_yn] [varchar](1) NULL,
	[external_reference] [varchar](20) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data]

GO
SET ANSI_PADDING OFF
GO
