USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[ar_receipt_batch](
	[seq_rcpt_batch_id] [numeric](18, 0) NULL,
	[seq_rcpt_batch_type_id] [numeric](18, 0) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[batch_name] [varchar](200) NULL,
	[network_id] [numeric](18, 0) NULL,
	[approved] [varchar](1) NULL,
	[batch_file] [varchar](200) NULL,
	[exported_file] [varchar](100) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data]

GO
SET ANSI_PADDING OFF
GO
