USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[nc_tax_rate_history](
	[tax_rate_history_id] [numeric](18, 0) NULL,
	[seq_tax_ind_id] [numeric](18, 0) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[tax_rate] [numeric](18, 6) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[deter_1] [varchar](100) NULL,
	[deter_2] [varchar](100) NULL,
	[tax_dtl_rate_1] [numeric](18, 6) NULL,
	[tax_dtl_rate_2] [numeric](18, 6) NULL,
	[tax_dtl_rate_3] [numeric](18, 6) NULL,
	[tax_dtl_rate_4] [numeric](18, 6) NULL,
	[tax_dtl_rate_5] [numeric](18, 6) NULL,
	[tax_dtl_rate_6] [numeric](18, 6) NULL,
	[external_reference] [varchar](20) NULL,
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
CREATE TABLE [orion_temp].[nc_tax_rate_history](
	[tax_rate_history_id] [numeric](18, 0) NOT NULL,
	[seq_tax_ind_id] [numeric](18, 0) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[tax_rate] [numeric](18, 6) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[deter_1] [varchar](100) NULL,
	[deter_2] [varchar](100) NULL,
	[tax_dtl_rate_1] [numeric](18, 6) NULL,
	[tax_dtl_rate_2] [numeric](18, 6) NULL,
	[tax_dtl_rate_3] [numeric](18, 6) NULL,
	[tax_dtl_rate_4] [numeric](18, 6) NULL,
	[tax_dtl_rate_5] [numeric](18, 6) NULL,
	[tax_dtl_rate_6] [numeric](18, 6) NULL,
	[external_reference] [varchar](20) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
