USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimActivityType](
	[ActivityTypeKey] [int] NULL,
	[ActivityTypeCode] [nvarchar](20) NULL,
	[ActivityTypeDesc] [nvarchar](100) NULL
) ON [PRIMARY]

GO
