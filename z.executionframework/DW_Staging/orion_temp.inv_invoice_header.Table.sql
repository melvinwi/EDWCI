USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[inv_invoice_header](
	[seq_invoice_header_id] [numeric](18, 0) NULL,
	[seq_message_id] [numeric](18, 0) NULL,
	[seq_form_id] [numeric](18, 0) NULL,
	[seq_party_id] [numeric](18, 0) NULL,
	[contact_party_id] [numeric](18, 0) NULL,
	[seq_invoice_run_id] [numeric](18, 0) NULL,
	[seq_doc_id] [numeric](18, 0) NULL,
	[seq_merge_id] [numeric](18, 0) NULL,
	[seq_deliver_class_id] [numeric](18, 0) NULL,
	[invoice_reference] [varchar](40) NULL,
	[invoice_amount] [money] NULL,
	[tax_amount] [money] NULL,
	[prompt_payment_disc] [money] NULL,
	[opening_balance] [money] NULL,
	[transaction_total] [money] NULL,
	[any_text1] [varchar](100) NULL,
	[any_num1] [money] NULL,
	[any_text2] [varchar](100) NULL,
	[any_num2] [money] NULL,
	[any_text3] [varchar](100) NULL,
	[any_num3] [money] NULL,
	[any_text4] [varchar](100) NULL,
	[any_num4] [money] NULL,
	[exported] [varchar](1) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[no_of_pages] [int] NULL,
	[reversal] [varchar](1) NULL,
	[invoice_date] [datetime] NULL,
	[inv_due_date] [datetime] NULL,
	[inv_direct_debit_date] [datetime] NULL,
	[concession_amount] [money] NULL,
	[give_concession] [varchar](1) NULL,
	[emailed_invoice] [varchar](1) NULL,
	[non_rebate_net_amount] [money] NULL,
	[reversal_seq_invoice_header_id] [numeric](18, 0) NULL,
	[cust_invoice_count] [numeric](6, 0) NULL,
	[pp_message] [varchar](1) NULL,
	[inv_tou] [varchar](1) NULL,
	[inv_power] [varchar](1) NULL,
	[inv_gas] [varchar](1) NULL,
	[inv_isp] [varchar](1) NULL,
	[inv_telco] [varchar](1) NULL,
	[inv_water] [varchar](1) NULL,
	[inv_mobile] [varchar](1) NULL,
	[bill_type_message] [varchar](50) NULL,
	[concession_flag] [varchar](1) NULL,
	[deliver_method_code] [varchar](10) NULL,
	[green_energy] [varchar](1) NULL,
	[show_green_logo] [varchar](1) NULL,
	[show_green_graph] [varchar](1) NULL,
	[green_percent] [numeric](18, 2) NULL,
	[adjustment_total] [numeric](10, 2) NULL,
	[charge_only_bill] [varchar](1) NULL,
	[form_datawindow] [varchar](100) NULL,
	[root_dir] [varchar](50) NULL,
	[pull_dir] [varchar](100) NULL,
	[force_multi] [varchar](30) NULL,
	[district_code] [varchar](20) NULL,
	[allow_custom_dir] [varchar](1) NULL,
	[deliver_mode] [varchar](20) NULL,
	[pull_until] [datetime] NULL,
	[smart_bill_code] [varchar](20) NULL,
	[on_payment_plan] [varchar](1) NULL,
	[min_pplan_message_id] [numeric](18, 0) NULL,
	[min_period_id] [numeric](18, 0) NULL,
	[total_accumulated_cons] [numeric](18, 6) NULL,
	[invoice_message] [varchar](max) NULL,
	[final_acct] [char](1) NULL,
	[final_acct_refund] [char](1) NULL,
	[air_points] [numeric](18, 0) NULL,
	[doc_print_sched_id] [numeric](18, 0) NULL,
	[start_index_read] [numeric](18, 6) NULL,
	[end_index_read_date] [datetime] NULL,
	[start_index_read_date] [datetime] NULL,
	[reprint_invoice] [varchar](1) NULL,
	[online_pay_number] [varchar](100) NULL,
	[print_attempts] [numeric](18, 0) NULL,
	[reversal_inv_group] [numeric](18, 0) NULL,
	[reversal_reason_id] [numeric](18, 0) NULL,
	[reversal_details] [varchar](2000) NULL,
	[reversal_sys_user_id] [numeric](18, 0) NULL,
	[reversal_seq_activity_id] [numeric](18, 0) NULL,
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
CREATE TABLE [orion_temp].[inv_invoice_header](
	[seq_invoice_header_id] [numeric](18, 0) NOT NULL,
	[seq_message_id] [numeric](18, 0) NULL,
	[seq_form_id] [numeric](18, 0) NULL,
	[seq_party_id] [numeric](18, 0) NULL,
	[contact_party_id] [numeric](18, 0) NULL,
	[seq_invoice_run_id] [numeric](18, 0) NULL,
	[seq_doc_id] [numeric](18, 0) NULL,
	[seq_merge_id] [numeric](18, 0) NULL,
	[seq_deliver_class_id] [numeric](18, 0) NULL,
	[invoice_reference] [varchar](40) NULL,
	[invoice_amount] [money] NULL,
	[tax_amount] [money] NULL,
	[prompt_payment_disc] [money] NULL,
	[opening_balance] [money] NULL,
	[transaction_total] [money] NULL,
	[any_text1] [varchar](100) NULL,
	[any_num1] [money] NULL,
	[any_text2] [varchar](100) NULL,
	[any_num2] [money] NULL,
	[any_text3] [varchar](100) NULL,
	[any_num3] [money] NULL,
	[any_text4] [varchar](100) NULL,
	[any_num4] [money] NULL,
	[exported] [varchar](1) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[no_of_pages] [int] NULL,
	[reversal] [varchar](1) NULL,
	[invoice_date] [datetime] NULL,
	[inv_due_date] [datetime] NULL,
	[inv_direct_debit_date] [datetime] NULL,
	[concession_amount] [money] NULL,
	[give_concession] [varchar](1) NULL,
	[emailed_invoice] [varchar](1) NULL,
	[non_rebate_net_amount] [money] NULL,
	[reversal_seq_invoice_header_id] [numeric](18, 0) NULL,
	[cust_invoice_count] [numeric](6, 0) NULL,
	[pp_message] [varchar](1) NULL,
	[inv_tou] [varchar](1) NULL,
	[inv_power] [varchar](1) NULL,
	[inv_gas] [varchar](1) NULL,
	[inv_isp] [varchar](1) NULL,
	[inv_telco] [varchar](1) NULL,
	[inv_water] [varchar](1) NULL,
	[inv_mobile] [varchar](1) NULL,
	[bill_type_message] [varchar](50) NULL,
	[concession_flag] [varchar](1) NULL,
	[deliver_method_code] [varchar](10) NULL,
	[green_energy] [varchar](1) NULL,
	[show_green_logo] [varchar](1) NULL,
	[show_green_graph] [varchar](1) NULL,
	[green_percent] [numeric](18, 2) NULL,
	[adjustment_total] [numeric](10, 2) NULL,
	[charge_only_bill] [varchar](1) NULL,
	[form_datawindow] [varchar](100) NULL,
	[root_dir] [varchar](50) NULL,
	[pull_dir] [varchar](100) NULL,
	[force_multi] [varchar](30) NULL,
	[district_code] [varchar](20) NULL,
	[allow_custom_dir] [varchar](1) NULL,
	[deliver_mode] [varchar](20) NULL,
	[pull_until] [datetime] NULL,
	[smart_bill_code] [varchar](20) NULL,
	[on_payment_plan] [varchar](1) NULL,
	[min_pplan_message_id] [numeric](18, 0) NULL,
	[min_period_id] [numeric](18, 0) NULL,
	[total_accumulated_cons] [numeric](18, 6) NULL,
	[invoice_message] [varchar](max) NULL,
	[final_acct] [char](1) NULL,
	[final_acct_refund] [char](1) NULL,
	[air_points] [numeric](18, 0) NULL,
	[doc_print_sched_id] [numeric](18, 0) NULL,
	[start_index_read] [numeric](18, 6) NULL,
	[end_index_read_date] [datetime] NULL,
	[start_index_read_date] [datetime] NULL,
	[reprint_invoice] [varchar](1) NULL,
	[online_pay_number] [varchar](100) NULL,
	[print_attempts] [numeric](18, 0) NULL,
	[reversal_inv_group] [numeric](18, 0) NULL,
	[reversal_reason_id] [numeric](18, 0) NULL,
	[reversal_details] [varchar](2000) NULL,
	[reversal_sys_user_id] [numeric](18, 0) NULL,
	[reversal_seq_activity_id] [numeric](18, 0) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA] TEXTIMAGE_ON [DATA]

GO
SET ANSI_PADDING OFF
GO
