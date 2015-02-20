USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[DimFinancialAccount](
	[FinancialAccountId] [int] IDENTITY(1,1) NOT NULL,
	[FinancialAccountKey] [int] NULL,
	[FinancialAccountName] [nvarchar](100) NULL,
	[FinancialAccountType] [nchar](10) NULL,
	[Level1Name] [nvarchar](100) NULL,
	[Level2Name] [nvarchar](100) NULL,
	[Level3Name] [nvarchar](100) NULL,
	[Meta_IsCurrent] [bit] NOT NULL,
	[Meta_EffectiveStartDate] [datetime2](0) NOT NULL,
	[Meta_EffectiveEndDate] [datetime2](0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_DW.DimFinancialAccount] PRIMARY KEY CLUSTERED 
(
	[FinancialAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
