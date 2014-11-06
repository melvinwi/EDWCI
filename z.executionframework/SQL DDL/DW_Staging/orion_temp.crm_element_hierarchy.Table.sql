USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[crm_element_hierarchy](
	[__$start_lsn] [binary](10) NULL,
	[__$seqval] [binary](10) NULL,
	[__$operation] [int] NULL,
	[__$update_mask] [varbinary](128) NULL,
	[element_id] [numeric](18, 0) NULL,
	[element_struct_code] [varchar](10) NULL,
	[parent_id] [numeric](18, 0) NULL,
	[parent_element_struct_code] [varchar](10) NULL,
	[seq_element_type_id] [numeric](18, 0) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[start_date1] [datetime] NULL,
	[end_date1] [datetime] NULL,
	[department_head] [varchar](1) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
