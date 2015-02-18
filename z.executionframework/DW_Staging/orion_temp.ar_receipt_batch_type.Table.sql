USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[ar_receipt_batch_type](
	[seq_rcpt_batch_type_id] [numeric](18, 0) NULL,
	[rcpt_batch_type_code] [varchar](10) NULL,
	[rcpt_batch_type_desc] [varchar](100) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[req_bank_ac_flag] [char](1) NULL,
	[req_credit_card_flag] [char](1) NULL,
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
CREATE TABLE [orion_temp].[ar_receipt_batch_type](
	[seq_rcpt_batch_type_id] [numeric](18, 0) NOT NULL,
	[rcpt_batch_type_code] [varchar](10) NULL,
	[rcpt_batch_type_desc] [varchar](100) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[req_bank_ac_flag] [char](1) NULL,
	[req_credit_card_flag] [char](1) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
