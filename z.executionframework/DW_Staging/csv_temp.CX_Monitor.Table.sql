USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [csv_temp].[CX_Monitor](
	[QuestionDescription] [varchar](max) NULL,
	[QuestionKey] [varchar](512) NOT NULL,
	[RespondentId] [int] NOT NULL,
	[Data] [varchar](max) NULL,
	[ResearchProjectName] [varchar](512) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA] TEXTIMAGE_ON [DATA]

GO
SET ANSI_PADDING OFF
GO
