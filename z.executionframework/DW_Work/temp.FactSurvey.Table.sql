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
USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[FactSurvey](
	[CustomerId] [int] NULL,
	[QuestionId] [int] NULL,
	[ResponseDateId] [int] NULL,
	[Response] [nvarchar](255) NULL,
	[RespondentKey] [int] NULL,
	[ResponseKey] [nvarchar](255) NULL,
	[Segment] [nvarchar](255) NULL,
	[ResearchProjectName] [nvarchar](255) NULL
) ON [PRIMARY]

GO
ALTER TABLE [temp].[FactSurvey] ADD  DEFAULT (NULL) FOR [CustomerId]
GO
ALTER TABLE [temp].[FactSurvey] ADD  DEFAULT (NULL) FOR [QuestionId]
GO
ALTER TABLE [temp].[FactSurvey] ADD  DEFAULT (NULL) FOR [ResponseDateId]
GO
ALTER TABLE [temp].[FactSurvey] ADD  DEFAULT (NULL) FOR [Response]
GO
ALTER TABLE [temp].[FactSurvey] ADD  DEFAULT (NULL) FOR [RespondentKey]
GO
ALTER TABLE [temp].[FactSurvey] ADD  DEFAULT (NULL) FOR [ResponseKey]
GO
ALTER TABLE [temp].[FactSurvey] ADD  DEFAULT (NULL) FOR [Segment]
GO
ALTER TABLE [temp].[FactSurvey] ADD  DEFAULT (NULL) FOR [ResearchProjectName]
GO
