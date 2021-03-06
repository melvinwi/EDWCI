USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[crm_district](
	[district_id] [numeric](18, 0) NOT NULL,
	[district_code] [varchar](20) NULL,
	[district_desc] [varchar](50) NULL,
	[district_bitmap] [varchar](250) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[company_name] [varchar](100) NULL,
	[company_abn_number] [varchar](25) NULL,
	[company_phone_number] [varchar](30) NULL,
	[company_fax_number] [varchar](30) NULL,
	[company_web_site] [varchar](100) NULL,
	[invoice_logo_header_image_file] [varchar](100) NULL,
	[invoice_remittance_image_file] [varchar](100) NULL,
	[postal_addr1] [varchar](100) NULL,
	[postal_addr2] [varchar](100) NULL,
	[postal_addr3] [varchar](100) NULL,
	[email_address] [varchar](100) NULL,
	[power_juristiction_code] [varchar](10) NULL,
	[gas_juristiction_code] [varchar](10) NULL,
	[post_payment_addr1] [varchar](100) NULL,
	[post_payment_addr2] [varchar](100) NULL,
	[post_payment_addr3] [varchar](100) NULL,
	[power_frmp_code] [varchar](15) NULL,
	[gas_frmp_code] [varchar](15) NULL,
	[power_login] [varchar](20) NULL,
	[gas_login] [varchar](20) NULL,
	[nemmco_inbox] [varchar](200) NULL,
	[nemmco_outbox] [varchar](200) NULL,
	[nemmco_report_inbox] [varchar](200) NULL,
	[nemmco_report_outbox] [varchar](200) NULL,
	[vencorp_inbox] [varchar](200) NULL,
	[vencorp_outbox] [varchar](200) NULL,
	[orion_inbox] [varchar](200) NULL,
	[orion_outbox] [varchar](200) NULL,
	[power_emission_factor] [decimal](12, 4) NULL,
	[gas_emission_factor] [decimal](12, 4) NULL,
	[process_power] [varchar](1) NULL,
	[process_gas] [varchar](1) NULL,
	[ombudsman_phone_num] [varchar](30) NULL,
	[orion_gen_override] [varchar](1) NULL,
	[country] [varchar](50) NULL,
	[tax_rate] [numeric](16, 4) NULL,
	[gen_power] [varchar](1) NULL,
	[gen_gas] [varchar](1) NULL,
	[auspost_vendor_no] [varchar](20) NULL,
	[cheque_no] [numeric](18, 0) NULL,
	[ewov_inv_msg] [varchar](1) NULL,
	[grmco_inbox] [varchar](200) NULL,
	[grmco_outbox] [varchar](200) NULL,
	[grmco_xml_inbox] [varchar](200) NULL,
	[grmco_xml_outbox] [varchar](200) NULL,
	[alt_directory] [varchar](100) NULL,
	[Pay_interest_on_bond] [varchar](1) NULL,
	[seq_colour_id] [numeric](18, 0) NULL,
	[cool_off_days] [numeric](18, 0) NULL,
	[alt_cool_off_days] [numeric](18, 0) NULL,
	[def_inv_due_bus_days] [numeric](18, 0) NULL,
	[timezone_shift] [numeric](16, 2) NULL,
	[active_billing] [varchar](1) NULL,
	[full_company_name] [varchar](200) NULL,
	[company_hours] [varchar](100) NULL,
	[power_min_cons_start] [numeric](18, 0) NULL,
	[gas_min_cons_start] [numeric](18, 0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [pk_crm_district] PRIMARY KEY CLUSTERED 
(
	[district_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_crm_district_Meta_LatestUpdateId] ON [orion].[crm_district]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
