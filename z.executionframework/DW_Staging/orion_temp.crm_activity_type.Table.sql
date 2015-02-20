USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[crm_activity_type](
	[seq_act_type_id] [numeric](18, 0) NULL,
	[seq_act_class_id] [numeric](18, 0) NULL,
	[seq_act_category_id] [numeric](18, 0) NULL,
	[seq_wf_stage_id] [numeric](18, 0) NULL,
	[act_type_code] [varchar](20) NULL,
	[act_type_desc] [varchar](100) NULL,
	[mandatory_flag] [varchar](1) NULL,
	[duration_seq_cu_id] [numeric](18, 0) NULL,
	[duration_cu_qty] [char](10) NULL,
	[default_option] [varchar](1) NULL,
	[default_source_id] [numeric](18, 0) NULL,
	[default_closed] [varchar](1) NULL,
	[default_follow_up_type_id] [numeric](18, 0) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[default_note] [varchar](max) NULL,
	[activity_priority] [varchar](20) NULL,
	[user_select] [varchar](1) NULL,
	[seq_act_sub_class_id] [numeric](18, 0) NULL,
	[quick_code] [varchar](10) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data] TEXTIMAGE_ON [data]

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
CREATE TABLE [orion_temp].[crm_activity_type](
	[seq_act_type_id] [numeric](18, 0) NOT NULL,
	[seq_act_class_id] [numeric](18, 0) NULL,
	[seq_act_category_id] [numeric](18, 0) NULL,
	[seq_wf_stage_id] [numeric](18, 0) NULL,
	[act_type_code] [varchar](20) NULL,
	[act_type_desc] [varchar](100) NULL,
	[mandatory_flag] [varchar](1) NULL,
	[duration_seq_cu_id] [numeric](18, 0) NULL,
	[duration_cu_qty] [char](10) NULL,
	[default_option] [varchar](1) NULL,
	[default_source_id] [numeric](18, 0) NULL,
	[default_closed] [varchar](1) NULL,
	[default_follow_up_type_id] [numeric](18, 0) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[default_note] [varchar](max) NULL,
	[activity_priority] [varchar](20) NULL,
	[user_select] [varchar](1) NULL,
	[seq_act_sub_class_id] [numeric](18, 0) NULL,
	[quick_code] [varchar](10) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA] TEXTIMAGE_ON [DATA]

GO
SET ANSI_PADDING OFF
GO
