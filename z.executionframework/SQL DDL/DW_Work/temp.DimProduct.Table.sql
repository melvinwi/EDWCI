USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimProduct](
	[ProductKey] [nvarchar](30) NULL DEFAULT (NULL),
	[ProductName] [nvarchar](100) NULL DEFAULT (NULL),
	[ProductDesc] [nvarchar](100) NULL DEFAULT (NULL),
	[ProductType] [nchar](6) NULL DEFAULT (NULL)
) ON [PRIMARY]

GO
