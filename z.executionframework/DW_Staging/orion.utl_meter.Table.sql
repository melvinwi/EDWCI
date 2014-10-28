USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[utl_meter](
	[meter_id] [numeric](18, 0) NOT NULL,
	[site_id] [numeric](18, 0) NULL,
	[usage_profile_id] [numeric](18, 0) NULL,
	[meter_type_id] [numeric](18, 0) NULL,
	[meter_code] [varchar](50) NULL,
	[meter_register] [varchar](10) NULL,
	[multiplier] [numeric](18, 6) NULL,
	[est_daily_consumption] [numeric](18, 6) NULL,
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[dial_format] [varchar](10) NULL,
	[meter_header_id] [numeric](18, 0) NULL,
	[datastream_suffix] [varchar](10) NULL,
	[compressibility] [money] NULL,
	[reg_pressure] [money] NULL,
	[altitude] [money] NULL,
	[inlet_pressure] [money] NULL,
	[pp_simple_sched_id] [numeric](18, 0) NULL,
	[meter_owner] [varchar](20) NULL,
	[period_of_avail] [varchar](20) NULL,
	[relay_owner] [varchar](20) NULL,
	[meter_status_code] [varchar](20) NULL,
	[meter_units] [varchar](20) NULL,
	[meter_status_date] [datetime] NULL,
	[meter_reader_if_status] [varchar](20) NULL,
	[meter_reader_id] [numeric](18, 0) NULL,
	[wholesale_price_sched_id] [numeric](18, 0) NULL,
	[controlled] [varchar](100) NULL,
	[network_tariff_code] [varchar](20) NULL,
	[read_cycle_code] [varchar](20) NULL,
	[meter_status_id] [numeric](18, 0) NULL,
	[provisional] [varchar](1) NULL,
	[next_sched_read_date] [datetime] NULL,
	[meter_suffix] [varchar](2) NULL,
	[read_cycle_type_code] [varchar](10) NULL,
	[time_of_day] [varchar](10) NULL,
	[estimation_method] [varchar](20) NULL,
	[imperial_meter] [varchar](1) NULL,
	[read_sequence] [numeric](18, 0) NULL,
	[direction_ind] [varchar](1) NULL,
	[est_annual_consumption] [numeric](18, 6) NULL,
	[period_of_avail_id] [numeric](18, 0) NULL,
	[meter_location_id] [numeric](18, 0) NULL,
	[meter_notes] [varchar](256) NULL,
	[install_date] [datetime] NULL,
	[removal_date] [datetime] NULL,
	[meter_category_id] [numeric](18, 0) NULL,
	[energy_flow_direction] [varchar](1) NULL,
	[usage_desc_id] [numeric](18, 0) NULL,
	[market_meter_code] [varchar](50) NULL,
	[market_meter_register] [varchar](10) NULL,
	[last_meter_read_insert_date] [datetime] NULL,
	[vm_start_date] [datetime] NULL,
	[vm_end_date] [datetime] NULL,
	[virtual_meter_type_id] [numeric](18, 0) NULL,
	[meter_timing] [varchar](100) NULL,
	[installation_type] [varchar](4) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_utl_meter] PRIMARY KEY CLUSTERED 
(
	[meter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_meter_Meta_LatestUpdateId] ON [orion].[utl_meter]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
