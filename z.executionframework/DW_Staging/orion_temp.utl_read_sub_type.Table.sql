USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion_temp].[utl_read_sub_type](
	[read_sub_type_id] [numeric](18, 0) NOT NULL,
	[read_type_id] [numeric](18, 0) NULL,
	[read_sub_type_code] [varchar](20) NULL,
	[read_sub_type_desc] [varchar](100) NULL,
	[seq_colour_id] [numeric](18, 0) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[seq_product_type_id] [numeric](18, 0) NULL,
	[external_reference] [varchar](100) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
