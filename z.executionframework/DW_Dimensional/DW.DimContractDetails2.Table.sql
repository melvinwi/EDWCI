USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[DimContractDetails2](
	[ContractDetailsId] [int] IDENTITY(1,1) NOT NULL,
	[ContractDetailsKey] [int] NOT NULL,
	[ContractStatus] [nchar](10) NOT NULL,
	[ContractDetailedStatus] [nvarchar](50) NOT NULL,
	[Meta_IsCurrent] [bit] NOT NULL,
	[Meta_EffectiveStartDate] [datetime2](0) NOT NULL,
	[Meta_EffectiveEndDate] [datetime2](0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [DATA]

GO
