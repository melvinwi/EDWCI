USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimProduct](
	[ProductKey] [nvarchar](30) NULL,
	[ProductName] [nvarchar](100) NULL,
	[ProductDesc] [nvarchar](100) NULL,
	[ProductType] [nchar](6) NULL
) ON [PRIMARY]

GO
ALTER TABLE [temp].[DimProduct] ADD  DEFAULT (NULL) FOR [ProductKey]
GO
ALTER TABLE [temp].[DimProduct] ADD  DEFAULT (NULL) FOR [ProductName]
GO
ALTER TABLE [temp].[DimProduct] ADD  DEFAULT (NULL) FOR [ProductDesc]
GO
ALTER TABLE [temp].[DimProduct] ADD  DEFAULT (NULL) FOR [ProductType]
GO
