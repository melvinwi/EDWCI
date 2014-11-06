USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[crm_activity](
	[seq_activity_id] [numeric](18, 0) NULL,
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
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data] TEXTIMAGE_ON [data]

GO
SET ANSI_PADDING OFF
GO
