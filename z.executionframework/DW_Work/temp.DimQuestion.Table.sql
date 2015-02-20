USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimQuestion](
	[QuestionKey] [nvarchar](255) NULL,
	[Question] [nvarchar](255) NULL
) ON [PRIMARY]

GO
USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimQuestion](
	[QuestionKey] [int] NULL,
	[Question] [nvarchar](255) NULL
) ON [DATA]

GO
