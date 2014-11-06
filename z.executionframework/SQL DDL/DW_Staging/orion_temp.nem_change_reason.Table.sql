USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[nem_change_reason](
	[change_reason_id] [numeric](18, 0) NULL,
	[change_reason_code] [varchar](10) NULL,
	[change_reason_desc] [varchar](100) NULL,
	[switch_reason_flag] [char](1) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[end_date_required] [varchar](1) NULL,
	[bus_days_in_past] [int] NULL,
	[bus_days_in_future] [int] NULL,
	[seq_product_type_id] [numeric](18, 0) NULL,
	[site_class_id] [numeric](18, 0) NULL,
	[retro_cr_code] [varchar](10) NULL,
	[future_cr_code] [varchar](10) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data]

GO
SET ANSI_PADDING OFF
GO
