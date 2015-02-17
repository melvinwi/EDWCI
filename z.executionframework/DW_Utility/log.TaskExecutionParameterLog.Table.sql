USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [log].[TaskExecutionParameterLog](
	[ParameterLogID] [int] IDENTITY(1,1) NOT NULL,
	[TaskExecutionInstanceID] [int] NOT NULL,
	[ParameterName] [nvarchar](128) NOT NULL,
	[ParameterValue] [sql_variant] NULL,
	[LoggedDateTime] [datetime2](2) NOT NULL,
 CONSTRAINT [PK_TaskExecutionParameterLog] PRIMARY KEY CLUSTERED 
(
	[ParameterLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [log].[TaskExecutionParameterLog](
	[ParameterLogID] [int] IDENTITY(1,1) NOT NULL,
	[TaskExecutionInstanceID] [int] NOT NULL,
	[ParameterName] [nvarchar](128) NOT NULL,
	[ParameterValue] [sql_variant] NULL,
	[LoggedDateTime] [datetime2](2) NOT NULL,
 CONSTRAINT [PK_TaskExecutionParameterLog] PRIMARY KEY CLUSTERED 
(
	[ParameterLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
