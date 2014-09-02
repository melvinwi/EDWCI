USE [DW_Work]
GO

/****** Object:  Table [temp].[FactContract]    Script Date: 2/09/2014 12:10:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [temp].[FactContract](
	[AccountId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[ContractStartDateId] [int] NOT NULL,
	[ContractEndDateId] [int] NOT NULL,
	[ContractTerminatedDateId] [int] NOT NULL,
	[ContractStatus] [nchar](10) NOT NULL,
	[ContractKey] [int] NOT NULL,
	[ContractCounter] [tinyint] NOT NULL
) ON [PRIMARY]

GO

