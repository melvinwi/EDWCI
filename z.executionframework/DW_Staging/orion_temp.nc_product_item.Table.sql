USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[nc_product_item](
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_pcms_int_status_id] [numeric](18, 0) NULL,
	[seq_product_id] [numeric](18, 0) NULL,
	[date_connected] [datetime] NULL,
	[seq_product_item_id] [numeric](18, 0) NULL,
	[seq_price_plan_id] [numeric](18, 0) NULL,
	[seq_pp_compare1_id] [numeric](18, 0) NULL,
	[seq_pp_compare2_id] [numeric](18, 0) NULL,
	[site_id] [numeric](18, 0) NULL,
	[contract_term_id] [numeric](18, 0) NULL,
	[accnt_status_id] [numeric](18, 0) NULL,
	[product_identifier] [varchar](50) NULL,
	[date_terminated] [datetime] NULL,
	[date_responsibility_end] [datetime] NULL,
	[contract_start_date] [datetime] NULL,
	[contract_end_date] [datetime] NULL,
	[billed_to_date] [datetime] NULL,
	[commission_paid] [varchar](1) NULL,
	[accnt_status_date] [datetime] NULL,
	[closed_reason_id] [numeric](18, 0) NULL,
	[switch_reason_id] [numeric](18, 0) NULL,
	[pp_simple_sched_id] [numeric](18, 0) NULL,
	[sales_internal_tariff] [varchar](50) NULL,
	[frmp_date] [datetime] NULL,
	[gen_cr_withdrawl] [varchar](1) NULL,
	[cancellation_fee] [numeric](18, 0) NULL,
	[cancel_notes] [varchar](max) NULL,
	[incentive_id] [numeric](18, 0) NULL,
	[term_fee_id] [numeric](18, 0) NULL,
	[tco_id] [numeric](18, 0) NULL,
	[fixed_est_amount] [money] NULL,
	[life_support_acct] [varchar](1) NULL,
	[gift_code] [varchar](30) NULL,
	[gift_sent] [datetime] NULL,
	[smooth_bill] [varchar](1) NULL,
	[green_percent] [numeric](16, 4) NULL,
	[pr_site_id] [numeric](18, 0) NULL,
	[account_type_code] [varchar](20) NULL,
	[min_contract_dmd_kw] [numeric](8, 2) NULL,
	[min_contract_dmd_kva] [numeric](8, 2) NULL,
	[account_name] [varchar](100) NULL,
	[hedge_number] [varchar](50) NULL,
	[master_site] [varchar](1) NULL,
	[move_in_permit_name] [varchar](100) NULL,
	[membership_no] [varchar](100) NULL,
	[de_app_type] [varchar](20) NULL,
	[de_app_id] [numeric](18, 0) NULL,
	[small_usage_com_cust] [varchar](1) NULL,
	[proposed_move_in_date] [datetime] NULL,
	[proposed_move_out_date] [datetime] NULL,
	[transfer_type] [varchar](10) NULL,
	[exclude_auto_meter_access] [varchar](1) NULL,
	[override_debt_obj] [varchar](1) NULL,
	[no_emergency_contact] [varchar](1) NULL,
	[emergency_contact_title] [varchar](20) NULL,
	[emergency_contact_first_name] [varchar](100) NULL,
	[emergency_contact_last_name] [varchar](100) NULL,
	[emergency_contact_std_code] [varchar](4) NULL,
	[emergency_contact_phone_no] [varchar](20) NULL,
	[emergency_contact_phone_type_id] [numeric](18, 0) NULL,
	[emergency_contact_sec_std_code] [varchar](4) NULL,
	[emergency_contact_sec_phone_no] [varchar](20) NULL,
	[emergency_contact_sec_phone_type_id] [numeric](18, 0) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

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
CREATE TABLE [orion_temp].[nc_product_item](
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_pcms_int_status_id] [numeric](18, 0) NULL,
	[seq_product_id] [numeric](18, 0) NULL,
	[date_connected] [datetime] NULL,
	[seq_product_item_id] [numeric](18, 0) NOT NULL,
	[seq_price_plan_id] [numeric](18, 0) NULL,
	[seq_pp_compare1_id] [numeric](18, 0) NULL,
	[seq_pp_compare2_id] [numeric](18, 0) NULL,
	[site_id] [numeric](18, 0) NULL,
	[contract_term_id] [numeric](18, 0) NULL,
	[accnt_status_id] [numeric](18, 0) NULL,
	[product_identifier] [varchar](50) NULL,
	[date_terminated] [datetime] NULL,
	[date_responsibility_end] [datetime] NULL,
	[contract_start_date] [datetime] NULL,
	[contract_end_date] [datetime] NULL,
	[billed_to_date] [datetime] NULL,
	[commission_paid] [varchar](1) NULL,
	[accnt_status_date] [datetime] NULL,
	[closed_reason_id] [numeric](18, 0) NULL,
	[switch_reason_id] [numeric](18, 0) NULL,
	[pp_simple_sched_id] [numeric](18, 0) NULL,
	[sales_internal_tariff] [varchar](50) NULL,
	[frmp_date] [datetime] NULL,
	[gen_cr_withdrawl] [varchar](1) NULL,
	[cancellation_fee] [numeric](18, 0) NULL,
	[cancel_notes] [varchar](max) NULL,
	[incentive_id] [numeric](18, 0) NULL,
	[term_fee_id] [numeric](18, 0) NULL,
	[tco_id] [numeric](18, 0) NULL,
	[fixed_est_amount] [money] NULL,
	[life_support_acct] [varchar](1) NULL,
	[gift_code] [varchar](30) NULL,
	[gift_sent] [datetime] NULL,
	[smooth_bill] [varchar](1) NULL,
	[green_percent] [numeric](16, 4) NULL,
	[pr_site_id] [numeric](18, 0) NULL,
	[account_type_code] [varchar](20) NULL,
	[min_contract_dmd_kw] [numeric](8, 2) NULL,
	[min_contract_dmd_kva] [numeric](8, 2) NULL,
	[account_name] [varchar](100) NULL,
	[hedge_number] [varchar](50) NULL,
	[master_site] [varchar](1) NULL,
	[move_in_permit_name] [varchar](100) NULL,
	[membership_no] [varchar](100) NULL,
	[de_app_type] [varchar](20) NULL,
	[de_app_id] [numeric](18, 0) NULL,
	[small_usage_com_cust] [varchar](1) NULL,
	[proposed_move_in_date] [datetime] NULL,
	[proposed_move_out_date] [datetime] NULL,
	[transfer_type] [varchar](10) NULL,
	[exclude_auto_meter_access] [varchar](1) NULL,
	[override_debt_obj] [varchar](1) NULL,
	[no_emergency_contact] [varchar](1) NULL,
	[emergency_contact_title] [varchar](20) NULL,
	[emergency_contact_first_name] [varchar](100) NULL,
	[emergency_contact_last_name] [varchar](100) NULL,
	[emergency_contact_std_code] [varchar](4) NULL,
	[emergency_contact_phone_no] [varchar](20) NULL,
	[emergency_contact_phone_type_id] [numeric](18, 0) NULL,
	[emergency_contact_sec_std_code] [varchar](4) NULL,
	[emergency_contact_sec_phone_no] [varchar](20) NULL,
	[emergency_contact_sec_phone_type_id] [numeric](18, 0) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA] TEXTIMAGE_ON [DATA]

GO
SET ANSI_PADDING OFF
GO
