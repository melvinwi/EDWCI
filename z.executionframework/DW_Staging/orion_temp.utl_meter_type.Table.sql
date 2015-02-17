USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_meter_type](
	[meter_type_id] [numeric](18, 0) NULL,
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[meter_class_id] [numeric](18, 0) NULL,
	[meter_type_code] [varchar](10) NULL,
	[meter_type_desc] [varchar](100) NULL,
	[default_option] [varchar](1) NULL,
	[off_peak] [varchar](1) NULL,
	[price_class_id] [numeric](18, 0) NULL,
	[cost_price_class_id] [numeric](18, 0) NULL,
	[public_holidays] [varchar](1) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY]

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
CREATE TABLE [orion_temp].[utl_meter_type](
	[meter_type_id] [numeric](18, 0) NOT NULL,
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[meter_class_id] [numeric](18, 0) NULL,
	[meter_type_code] [varchar](10) NULL,
	[meter_type_desc] [varchar](100) NULL,
	[default_option] [varchar](1) NULL,
	[off_peak] [varchar](1) NULL,
	[price_class_id] [numeric](18, 0) NULL,
	[cost_price_class_id] [numeric](18, 0) NULL,
	[public_holidays] [varchar](1) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
