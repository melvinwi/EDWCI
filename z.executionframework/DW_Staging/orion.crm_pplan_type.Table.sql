USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[crm_pplan_type](
	[pplan_type_id] [numeric](18, 0) NOT NULL,
	[pplan_type_name] [varchar](100) NULL,
	[pplan_type_desc] [varchar](100) NULL,
	[notes] [varchar](255) NULL,
	[active] [varchar](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_crm_pplan_type] PRIMARY KEY CLUSTERED 
(
	[pplan_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IX_orion_crm_pplan_type_Meta_LatestUpdateId] ON [orion].[crm_pplan_type]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
