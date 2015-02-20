USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FragmentedIndexes](
	[DatabaseName] [sysname] NOT NULL,
	[SchemaName] [sysname] NOT NULL,
	[TableName] [sysname] NOT NULL,
	[IndexName] [sysname] NOT NULL,
	[Fragmentation%] [float] NULL
) ON [PRIMARY]

GO
