USE [DW_Dimensional]
GO

/****** Object:  Table [DW].[DimService]    Script Date: 2/09/2014 12:13:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DW].[DimService](
	[ServiceId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceKey] [int] NULL DEFAULT (NULL),
	[MarketIdentifier] [nvarchar](30) NULL DEFAULT (NULL),
	[ServiceType] [nvarchar](11) NULL DEFAULT (NULL),
	[Meta_IsCurrent] [bit] NOT NULL,
	[Meta_EffectiveStartDate] [datetime2](0) NOT NULL,
	[Meta_EffectiveEndDate] [datetime2](0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_DW.DimService] PRIMARY KEY CLUSTERED 
(
	[ServiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

