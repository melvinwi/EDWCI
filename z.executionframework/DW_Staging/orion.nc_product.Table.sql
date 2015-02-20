USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[nc_product](
	[seq_party_id] [numeric](18, 0) NULL,
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_pcms_int_status_id] [numeric](18, 0) NULL,
	[seq_product_id] [numeric](18, 0) NOT NULL,
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
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_nc_product] PRIMARY KEY CLUSTERED 
(
	[seq_product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_nc_product_Meta_LatestUpdateId] ON [orion].[nc_product]
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
CREATE TABLE [orion].[nc_product](
	[seq_party_id] [numeric](18, 0) NULL,
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_pcms_int_status_id] [numeric](18, 0) NULL,
	[seq_product_id] [numeric](18, 0) NOT NULL,
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
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_nc_product] PRIMARY KEY CLUSTERED 
(
	[seq_product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_nc_product_Meta_LatestUpdateId] ON [orion].[nc_product]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
