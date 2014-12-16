USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FACTSURVEY_20141113](
	[CustomerId] [int] NULL,
	[QuestionId] [int] NULL,
	[ResponseDateId] [int] NULL,
	[Response] [nvarchar](255) NULL,
	[RespondentKey] [int] NULL,
	[ResponseKey] [nvarchar](255) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data]

GO
