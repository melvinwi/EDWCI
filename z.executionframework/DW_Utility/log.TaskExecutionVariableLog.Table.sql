USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [log].[TaskExecutionVariableLog](
	[VariableLogID] [int] IDENTITY(1,1) NOT NULL,
	[TaskExecutionInstanceID] [int] NOT NULL,
	[VariableName] [nvarchar](255) NOT NULL,
	[VariableValue] [ntext] NULL,
	[LoggedDateTime] [datetime2](2) NOT NULL,
 CONSTRAINT [PK_TaskExecutionVariableLog] PRIMARY KEY CLUSTERED 
(
	[VariableLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data] TEXTIMAGE_ON [PRIMARY]

GO
