USE [DW_Dimensional]
GO

/****** Object:  Table [DW].[FactContract]    Script Date: 2/09/2014 12:13:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DW].[FactContract](
	[AccountId] [int] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[ContractStartDateId] [int] NOT NULL,
	[ContractEndDateId] [int] NOT NULL,
	[ContractTerminatedDateId] [int] NOT NULL,
	[ContractStatus] [nchar](10) NOT NULL,
	[ContractKey] [int] NOT NULL,
	[ContractCounter] [tinyint] NOT NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NOT NULL
) ON [PRIMARY]

GO

