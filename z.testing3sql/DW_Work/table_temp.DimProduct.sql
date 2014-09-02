USE [DW_Work]
GO

/****** Object:  Table [temp].[DimProduct]    Script Date: 2/09/2014 12:10:36 PM ******/
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

