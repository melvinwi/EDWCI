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
	[ResponseKey] [nvarchar](255) NULL
) ON [PRIMARY]

GO
