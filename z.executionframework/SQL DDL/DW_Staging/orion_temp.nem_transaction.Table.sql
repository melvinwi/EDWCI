USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[nem_transaction](
	[trans_id] [numeric](18, 0) NULL,
	[trans_status_id] [numeric](18, 0) NULL,
	[file_header_id] [numeric](18, 0) NULL,
	[trans_type_id] [numeric](18, 0) NULL,
	[site_id] [numeric](18, 0) NULL,
	[seq_product_item_id] [numeric](18, 0) NULL,
	[objection_id] [numeric](18, 0) NULL,
	[change_reason_id] [numeric](18, 0) NULL,
	[nem_trans_id] [varchar](100) NULL,
	[trans_date] [datetime] NULL,
	[nem_init_trans_id] [varchar](100) NULL,
	[outgoing_flag] [char](1) NULL,
	[xml_text] [varchar](max) NULL,
	[receipt_trans_id] [varchar](100) NULL,
	[receipt_date] [datetime] NULL,
	[receipt_status] [varchar](20) NULL,
	[comments] [varchar](1000) NULL,
	[error_message] [varchar](1000) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[participant_code] [varchar](20) NULL,
	[RequestID] [varchar](30) NULL,
	[nem_objection_id] [varchar](100) NULL,
	[actual_change_date] [varchar](10) NULL,
	[cancellation_id] [numeric](18, 0) NULL,
	[network_section_id] [numeric](18, 0) NULL,
	[processing_status] [varchar](20) NULL,
	[init_receipt_trans_id] [varchar](100) NULL,
	[init_nem_objection_id] [varchar](100) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[imbalance_amount] [numeric](18, 4) NULL,
	[objection_status] [varchar](20) NULL,
	[alert_key_info] [varchar](100) NULL,
	[alert_context] [varchar](1000) NULL,
	[acknowledgement_id] [varchar](100) NULL,
	[error_id] [numeric](18, 0) NULL,
	[proposed_change_date] [varchar](10) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data] TEXTIMAGE_ON [data]

GO
SET ANSI_PADDING OFF
GO
