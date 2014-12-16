USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [csv].[CX_Monitor](
	[QuestionDescription] [varchar](max) NULL,
	[QuestionKey] [varchar](512) NOT NULL,
	[RespondentId] [int] NOT NULL,
	[Data] [varchar](max) NULL,
	[ResearchProjectName] [varchar](512) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_CX_Monitor] PRIMARY KEY CLUSTERED 
(
	[QuestionKey] ASC,
	[RespondentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data] TEXTIMAGE_ON [data]

GO
SET ANSI_PADDING OFF
GO
