USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[crm_activity_disposition](
	[seq_disposition_id] [numeric](18, 0) NULL,
	[disposition_code] [varchar](50) NULL,
	[disposition_desc] [varchar](100) NULL,
	[seq_disposition_class_id] [numeric](18, 0) NULL,
	[active] [char](1) NULL,
	[contact] [char](1) NULL,
	[exclusion] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data]

GO
SET ANSI_PADDING OFF
GO