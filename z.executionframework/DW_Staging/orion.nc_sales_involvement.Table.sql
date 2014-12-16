USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[nc_sales_involvement](
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
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [pk_nc_sales_involvement] PRIMARY KEY CLUSTERED 
(
	[seq_party_id] ASC,
	[seq_involve_type_id] ASC,
	[seq_product_id] ASC,
	[seq_product_item_id] ASC,
	[sales_complete] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_nc_sales_involvement_Meta_LatestUpdateId] ON [orion].[nc_sales_involvement]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
