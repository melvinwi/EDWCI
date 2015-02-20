USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[utl_air_points](
	[air_points_id] [numeric](18, 0) NOT NULL,
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
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_utl_air_points] PRIMARY KEY CLUSTERED 
(
	[air_points_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_air_points_Meta_LatestUpdateId] ON [orion].[utl_air_points]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[utl_air_points](
	[air_points_id] [numeric](18, 0) NOT NULL,
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
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_utl_air_points] PRIMARY KEY CLUSTERED 
(
	[air_points_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_utl_air_points_Meta_LatestUpdateId] ON [orion].[utl_air_points]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
