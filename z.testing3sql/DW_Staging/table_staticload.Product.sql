USE [DW_Staging]
GO

/****** Object:  Table [staticload].[Product]    Script Date: 2/09/2014 12:09:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [staticload].[Product](
	[ProductKey] [nvarchar](30) NULL,
	[ProductName] [nvarchar](30) NULL,
	[ProductDesc] [nvarchar](100) NULL,
	[Meta_ChangeFlag] [bit] NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
	[ProductType] [nchar](6) NULL
) ON [PRIMARY]

GO

