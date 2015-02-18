USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[nc_credit_control_status](
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_credit_status_id] [numeric](18, 0) NULL,
	[seq_credit_status_code] [varchar](10) NULL,
	[seq_credit_status_desc] [varchar](100) NULL,
	[allow_pplan] [varchar](1) NULL,
	[allow_adjustment] [varchar](1) NULL,
	[allow_billing] [varchar](1) NULL,
	[allow_disconnection] [varchar](1) NULL,
	[allow_site_add] [varchar](1) NULL,
	[allow_receipt] [varchar](1) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [PRIMARY]

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
CREATE TABLE [orion_temp].[nc_credit_control_status](
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_credit_status_id] [numeric](18, 0) NOT NULL,
	[seq_credit_status_code] [varchar](10) NULL,
	[seq_credit_status_desc] [varchar](100) NULL,
	[allow_pplan] [varchar](1) NULL,
	[allow_adjustment] [varchar](1) NULL,
	[allow_billing] [varchar](1) NULL,
	[allow_disconnection] [varchar](1) NULL,
	[allow_site_add] [varchar](1) NULL,
	[allow_receipt] [varchar](1) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
