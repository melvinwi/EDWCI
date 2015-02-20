USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_period](
	[period_id] [numeric](18, 0) NOT NULL,
	[seq_bill_cycle_id] [numeric](18, 0) NULL,
	[period_status_id] [numeric](18, 0) NULL,
	[period_type_id] [numeric](18, 0) NULL,
	[period_start] [datetime] NULL,
	[period_end] [datetime] NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
