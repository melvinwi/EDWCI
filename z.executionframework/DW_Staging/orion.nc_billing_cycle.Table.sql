USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[nc_billing_cycle](
	[seq_bill_cycle_id] [numeric](18, 0) NOT NULL,
	[bill_cycle_code] [varchar](10) NULL,
	[bill_cycle_desc] [varchar](100) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[atb_base_date] [datetime] NULL,
	[actual_reads_only] [varchar](1) NULL,
	[day_of_month] [int] NULL,
	[over_estimation_percent] [numeric](6, 3) NULL,
	[min_usage_days] [numeric](18, 0) NULL,
	[def_inv_due_bus_days] [numeric](18, 0) NULL,
	[district_code] [varchar](20) NULL,
	[invoice_adj_only] [varchar](1) NULL,
	[init_min_usage_days] [numeric](18, 0) NULL,
	[inv_smoothing_min_usage_days] [numeric](18, 0) NULL,
	[oss_description] [varchar](100) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_nc_billing_cycle] PRIMARY KEY CLUSTERED 
(
	[seq_bill_cycle_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
