USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [orion].[crm_element_hierarchy](
	[element_id] [numeric](18, 0) NULL,
	[element_struct_code] [varchar](10) NULL,
	[parent_id] [numeric](18, 0) NULL,
	[parent_element_struct_code] [varchar](10) NULL,
	[seq_element_type_id] [numeric](18, 0) NULL,
	[active] [char](1) NULL,
	[insert_datetime] [datetime] NULL,
	[insert_user] [varchar](20) NULL,
	[insert_process] [varchar](20) NULL,
	[update_datetime] [datetime] NULL,
	[update_user] [varchar](20) NULL,
	[update_process] [varchar](20) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[start_date1] [datetime] NULL,
	[end_date1] [datetime] NULL,
	[department_head] [varchar](1) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [UC_crm_element_hierarchy] UNIQUE NONCLUSTERED 
(
	[element_id] ASC,
	[parent_id] ASC,
	[start_date1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [IX_orion_crm_element_hierarchy_active_element_struct_code] ON [orion].[crm_element_hierarchy]
(
	[active] ASC,
	[element_struct_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
CREATE NONCLUSTERED INDEX [IX_orion_crm_element_hierarchy_Meta_LatestUpdateId] ON [orion].[crm_element_hierarchy]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
CREATE NONCLUSTERED INDEX [IX_orion_crm_element_hierarchy_seq_element_type_id] ON [orion].[crm_element_hierarchy]
(
	[seq_element_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
