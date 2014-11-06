USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [config].[TaskParameter](
	[TaskParameterID] [int] IDENTITY(1,1) NOT NULL,
	[TaskID] [int] NOT NULL,
	[ParameterName] [nvarchar](128) NOT NULL,
	[ParameterValue] [sql_variant] NOT NULL,
	[ObjectType] [nvarchar](128) NOT NULL CONSTRAINT [DF_TaskParameter_ObjectType]  DEFAULT ('package'),
	[ObjectTypeId]  AS (case [ObjectType] when 'package' then (30) when 'project' then (20) when 'environment' then (50) else (30) end),
	[IsDisabled] [bit] NOT NULL CONSTRAINT [DF_TaskParameter_IsDisabled]  DEFAULT ('0'),
 CONSTRAINT [PK_TaskParameter] PRIMARY KEY CLUSTERED 
(
	[TaskParameterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data],
 CONSTRAINT [ucTaskIdParamterName] UNIQUE NONCLUSTERED 
(
	[TaskID] ASC,
	[ParameterName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [index]
) ON [data]

GO
SET ANSI_PADDING ON

GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_NC_TaskID_ParameterName_ParameterValue_ObjectType] ON [config].[TaskParameter]
(
	[TaskID] ASC,
	[ParameterName] ASC,
	[ParameterValue] ASC,
	[ObjectType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [index]
GO
ALTER TABLE [config].[TaskParameter]  WITH CHECK ADD  CONSTRAINT [FK_TaskParameter_Task] FOREIGN KEY([TaskID])
REFERENCES [config].[Task] ([TaskID])
GO
ALTER TABLE [config].[TaskParameter] CHECK CONSTRAINT [FK_TaskParameter_Task]
GO
ALTER TABLE [config].[TaskParameter]  WITH CHECK ADD  CONSTRAINT [chk_ObjectType] CHECK  (([ObjectType]='environment' OR [ObjectType]='project' OR [ObjectType]='package'))
GO
ALTER TABLE [config].[TaskParameter] CHECK CONSTRAINT [chk_ObjectType]
GO
