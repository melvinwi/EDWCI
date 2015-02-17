USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[utl_concession](
	[concession_id] [numeric](18, 0) NOT NULL,
	[price_plan_id] [numeric](18, 0) NULL,
	[concession_type_id] [numeric](18, 0) NULL,
	[seq_product_type_id] [numeric](18, 0) NULL,
	[concession_code] [varchar](10) NULL,
	[concession_desc] [varchar](100) NULL,
	[discount_pct] [numeric](18, 4) NULL,
	[consumption_cap] [numeric](18, 4) NULL,
	[concessions_per_year] [int] NULL,
	[concession_amount] [money] NULL,
	[start_period] [datetime] NULL,
	[end_period] [datetime] NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[admin_rate] [money] NULL,
	[district_id] [numeric](18, 0) NULL,
	[seq_account_id] [numeric](18, 0) NULL,
	[network_id] [numeric](18, 0) NULL,
	[ls_machine_type_code] [varchar](20) NULL,
	[manual_trans] [varchar](10) NULL,
	[inc_discounts] [varchar](1) NULL,
	[inc_solar_cal] [varchar](1) NULL,
	[capping] [varchar](1) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [pk_utl_concession] PRIMARY KEY CLUSTERED 
(
	[concession_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_concession_Meta_LatestUpdateId] ON [orion].[utl_concession]
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
CREATE TABLE [orion].[utl_concession](
	[concession_id] [numeric](18, 0) NOT NULL,
	[price_plan_id] [numeric](18, 0) NULL,
	[concession_type_id] [numeric](18, 0) NULL,
	[seq_product_type_id] [numeric](18, 0) NULL,
	[concession_code] [varchar](10) NULL,
	[concession_desc] [varchar](100) NULL,
	[discount_pct] [numeric](18, 4) NULL,
	[consumption_cap] [numeric](18, 4) NULL,
	[concessions_per_year] [int] NULL,
	[concession_amount] [money] NULL,
	[start_period] [datetime] NULL,
	[end_period] [datetime] NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[admin_rate] [money] NULL,
	[district_id] [numeric](18, 0) NULL,
	[seq_account_id] [numeric](18, 0) NULL,
	[network_id] [numeric](18, 0) NULL,
	[ls_machine_type_code] [varchar](20) NULL,
	[manual_trans] [varchar](10) NULL,
	[inc_discounts] [varchar](1) NULL,
	[inc_solar_cal] [varchar](1) NULL,
	[capping] [varchar](1) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [pk_utl_concession] PRIMARY KEY CLUSTERED 
(
	[concession_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_concession_Meta_LatestUpdateId] ON [orion].[utl_concession]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
