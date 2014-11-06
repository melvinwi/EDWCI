USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimFinancialAccount](
	[FinancialAccountKey] [int] NULL,
	[FinancialAccountName] [nvarchar](100) NULL,
	[FinancialAccountType] [nchar](10) NULL,
	[Level1Name] [nvarchar](100) NULL,
	[Level2Name] [nvarchar](100) NULL,
	[Level3Name] [nvarchar](100) NULL
) ON [PRIMARY]

GO
ALTER TABLE [temp].[DimFinancialAccount] ADD  DEFAULT (NULL) FOR [FinancialAccountKey]
GO
ALTER TABLE [temp].[DimFinancialAccount] ADD  DEFAULT (NULL) FOR [FinancialAccountName]
GO
ALTER TABLE [temp].[DimFinancialAccount] ADD  DEFAULT (NULL) FOR [FinancialAccountType]
GO
ALTER TABLE [temp].[DimFinancialAccount] ADD  DEFAULT (NULL) FOR [Level1Name]
GO
ALTER TABLE [temp].[DimFinancialAccount] ADD  DEFAULT (NULL) FOR [Level2Name]
GO
ALTER TABLE [temp].[DimFinancialAccount] ADD  DEFAULT (NULL) FOR [Level3Name]
GO
