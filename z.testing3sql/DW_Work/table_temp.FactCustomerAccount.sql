USE [DW_Work]
GO

/****** Object:  Table [temp].[FactCustomerAccount]    Script Date: 2/09/2014 12:11:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [temp].[FactCustomerAccount](
	[CustomerId] [int] NOT NULL,
	[AccountId] [int] NOT NULL,
	[AccountRelationshipCounter] [tinyint] NOT NULL
) ON [PRIMARY]

GO

