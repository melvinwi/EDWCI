USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[utl_meter_header](
	[site_id] [numeric](18, 0) NULL,
	[meter_code] [varchar](50) NULL,
	[meter_register] [varchar](10) NULL,
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[meter_header_id] [numeric](18, 0) NOT NULL,
	[meter_reader_id] [numeric](18, 0) NULL,
	[next_sched_read_date] [datetime] NULL,
	[install_date] [datetime] NULL,
	[meter_location] [varchar](100) NULL,
	[meter_hazard] [varchar](100) NULL,
	[meter_route] [varchar](100) NULL,
	[meter_use] [varchar](100) NULL,
	[meter_point] [varchar](100) NULL,
	[meter_manufacturer] [varchar](100) NULL,
	[meter_model] [varchar](100) NULL,
	[meter_constant] [varchar](100) NULL,
	[transformer_location] [varchar](100) NULL,
	[transformer_type] [varchar](100) NULL,
	[transformer_ratio] [varchar](100) NULL,
	[tou_usage_profile_id] [numeric](18, 0) NULL,
	[meter_serial] [varchar](40) NULL,
	[market_read_type_code] [varchar](20) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_utl_meter_header] PRIMARY KEY CLUSTERED 
(
	[meter_header_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_meter_header_Meta_LatestUpdateId] ON [orion].[utl_meter_header]
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
CREATE TABLE [orion].[utl_meter_header](
	[site_id] [numeric](18, 0) NULL,
	[meter_code] [varchar](50) NULL,
	[meter_register] [varchar](10) NULL,
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[meter_header_id] [numeric](18, 0) NOT NULL,
	[meter_reader_id] [numeric](18, 0) NULL,
	[next_sched_read_date] [datetime] NULL,
	[install_date] [datetime] NULL,
	[meter_location] [varchar](100) NULL,
	[meter_hazard] [varchar](100) NULL,
	[meter_route] [varchar](100) NULL,
	[meter_use] [varchar](100) NULL,
	[meter_point] [varchar](100) NULL,
	[meter_manufacturer] [varchar](100) NULL,
	[meter_model] [varchar](100) NULL,
	[meter_constant] [varchar](100) NULL,
	[transformer_location] [varchar](100) NULL,
	[transformer_type] [varchar](100) NULL,
	[transformer_ratio] [varchar](100) NULL,
	[tou_usage_profile_id] [numeric](18, 0) NULL,
	[meter_serial] [varchar](40) NULL,
	[market_read_type_code] [varchar](20) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_utl_meter_header] PRIMARY KEY CLUSTERED 
(
	[meter_header_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_meter_header_Meta_LatestUpdateId] ON [orion].[utl_meter_header]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
