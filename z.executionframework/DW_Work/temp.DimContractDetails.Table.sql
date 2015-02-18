USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimContractDetails](
	[ContractDetailsKey] [int] NOT NULL,
	[ContractStatus] [nchar](10) NOT NULL,
	[ContractDetailedStatus] [nvarchar](50) NOT NULL
) ON [DATA]

GO
