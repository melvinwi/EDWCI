USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[nc_product](
	[seq_party_id] [numeric](18, 0) NULL,
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_pcms_int_status_id] [numeric](18, 0) NULL,
	[seq_product_id] [numeric](18, 0) NULL,
	[seq_product_type_id] [numeric](18, 0) NULL,
	[seq_product_status_id] [numeric](18, 0) NULL,
	[seq_prev_provider_id] [numeric](18, 0) NULL,
	[seq_app_stage_id] [numeric](18, 0) NULL,
	[date_connected] [datetime] NULL,
	[application_entered] [datetime] NULL,
	[sales_complete] [datetime] NULL,
	[est_monthly_spend] [money] NULL,
	[connect_comm_paid] [varchar](1) NULL,
	[connect_comm_date] [datetime] NULL,
	[application_recieved] [datetime] NULL,
	[voice_ver_date] [datetime] NULL,
	[voice_ver_extn] [varchar](50) NULL,
	[years_in_site] [varchar](10) NULL,
	[multisite] [varchar](1) NULL,
	[sales_batch_num] [varchar](20) NULL,
	[external_reference] [varchar](50) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
