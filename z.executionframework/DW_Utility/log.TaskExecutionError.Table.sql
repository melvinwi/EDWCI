USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [log].[TaskExecutionError](
	[TaskErrorID] [int] IDENTITY(1,1) NOT NULL,
	[TaskExecutionInstanceID] [int] NOT NULL,
	[ErrorCode] [int] NOT NULL,
	[ErrorDescription] [ntext] NOT NULL,
	[ErrorDateTime] [datetime2](2) NOT NULL,
	[SourceName] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_TaskExecutionError] PRIMARY KEY CLUSTERED 
(
	[TaskErrorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data] TEXTIMAGE_ON [PRIMARY]

GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [log].[TaskExecutionError](
	[TaskErrorID] [int] IDENTITY(1,1) NOT NULL,
	[TaskExecutionInstanceID] [int] NOT NULL,
	[ErrorCode] [int] NOT NULL,
	[ErrorDescription] [ntext] NOT NULL,
	[ErrorDateTime] [datetime2](2) NOT NULL,
	[SourceName] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_TaskExecutionError] PRIMARY KEY CLUSTERED 
(
	[TaskErrorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data] TEXTIMAGE_ON [PRIMARY]

GO
