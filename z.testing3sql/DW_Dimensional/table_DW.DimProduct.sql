USE [DW_Dimensional]
GO

/****** Object:  Table [DW].[DimProduct]    Script Date: 2/09/2014 12:13:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DW].[DimProduct](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[ProductKey] [nvarchar](30) NULL DEFAULT (NULL),
	[ProductName] [nvarchar](100) NULL DEFAULT (NULL),
	[ProductDesc] [nvarchar](100) NULL DEFAULT (NULL),
	[ProductType] [nchar](6) NULL DEFAULT (NULL),
	[Meta_IsCurrent] [bit] NOT NULL,
	[Meta_EffectiveStartDate] [datetime2](0) NOT NULL,
	[Meta_EffectiveEndDate] [datetime2](0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_DW.DimProduct] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

