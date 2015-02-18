USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[utl_network](
	[network_id] [numeric](18, 0) NOT NULL,
	[network_code] [varchar](10) NULL,
	[network_desc] [varchar](100) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_product_type_id] [numeric](18, 0) NULL,
	[default_option] [char](1) NULL,
	[bank] [varchar](20) NULL,
	[bank_branch] [varchar](20) NULL,
	[bank_account_no] [varchar](18) NULL,
	[faults_ph_no] [varchar](20) NULL,
	[user_defined_1] [varchar](100) NULL,
	[user_defined_2] [varchar](100) NULL,
	[user_defined_3] [varchar](100) NULL,
	[user_defined_4] [varchar](100) NULL,
	[default_wholesale_price_plan_id] [numeric](18, 0) NULL,
	[default_MDP] [numeric](18, 0) NULL,
	[expected_nmi_prefix] [varchar](100) NULL,
	[dd_number] [varchar](6) NULL,
	[trace_record] [varchar](16) NULL,
	[default_wholesale_commercial_id] [numeric](18, 0) NULL,
	[cc_merchant_number] [varchar](8) NULL,
	[alt_nmi_prefix] [varchar](100) NULL,
	[district_id] [numeric](18, 0) NULL,
	[network_participant_id] [numeric](18, 0) NULL,
	[market_interface_code] [varchar](20) NULL,
	[duns_no] [varchar](100) NULL,
	[contact_addr_line_1] [varchar](100) NULL,
	[contact_addr_line_2] [varchar](100) NULL,
	[contact_addr_line_3] [varchar](100) NULL,
	[contact_addr_line_4] [varchar](100) NULL,
	[contact_addr_line_5] [varchar](100) NULL,
	[contact_post_code] [varchar](10) NULL,
	[contact_name] [varchar](200) NULL,
	[contact_email] [varchar](100) NULL,
	[contact_ph_no] [varchar](20) NULL,
	[contact_fax_no] [varchar](20) NULL,
	[alt_cc_merchant_number] [varchar](10) NULL,
	[heat_advisory_start_date] [datetime] NULL,
	[heat_advisory_end_date] [datetime] NULL,
	[network_short_desc] [varchar](100) NULL,
	[local_time_processing] [varchar](20) NULL,
	[tco_active] [varchar](1) NULL,
	[bus_hour_start] [numeric](18, 0) NULL,
	[bus_hour_end] [numeric](18, 0) NULL,
	[non_bus_hour_start] [numeric](18, 0) NULL,
	[non_bus_hour_end] [numeric](18, 0) NULL,
	[show_bm_data] [varchar](1) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_utl_network] PRIMARY KEY CLUSTERED 
(
	[network_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_network_Meta_LatestUpdateId] ON [orion].[utl_network]
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
CREATE TABLE [orion].[utl_network](
	[network_id] [numeric](18, 0) NOT NULL,
	[network_code] [varchar](10) NULL,
	[network_desc] [varchar](100) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_product_type_id] [numeric](18, 0) NULL,
	[default_option] [char](1) NULL,
	[bank] [varchar](20) NULL,
	[bank_branch] [varchar](20) NULL,
	[bank_account_no] [varchar](18) NULL,
	[faults_ph_no] [varchar](20) NULL,
	[user_defined_1] [varchar](100) NULL,
	[user_defined_2] [varchar](100) NULL,
	[user_defined_3] [varchar](100) NULL,
	[user_defined_4] [varchar](100) NULL,
	[default_wholesale_price_plan_id] [numeric](18, 0) NULL,
	[default_MDP] [numeric](18, 0) NULL,
	[expected_nmi_prefix] [varchar](100) NULL,
	[dd_number] [varchar](6) NULL,
	[trace_record] [varchar](16) NULL,
	[default_wholesale_commercial_id] [numeric](18, 0) NULL,
	[cc_merchant_number] [varchar](8) NULL,
	[alt_nmi_prefix] [varchar](100) NULL,
	[district_id] [numeric](18, 0) NULL,
	[network_participant_id] [numeric](18, 0) NULL,
	[market_interface_code] [varchar](20) NULL,
	[duns_no] [varchar](100) NULL,
	[contact_addr_line_1] [varchar](100) NULL,
	[contact_addr_line_2] [varchar](100) NULL,
	[contact_addr_line_3] [varchar](100) NULL,
	[contact_addr_line_4] [varchar](100) NULL,
	[contact_addr_line_5] [varchar](100) NULL,
	[contact_post_code] [varchar](10) NULL,
	[contact_name] [varchar](200) NULL,
	[contact_email] [varchar](100) NULL,
	[contact_ph_no] [varchar](20) NULL,
	[contact_fax_no] [varchar](20) NULL,
	[alt_cc_merchant_number] [varchar](10) NULL,
	[heat_advisory_start_date] [datetime] NULL,
	[heat_advisory_end_date] [datetime] NULL,
	[network_short_desc] [varchar](100) NULL,
	[local_time_processing] [varchar](20) NULL,
	[tco_active] [varchar](1) NULL,
	[bus_hour_start] [numeric](18, 0) NULL,
	[bus_hour_end] [numeric](18, 0) NULL,
	[non_bus_hour_start] [numeric](18, 0) NULL,
	[non_bus_hour_end] [numeric](18, 0) NULL,
	[show_bm_data] [varchar](1) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_utl_network] PRIMARY KEY CLUSTERED 
(
	[network_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_network_Meta_LatestUpdateId] ON [orion].[utl_network]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
