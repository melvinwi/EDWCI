USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_meter_read](
	[meter_read_id] [numeric](18, 0) NOT NULL,
	[meter_id] [numeric](18, 0) NOT NULL,
	[read_type_id] [numeric](18, 0) NOT NULL,
	[seq_product_item_id] [numeric](18, 0) NULL,
	[meter_read] [numeric](18, 4) NULL,
	[read_date] [datetime] NOT NULL,
	[audit_reference] [varchar](1000) NULL,
	[estimated_read] [char](1) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[add_factor] [numeric](18, 0) NULL,
	[period_id] [numeric](18, 0) NULL,
	[if_filename] [varchar](1000) NULL,
	[no_read_desc] [varchar](100) NULL,
	[quality_method] [varchar](20) NULL,
	[ret_service_order_id] [varchar](15) NULL,
	[service_order_trans_code] [varchar](1) NULL,
	[quantity] [numeric](15, 3) NULL,
	[read_sub_type_id] [numeric](18, 0) NULL,
	[read_import_error_id] [numeric](18, 0) NULL,
	[reg_pressure] [numeric](12, 5) NULL,
	[calorific_value] [numeric](12, 5) NULL,
	[consumption_factor] [numeric](12, 6) NULL,
	[usage_units] [numeric](18, 4) NULL,
	[previous_read] [numeric](18, 4) NULL,
	[previous_read_date] [datetime] NULL,
	[imperial_read] [numeric](18, 4) NULL,
	[market_load_datetime] [datetime] NULL,
	[nem_no_read_reason_id] [numeric](18, 0) NULL,
	[nem_no_read_reason_text] [varchar](255) NULL,
	[transaction_code] [varchar](10) NULL,
	[consumption_litres] [numeric](19, 2) NULL,
	[common_factor] [numeric](18, 6) NULL,
	[import_meter_read_id] [numeric](18, 0) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
