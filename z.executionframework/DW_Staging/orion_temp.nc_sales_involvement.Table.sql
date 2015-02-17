USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[nc_sales_involvement](
	[seq_party_id] [numeric](18, 0) NULL,
	[seq_involve_type_id] [numeric](18, 0) NULL,
	[seq_product_id] [numeric](18, 0) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_product_item_id] [numeric](18, 0) NULL,
	[voice_ver_date] [datetime] NULL,
	[voice_ver_extn] [varchar](50) NULL,
	[sales_complete] [datetime] NULL,
	[sales_team_leader_id] [numeric](18, 0) NULL,
	[contract_signature] [char](1) NULL,
	[pr_campaign_id] [numeric](18, 0) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data]

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
CREATE TABLE [orion_temp].[nc_sales_involvement](
	[seq_party_id] [numeric](18, 0) NOT NULL,
	[seq_involve_type_id] [numeric](18, 0) NOT NULL,
	[seq_product_id] [numeric](18, 0) NOT NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_product_item_id] [numeric](18, 0) NOT NULL,
	[voice_ver_date] [datetime] NULL,
	[voice_ver_extn] [varchar](50) NULL,
	[sales_complete] [datetime] NOT NULL,
	[sales_team_leader_id] [numeric](18, 0) NULL,
	[contract_signature] [char](1) NULL,
	[pr_campaign_id] [numeric](18, 0) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
