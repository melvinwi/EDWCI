USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_air_points](
	[air_points_id] [numeric](18, 0) NULL,
	[seq_party_id] [numeric](18, 0) NULL,
	[virgin_member_id] [varchar](10) NULL,
	[points_type] [varchar](10) NULL,
	[points_amount] [numeric](18, 0) NULL,
	[points_exported] [numeric](18, 0) NULL,
	[seq_ar_invoice_id] [numeric](18, 0) NULL,
	[fully_exported] [varchar](1) NULL,
	[one_off_reason] [varchar](20) NULL,
	[insert_user] [varchar](20) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_process] [varchar](20) NULL,
	[update_user] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_process] [varchar](20) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
