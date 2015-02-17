USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[crm_party](
	[seq_party_id] [numeric](18, 0) NOT NULL,
	[party_code] [varchar](10) NULL,
	[party_name] [varchar](100) NULL,
	[first_name] [varchar](100) NULL,
	[last_name] [varchar](100) NULL,
	[initials] [varchar](10) NULL,
	[title] [varchar](10) NULL,
	[job_title] [varchar](100) NULL,
	[notes] [varchar](max) NULL,
	[multi_lock_flag] [varchar](1) NULL,
	[phone_no] [varchar](20) NULL,
	[fax_no] [varchar](20) NULL,
	[mobile_no] [varchar](20) NULL,
	[email_address] [varchar](100) NULL,
	[web_address] [varchar](100) NULL,
	[street_addr_no] [varchar](20) NULL,
	[street_addr_1] [varchar](100) NULL,
	[street_addr_2] [varchar](100) NULL,
	[street_addr_3] [varchar](100) NULL,
	[street_addr_4] [varchar](100) NULL,
	[street_addr_5] [varchar](100) NULL,
	[street_post_code] [varchar](10) NULL,
	[postal_addr_1] [varchar](100) NULL,
	[postal_addr_2] [varchar](100) NULL,
	[postal_addr_3] [varchar](100) NULL,
	[postal_addr_4] [varchar](100) NULL,
	[postal_addr_5] [varchar](100) NULL,
	[postal_post_code] [varchar](10) NULL,
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_role_id] [numeric](18, 0) NULL,
	[home_phone_no] [varchar](20) NULL,
	[std_code] [varchar](4) NULL,
	[user_defined_1] [varchar](100) NULL,
	[user_defined_2] [varchar](100) NULL,
	[user_defined_3] [varchar](100) NULL,
	[user_defined_4] [varchar](100) NULL,
	[user_defined_5] [varchar](100) NULL,
	[date_of_birth] [datetime] NULL,
	[drivers_licence] [varchar](50) NULL,
	[dlisence_expiry_date] [datetime] NULL,
	[cust_id_type1] [varchar](10) NULL,
	[cust_id_code1] [varchar](30) NULL,
	[cust_id_expiry1] [datetime] NULL,
	[cust_id_type2] [varchar](20) NULL,
	[cust_id_code2] [varchar](30) NULL,
	[cust_id_expiry2] [datetime] NULL,
	[logon_date] [datetime] NULL,
	[commn_sales_type_id] [numeric](18, 0) NULL,
	[commn_team_leader_id] [numeric](18, 0) NULL,
	[max_call] [numeric](18, 0) NULL,
	[postal_addr_no] [varchar](20) NULL,
	[postal_addr_name] [varchar](100) NULL,
	[postal_addr_6] [varchar](100) NULL,
	[postal_addr_dpid] [varchar](100) NULL,
	[street_addr_dpid] [varchar](100) NULL,
	[postal_addr_unit] [varchar](100) NULL,
	[postal_addr_building] [varchar](100) NULL,
	[street_addr_unit] [varchar](100) NULL,
	[street_addr_building] [varchar](100) NULL,
	[middle_names] [varchar](100) NULL,
	[prev_last_name] [varchar](100) NULL,
	[gender] [varchar](1) NULL,
	[language_id] [numeric](18, 0) NULL,
	[correspondence_name] [varchar](100) NULL,
	[trading_name] [varchar](100) NULL,
	[trustee_name] [varchar](100) NULL,
	[override_corr] [varchar](1) NULL,
	[oss_login] [varchar](100) NULL,
	[oss_pass] [binary](100) NULL,
	[oss_active] [varchar](1) NULL,
	[primary_phone_type_id] [numeric](18, 0) NULL,
	[secondary_phone_no] [varchar](20) NULL,
	[secondary_std_code] [varchar](4) NULL,
	[secondary_phone_type_id] [numeric](18, 0) NULL,
	[phone_no_not_known] [varchar](1) NULL,
	[international_phone_check] [varchar](1) NULL,
	[international_phone_no] [varchar](30) NULL,
	[referal_partner] [varchar](20) NULL,
	[partner_reference] [varchar](20) NULL,
	[max_meter_reads] [numeric](18, 0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_crm_party] PRIMARY KEY CLUSTERED 
(
	[seq_party_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_crm_party_Meta_LatestUpdateId] ON [orion].[crm_party]
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
CREATE TABLE [orion].[crm_party](
	[seq_party_id] [numeric](18, 0) NOT NULL,
	[party_code] [varchar](10) NULL,
	[party_name] [varchar](100) NULL,
	[first_name] [varchar](100) NULL,
	[last_name] [varchar](100) NULL,
	[initials] [varchar](10) NULL,
	[title] [varchar](10) NULL,
	[job_title] [varchar](100) NULL,
	[notes] [varchar](max) NULL,
	[multi_lock_flag] [varchar](1) NULL,
	[phone_no] [varchar](20) NULL,
	[fax_no] [varchar](20) NULL,
	[mobile_no] [varchar](20) NULL,
	[email_address] [varchar](100) NULL,
	[web_address] [varchar](100) NULL,
	[street_addr_no] [varchar](20) NULL,
	[street_addr_1] [varchar](100) NULL,
	[street_addr_2] [varchar](100) NULL,
	[street_addr_3] [varchar](100) NULL,
	[street_addr_4] [varchar](100) NULL,
	[street_addr_5] [varchar](100) NULL,
	[street_post_code] [varchar](10) NULL,
	[postal_addr_1] [varchar](100) NULL,
	[postal_addr_2] [varchar](100) NULL,
	[postal_addr_3] [varchar](100) NULL,
	[postal_addr_4] [varchar](100) NULL,
	[postal_addr_5] [varchar](100) NULL,
	[postal_post_code] [varchar](10) NULL,
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_role_id] [numeric](18, 0) NULL,
	[home_phone_no] [varchar](20) NULL,
	[std_code] [varchar](4) NULL,
	[user_defined_1] [varchar](100) NULL,
	[user_defined_2] [varchar](100) NULL,
	[user_defined_3] [varchar](100) NULL,
	[user_defined_4] [varchar](100) NULL,
	[user_defined_5] [varchar](100) NULL,
	[date_of_birth] [datetime] NULL,
	[drivers_licence] [varchar](50) NULL,
	[dlisence_expiry_date] [datetime] NULL,
	[cust_id_type1] [varchar](10) NULL,
	[cust_id_code1] [varchar](30) NULL,
	[cust_id_expiry1] [datetime] NULL,
	[cust_id_type2] [varchar](20) NULL,
	[cust_id_code2] [varchar](30) NULL,
	[cust_id_expiry2] [datetime] NULL,
	[logon_date] [datetime] NULL,
	[commn_sales_type_id] [numeric](18, 0) NULL,
	[commn_team_leader_id] [numeric](18, 0) NULL,
	[max_call] [numeric](18, 0) NULL,
	[postal_addr_no] [varchar](20) NULL,
	[postal_addr_name] [varchar](100) NULL,
	[postal_addr_6] [varchar](100) NULL,
	[postal_addr_dpid] [varchar](100) NULL,
	[street_addr_dpid] [varchar](100) NULL,
	[postal_addr_unit] [varchar](100) NULL,
	[postal_addr_building] [varchar](100) NULL,
	[street_addr_unit] [varchar](100) NULL,
	[street_addr_building] [varchar](100) NULL,
	[middle_names] [varchar](100) NULL,
	[prev_last_name] [varchar](100) NULL,
	[gender] [varchar](1) NULL,
	[language_id] [numeric](18, 0) NULL,
	[correspondence_name] [varchar](100) NULL,
	[trading_name] [varchar](100) NULL,
	[trustee_name] [varchar](100) NULL,
	[override_corr] [varchar](1) NULL,
	[oss_login] [varchar](100) NULL,
	[oss_pass] [binary](100) NULL,
	[oss_active] [varchar](1) NULL,
	[primary_phone_type_id] [numeric](18, 0) NULL,
	[secondary_phone_no] [varchar](20) NULL,
	[secondary_std_code] [varchar](4) NULL,
	[secondary_phone_type_id] [numeric](18, 0) NULL,
	[phone_no_not_known] [varchar](1) NULL,
	[international_phone_check] [varchar](1) NULL,
	[international_phone_no] [varchar](30) NULL,
	[referal_partner] [varchar](20) NULL,
	[partner_reference] [varchar](20) NULL,
	[max_meter_reads] [numeric](18, 0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_crm_party] PRIMARY KEY CLUSTERED 
(
	[seq_party_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA] TEXTIMAGE_ON [DATA]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_crm_party_Meta_LatestUpdateId] ON [orion].[crm_party]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
