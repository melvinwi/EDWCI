USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[crm_activity](
	[seq_activity_id] [numeric](18, 0) NOT NULL,
	[seq_act_type_id] [numeric](18, 0) NULL,
	[seq_act_status_id] [numeric](18, 0) NULL,
	[seq_act_source_id] [numeric](18, 0) NULL,
	[seq_as_reason_id] [numeric](18, 0) NULL,
	[seq_wf_stage_id] [numeric](18, 0) NULL,
	[seq_act_severity_id] [numeric](18, 0) NULL,
	[seq_cmpgn_id] [numeric](18, 0) NULL,
	[activity_date] [datetime] NULL,
	[closed_date] [datetime] NULL,
	[required_date] [datetime] NULL,
	[probability_pct] [numeric](18, 0) NULL,
	[act_start_time] [varchar](5) NULL,
	[act_end_time] [varchar](5) NULL,
	[act_duration] [varchar](10) NULL,
	[tentative_flag] [varchar](1) NULL,
	[private_flag] [varchar](1) NULL,
	[reminder_flag] [varchar](1) NULL,
	[reminder_datetime] [datetime] NULL,
	[reminder_minutes] [int] NULL,
	[notes] [varchar](max) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[activity_priority] [varchar](20) NULL,
	[req_followup_flag] [char](1) NULL,
	[parent_activity_id] [numeric](18, 0) NULL,
	[seq_party_id] [numeric](18, 0) NULL,
	[seq_assignee_id] [numeric](18, 0) NULL,
	[seq_product_item_id] [numeric](18, 0) NULL,
	[read_flag] [char](1) NULL,
	[closed_by] [varchar](20) NULL,
	[status_reason] [varchar](100) NULL,
	[bulk_insert_id] [uniqueidentifier] NULL,
	[seq_disposition_id] [numeric](18, 0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK__crm_activity__2E51B1C3] PRIMARY KEY CLUSTERED 
(
	[seq_activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data] TEXTIMAGE_ON [data]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_crm_activity_Meta_LatestUpdateId] ON [orion].[crm_activity]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[crm_activity](
	[seq_activity_id] [numeric](18, 0) NOT NULL,
	[seq_act_type_id] [numeric](18, 0) NULL,
	[seq_act_status_id] [numeric](18, 0) NULL,
	[seq_act_source_id] [numeric](18, 0) NULL,
	[seq_as_reason_id] [numeric](18, 0) NULL,
	[seq_wf_stage_id] [numeric](18, 0) NULL,
	[seq_act_severity_id] [numeric](18, 0) NULL,
	[seq_cmpgn_id] [numeric](18, 0) NULL,
	[activity_date] [datetime] NULL,
	[closed_date] [datetime] NULL,
	[required_date] [datetime] NULL,
	[probability_pct] [numeric](18, 0) NULL,
	[act_start_time] [varchar](5) NULL,
	[act_end_time] [varchar](5) NULL,
	[act_duration] [varchar](10) NULL,
	[tentative_flag] [varchar](1) NULL,
	[private_flag] [varchar](1) NULL,
	[reminder_flag] [varchar](1) NULL,
	[reminder_datetime] [datetime] NULL,
	[reminder_minutes] [int] NULL,
	[notes] [varchar](max) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[activity_priority] [varchar](20) NULL,
	[req_followup_flag] [char](1) NULL,
	[parent_activity_id] [numeric](18, 0) NULL,
	[seq_party_id] [numeric](18, 0) NULL,
	[seq_assignee_id] [numeric](18, 0) NULL,
	[seq_product_item_id] [numeric](18, 0) NULL,
	[read_flag] [char](1) NULL,
	[closed_by] [varchar](20) NULL,
	[status_reason] [varchar](100) NULL,
	[bulk_insert_id] [uniqueidentifier] NULL,
	[seq_disposition_id] [numeric](18, 0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK__crm_activity__2E51B1C3] PRIMARY KEY CLUSTERED 
(
	[seq_activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA] TEXTIMAGE_ON [DATA]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_crm_activity_Meta_LatestUpdateId] ON [orion].[crm_activity]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
