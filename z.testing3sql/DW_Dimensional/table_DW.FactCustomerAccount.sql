USE [DW_Dimensional]
GO

/****** Object:  Table [DW].[FactCustomerAccount]    Script Date: 2/09/2014 12:13:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DW].[FactCustomerAccount](
	[CustomerId] [int] NOT NULL,
	[AccountId] [int] NOT NULL,
	[AccountRelationshipCounter] [tinyint] NOT NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NOT NULL
) ON [PRIMARY]

GO

