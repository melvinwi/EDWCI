USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_meter_header](
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
	[meter_header_id] [numeric](18, 0) NULL,
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
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
