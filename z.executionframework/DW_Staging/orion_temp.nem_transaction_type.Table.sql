USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[nem_transaction_type](
	[trans_type_id] [numeric](18, 0) NULL,
	[trans_type_code] [varchar](10) NULL,
	[trans_type_desc] [varchar](100) NULL,
	[manual_trans_flag] [char](1) NULL,
	[response_reqd_flag] [char](1) NULL,
	[inbox_flag] [char](1) NULL,
	[outbox_flag] [char](1) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[market_interface_code] [varchar](20) NULL,
	[xml_trans_type] [varchar](100) NULL,
	[trans_type_group] [varchar](20) NULL,
	[copy_file_flag] [varchar](1) NULL,
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
CREATE TABLE [orion_temp].[nem_transaction_type](
	[trans_type_id] [numeric](18, 0) NOT NULL,
	[trans_type_code] [varchar](10) NULL,
	[trans_type_desc] [varchar](100) NULL,
	[manual_trans_flag] [char](1) NULL,
	[response_reqd_flag] [char](1) NULL,
	[inbox_flag] [char](1) NULL,
	[outbox_flag] [char](1) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[market_interface_code] [varchar](20) NULL,
	[xml_trans_type] [varchar](100) NULL,
	[trans_type_group] [varchar](20) NULL,
	[copy_file_flag] [varchar](1) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
