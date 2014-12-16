USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[utl_period_consumption](
	[meter_id] [numeric](18, 0) NOT NULL,
	[period_id] [numeric](18, 0) NOT NULL,
	[seq_product_item_id] [numeric](18, 0) NOT NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[opening_read] [numeric](18, 4) NULL,
	[closing_read] [numeric](18, 4) NULL,
	[usage_units] [numeric](18, 4) NULL,
	[estimate] [char](1) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[trans_generated] [varchar](1) NULL,
	[cubic_meters] [numeric](12, 4) NULL,
	[kwhconversion] [numeric](12, 4) NULL,
	[compressibility] [numeric](12, 4) NULL,
	[reg_pressure] [numeric](12, 4) NULL,
	[altitude] [numeric](12, 4) NULL,
	[inlet_pressure] [numeric](12, 4) NULL,
	[temperature] [numeric](12, 4) NULL,
	[pressure_factor] [numeric](12, 4) NULL,
	[calorific_value] [numeric](12, 4) NULL,
	[kwh_factor] [numeric](18, 0) NULL,
	[last_actual_read] [numeric](18, 0) NULL,
	[last_actual_read_date] [datetime] NULL,
	[temperature_factor] [numeric](18, 6) NULL,
	[profiled_actual_usage] [numeric](18, 4) NULL,
	[actual_percentage_change] [numeric](12, 5) NULL,
	[add_factor] [numeric](18, 0) NULL,
	[green_percent] [numeric](16, 4) NULL,
	[usage_porportion_4_pp] [numeric](10, 6) NULL,
	[pp_sched_id] [numeric](18, 0) NULL,
	[start_read_qm] [varchar](20) NULL,
	[end_read_qm] [varchar](20) NULL,
	[start_read_sub_type_id] [numeric](18, 0) NULL,
	[end_read_sub_type_id] [numeric](18, 0) NULL,
	[washup_amount] [numeric](18, 4) NULL,
	[washup_start_date] [datetime] NULL,
	[washup_end_date] [datetime] NULL,
	[no_of_est_reads] [smallint] NULL,
	[common_factor] [numeric](18, 6) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_UTL_PERIOD_CONSUMPTION] PRIMARY KEY CLUSTERED 
(
	[meter_id] ASC,
	[period_id] ASC,
	[seq_product_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
