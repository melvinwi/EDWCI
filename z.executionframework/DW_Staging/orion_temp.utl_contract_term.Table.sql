USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_contract_term](
	[contract_term_id] [numeric](18, 0) NULL,
	[contract_term_code] [varchar](10) NULL,
	[contract_term_desc] [varchar](100) NULL,
	[no_of_months] [int] NULL,
	[open_term] [char](1) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[default_option] [char](1) NULL,
	[isp_ft_charge_item_id] [numeric](18, 0) NULL,
	[isp_nc_charge_item_id] [numeric](18, 0) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY]

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
CREATE TABLE [orion_temp].[utl_contract_term](
	[contract_term_id] [numeric](18, 0) NOT NULL,
	[contract_term_code] [varchar](10) NULL,
	[contract_term_desc] [varchar](100) NULL,
	[no_of_months] [int] NULL,
	[open_term] [char](1) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[default_option] [char](1) NULL,
	[isp_ft_charge_item_id] [numeric](18, 0) NULL,
	[isp_nc_charge_item_id] [numeric](18, 0) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
