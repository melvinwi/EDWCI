USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_total_customer_offering](
	[tco_id] [numeric](18, 0) NOT NULL,
	[induce_id] [numeric](18, 0) NULL,
	[tco_code] [varchar](20) NULL,
	[tco_desc] [varchar](100) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[invoice_message] [varchar](max) NULL,
	[default_billing_cycle_id] [numeric](18, 0) NULL,
	[default_treat_type_id] [numeric](18, 0) NULL,
	[penalty_id] [numeric](18, 0) NULL,
	[cust_type] [varchar](10) NULL,
	[default_contract_term_id] [numeric](18, 0) NULL,
	[inv_due_days] [numeric](18, 0) NULL,
	[default_occupier] [varchar](1) NULL,
	[ntc_cat_id] [numeric](18, 0) NULL,
	[fixed_tariff_adjust_percent] [numeric](8, 2) NULL,
	[variable_tariff_adjust_percent] [numeric](8, 2) NULL,
	[online_only_yn] [varchar](1) NULL,
	[default_occupier_commercial] [varchar](1) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[standing_offer_resi] [varchar](1) NULL,
	[standing_offer_com] [varchar](1) NULL,
	[tco_category_id] [numeric](18, 0) NULL,
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
CREATE TABLE [orion_temp].[utl_total_customer_offering](
	[tco_id] [numeric](18, 0) NOT NULL,
	[induce_id] [numeric](18, 0) NULL,
	[tco_code] [varchar](20) NULL,
	[tco_desc] [varchar](100) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[invoice_message] [varchar](max) NULL,
	[default_billing_cycle_id] [numeric](18, 0) NULL,
	[default_treat_type_id] [numeric](18, 0) NULL,
	[penalty_id] [numeric](18, 0) NULL,
	[cust_type] [varchar](10) NULL,
	[default_contract_term_id] [numeric](18, 0) NULL,
	[inv_due_days] [numeric](18, 0) NULL,
	[default_occupier] [varchar](1) NULL,
	[ntc_cat_id] [numeric](18, 0) NULL,
	[fixed_tariff_adjust_percent] [numeric](8, 2) NULL,
	[variable_tariff_adjust_percent] [numeric](8, 2) NULL,
	[online_only_yn] [varchar](1) NULL,
	[default_occupier_commercial] [varchar](1) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[standing_offer_resi] [varchar](1) NULL,
	[standing_offer_com] [varchar](1) NULL,
	[tco_category_id] [numeric](18, 0) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA] TEXTIMAGE_ON [DATA]

GO
SET ANSI_PADDING OFF
GO
