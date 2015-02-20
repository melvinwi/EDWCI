USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[nc_payment_method](
	[seq_pay_method_id] [numeric](18, 0) NOT NULL,
	[pay_method_code] [varchar](10) NULL,
	[pay_method_desc] [varchar](100) NULL,
	[payment_group] [char](1) NULL,
	[seq_call_code_out_id] [numeric](18, 0) NULL,
	[seq_call_code_in_id] [numeric](18, 0) NULL,
	[req_credit_card_flag] [char](1) NULL,
	[req_bank_ac_flag] [char](1) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[inv_print_class_id] [numeric](18, 0) NULL,
	[seq_rcpt_batch_type_id] [numeric](18, 0) NULL,
	[payment_date] [int] NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [pk_nc_payment_method] PRIMARY KEY CLUSTERED 
(
	[seq_pay_method_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_nc_payment_method_Meta_LatestUpdateId] ON [orion].[nc_payment_method]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
