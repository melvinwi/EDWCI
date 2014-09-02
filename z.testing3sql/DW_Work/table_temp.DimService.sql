USE [DW_Work]
GO

/****** Object:  Table [temp].[DimService]    Script Date: 2/09/2014 12:10:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [temp].[DimService](
	[ServiceKey] [int] NULL DEFAULT (NULL),
	[MarketIdentifier] [nvarchar](30) NULL DEFAULT (NULL),
	[ServiceType] [nvarchar](11) NULL DEFAULT (NULL)
) ON [PRIMARY]

GO

