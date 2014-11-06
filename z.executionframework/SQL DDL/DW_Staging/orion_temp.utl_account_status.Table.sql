USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_account_status](
	[accnt_status_id] [numeric](18, 0) NULL,
	[accnt_status_code] [varchar](10) NULL,
	[accnt_status_desc] [varchar](100) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_product_type_id] [numeric](18, 0) NULL,
	[require_action] [char](1) NULL,
	[default_option] [char](1) NULL,
	[accnt_status_class_id] [numeric](18, 0) NULL,
	[accnt_status_short_desc] [varchar](15) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
