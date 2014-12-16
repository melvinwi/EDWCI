USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[FactSurvey](
	[CustomerId] [int] NULL DEFAULT (NULL),
	[QuestionId] [int] NULL DEFAULT (NULL),
	[ResponseDateId] [int] NULL DEFAULT (NULL),
	[Response] [nvarchar](255) NULL DEFAULT (NULL),
	[RespondentKey] [int] NULL DEFAULT (NULL),
	[ResponseKey] [nvarchar](255) NULL DEFAULT (NULL),
	[ResearchProjectName] [nvarchar](255) NULL DEFAULT (NULL)
) ON [PRIMARY]

GO
