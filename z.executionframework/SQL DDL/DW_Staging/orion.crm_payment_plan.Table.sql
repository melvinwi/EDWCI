USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[crm_payment_plan](
	[pplan_id] [numeric](18, 0) NOT NULL,
	[seq_party_id] [numeric](18, 0) NULL,
	[pplan_adj_id] [numeric](18, 0) NULL,
	[pplan_amt] [money] NULL,
	[pplan_start_date] [datetime] NULL,
	[pplan_frequency] [numeric](18, 0) NULL,
	[pplan_install_periods] [numeric](18, 0) NULL,
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[pplan_status] [varchar](10) NULL,
	[confirm_printed] [varchar](1) NULL,
	[cancel_printed] [varchar](1) NULL,
	[pplan_type] [varchar](20) NULL,
	[paying_promptly] [varchar](1) NULL,
	[paying_promptly_update] [datetime] NULL,
	[all_incentive_given] [varchar](1) NULL,
	[centrelink_crn_number] [varchar](10) NULL,
	[centrelink_payment_type] [varchar](10) NULL,
	[pplan_type_id] [numeric](18, 0) NULL,
	[incentive_freq] [int] NULL,
	[incentive_ext] [int] NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_crm_payment_plan] PRIMARY KEY CLUSTERED 
(
	[pplan_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_crm_payment_plan_Meta_LatestUpdateId] ON [orion].[crm_payment_plan]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
