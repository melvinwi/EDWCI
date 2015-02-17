USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[utl_site](
	[site_id] [numeric](18, 0) NOT NULL,
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[capacity_id] [numeric](18, 0) NULL,
	[network_id] [numeric](18, 0) NULL,
	[network_node_id] [numeric](18, 0) NULL,
	[seq_product_type_id] [numeric](18, 0) NULL,
	[street_type_id] [numeric](18, 0) NULL,
	[init_read_type_id] [numeric](18, 0) NULL,
	[site_identifier] [varchar](100) NULL,
	[password] [varchar](50) NULL,
	[addr_unit_no] [varchar](20) NULL,
	[addr_street_no] [varchar](20) NULL,
	[addr_street_name] [varchar](50) NULL,
	[addr_property_name] [varchar](100) NULL,
	[addr_suburb] [varchar](100) NULL,
	[addr_city] [varchar](100) NULL,
	[loss_factor] [money] NULL,
	[current_account_id] [numeric](18, 0) NULL,
	[avg_monthly_spend] [money] NULL,
	[def_usage_profile_id] [numeric](18, 0) NULL,
	[user_defined1] [varchar](100) NULL,
	[user_defined2] [varchar](100) NULL,
	[user_defined3] [varchar](100) NULL,
	[addr_struct_flag] [varchar](1) NULL,
	[addr_unit_type] [varchar](20) NULL,
	[addr_floor_type] [varchar](20) NULL,
	[addr_floor_no] [varchar](20) NULL,
	[addr_street_no_suffix] [varchar](20) NULL,
	[addr_location_desc] [varchar](100) NULL,
	[addr_postcode] [varchar](10) NULL,
	[addr_unstruct_line_1] [varchar](100) NULL,
	[addr_unstruct_line_2] [varchar](100) NULL,
	[addr_unstruct_line_3] [varchar](100) NULL,
	[site_class_id] [numeric](18, 0) NULL,
	[site_status_id] [numeric](18, 0) NULL,
	[jurisdiction_id] [numeric](18, 0) NULL,
	[dlf_id] [numeric](18, 0) NULL,
	[user_def_num1] [numeric](16, 4) NULL,
	[user_def_num2] [numeric](16, 4) NULL,
	[user_def_num3] [numeric](16, 4) NULL,
	[default_usage_price_plan_id] [numeric](18, 0) NULL,
	[default_wholesale_price_plan_id] [numeric](18, 0) NULL,
	[address_verified] [varchar](1) NULL,
	[metering_type] [varchar](10) NULL,
	[KVA] [int] NULL,
	[customer_identifier] [varchar](10) NULL,
	[commercial_site] [varchar](1) NULL,
	[site_notes] [varchar](max) NULL,
	[metering_class] [varchar](20) NULL,
	[hazard_desc] [varchar](80) NULL,
	[access_details] [varchar](160) NULL,
	[login_type] [varchar](50) NULL,
	[addr_street_suffix] [varchar](10) NULL,
	[heating_value_zone_id] [numeric](18, 0) NULL,
	[addr_lot_number] [varchar](10) NULL,
	[anniversary_date] [datetime] NULL,
	[hint_question_code] [varchar](20) NULL,
	[hint_answer] [varchar](2000) NULL,
	[isp_domain] [varchar](100) NULL,
	[isp_modem] [varchar](100) NULL,
	[dsl_full_national_no] [varchar](50) NULL,
	[dsl_line_owner] [varchar](100) NULL,
	[dsl_transfer_flag] [varchar](1) NULL,
	[shutoff_code] [varchar](1) NULL,
	[addr_dpid] [varchar](20) NULL,
	[addr_post_code] [varchar](100) NULL,
	[sp_read_request] [varchar](1) NULL,
	[sp_read_date_required] [datetime] NULL,
	[sp_read_notes] [varchar](200) NULL,
	[sp_read_type_code] [varchar](20) NULL,
	[tot_solar_gen] [numeric](18, 4) NULL,
	[reader_route_id] [numeric](18, 0) NULL,
	[addr_state] [varchar](100) NULL,
	[load_profile] [varchar](100) NULL,
	[annual_mwh] [numeric](18, 6) NULL,
	[feeder_class] [varchar](20) NULL,
	[supply_point_id] [varchar](13) NULL,
	[dci_indicator] [varchar](1) NULL,
	[cust_classification_code] [varchar](20) NULL,
	[cust_threshold_code] [varchar](20) NULL,
	[unstruct_disabled] [varchar](1) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_utl_site] PRIMARY KEY CLUSTERED 
(
	[site_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_site_Meta_LatestUpdateId] ON [orion].[utl_site]
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
CREATE TABLE [orion].[utl_site](
	[site_id] [numeric](18, 0) NOT NULL,
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[capacity_id] [numeric](18, 0) NULL,
	[network_id] [numeric](18, 0) NULL,
	[network_node_id] [numeric](18, 0) NULL,
	[seq_product_type_id] [numeric](18, 0) NULL,
	[street_type_id] [numeric](18, 0) NULL,
	[init_read_type_id] [numeric](18, 0) NULL,
	[site_identifier] [varchar](100) NULL,
	[password] [varchar](50) NULL,
	[addr_unit_no] [varchar](20) NULL,
	[addr_street_no] [varchar](20) NULL,
	[addr_street_name] [varchar](50) NULL,
	[addr_property_name] [varchar](100) NULL,
	[addr_suburb] [varchar](100) NULL,
	[addr_city] [varchar](100) NULL,
	[loss_factor] [money] NULL,
	[current_account_id] [numeric](18, 0) NULL,
	[avg_monthly_spend] [money] NULL,
	[def_usage_profile_id] [numeric](18, 0) NULL,
	[user_defined1] [varchar](100) NULL,
	[user_defined2] [varchar](100) NULL,
	[user_defined3] [varchar](100) NULL,
	[addr_struct_flag] [varchar](1) NULL,
	[addr_unit_type] [varchar](20) NULL,
	[addr_floor_type] [varchar](20) NULL,
	[addr_floor_no] [varchar](20) NULL,
	[addr_street_no_suffix] [varchar](20) NULL,
	[addr_location_desc] [varchar](100) NULL,
	[addr_postcode] [varchar](10) NULL,
	[addr_unstruct_line_1] [varchar](100) NULL,
	[addr_unstruct_line_2] [varchar](100) NULL,
	[addr_unstruct_line_3] [varchar](100) NULL,
	[site_class_id] [numeric](18, 0) NULL,
	[site_status_id] [numeric](18, 0) NULL,
	[jurisdiction_id] [numeric](18, 0) NULL,
	[dlf_id] [numeric](18, 0) NULL,
	[user_def_num1] [numeric](16, 4) NULL,
	[user_def_num2] [numeric](16, 4) NULL,
	[user_def_num3] [numeric](16, 4) NULL,
	[default_usage_price_plan_id] [numeric](18, 0) NULL,
	[default_wholesale_price_plan_id] [numeric](18, 0) NULL,
	[address_verified] [varchar](1) NULL,
	[metering_type] [varchar](10) NULL,
	[KVA] [int] NULL,
	[customer_identifier] [varchar](10) NULL,
	[commercial_site] [varchar](1) NULL,
	[site_notes] [varchar](max) NULL,
	[metering_class] [varchar](20) NULL,
	[hazard_desc] [varchar](80) NULL,
	[access_details] [varchar](160) NULL,
	[login_type] [varchar](50) NULL,
	[addr_street_suffix] [varchar](10) NULL,
	[heating_value_zone_id] [numeric](18, 0) NULL,
	[addr_lot_number] [varchar](10) NULL,
	[anniversary_date] [datetime] NULL,
	[hint_question_code] [varchar](20) NULL,
	[hint_answer] [varchar](2000) NULL,
	[isp_domain] [varchar](100) NULL,
	[isp_modem] [varchar](100) NULL,
	[dsl_full_national_no] [varchar](50) NULL,
	[dsl_line_owner] [varchar](100) NULL,
	[dsl_transfer_flag] [varchar](1) NULL,
	[shutoff_code] [varchar](1) NULL,
	[addr_dpid] [varchar](20) NULL,
	[addr_post_code] [varchar](100) NULL,
	[sp_read_request] [varchar](1) NULL,
	[sp_read_date_required] [datetime] NULL,
	[sp_read_notes] [varchar](200) NULL,
	[sp_read_type_code] [varchar](20) NULL,
	[tot_solar_gen] [numeric](18, 4) NULL,
	[reader_route_id] [numeric](18, 0) NULL,
	[addr_state] [varchar](100) NULL,
	[load_profile] [varchar](100) NULL,
	[annual_mwh] [numeric](18, 6) NULL,
	[feeder_class] [varchar](20) NULL,
	[supply_point_id] [varchar](13) NULL,
	[dci_indicator] [varchar](1) NULL,
	[cust_classification_code] [varchar](20) NULL,
	[cust_threshold_code] [varchar](20) NULL,
	[unstruct_disabled] [varchar](1) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_utl_site] PRIMARY KEY CLUSTERED 
(
	[site_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA] TEXTIMAGE_ON [DATA]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_site_Meta_LatestUpdateId] ON [orion].[utl_site]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
