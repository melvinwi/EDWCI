USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[utl_pp_schedule_rate](
	[sched_rate_id] [numeric](18, 0) NOT NULL,
	[sched_id] [numeric](18, 0) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[band_det_id] [numeric](18, 0) NULL,
	[minimum_charge] [money] NULL,
	[unit_rate] [numeric](18, 7) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[band_start] [numeric](18, 4) NULL,
	[band_end] [numeric](18, 4) NULL,
	[invoice_desc] [varchar](100) NULL,
	[rate_card_id] [numeric](18, 0) NULL,
	[price_charge_id] [numeric](18, 0) NULL,
	[price_custom] [varchar](10) NULL,
	[price_value] [numeric](18, 4) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_utl_pp_schedule_rate] PRIMARY KEY CLUSTERED 
(
	[sched_rate_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
