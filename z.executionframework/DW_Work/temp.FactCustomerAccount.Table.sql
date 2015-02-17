USE [DW_Work]
GO
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
USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[FactCustomerAccount](
	[CustomerId] [int] NOT NULL,
	[AccountId] [int] NOT NULL,
	[AccountRelationshipCounter] [tinyint] NOT NULL
) ON [DATA]

GO
