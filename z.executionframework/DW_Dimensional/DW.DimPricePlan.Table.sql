USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[DimPricePlan](
	[PricePlanId] [int] IDENTITY(1,1) NOT NULL,
	[PricePlanKey] [nvarchar](30) NULL,
	[PricePlanCode] [nvarchar](20) NULL DEFAULT (NULL),
	[PricePlanName] [nvarchar](100) NULL,
	[PricePlanDiscountPercentage] [decimal](5, 4) NULL,
	[PricePlanValueRatio] [decimal](3, 2) NULL DEFAULT (NULL),
	[Meta_IsCurrent] [bit] NOT NULL,
	[Meta_EffectiveStartDate] [datetime2](0) NOT NULL,
	[Meta_EffectiveEndDate] [datetime2](0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
	[PricePlanType] [nchar](5) NULL,
	[Bundled] [nvarchar](11) NULL,
	[ParentPricePlanCode] [nvarchar](20) NULL,
 CONSTRAINT [PK_DW.DimPricePlan] PRIMARY KEY CLUSTERED 
(
	[PricePlanId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING ON

GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20141201-141615] ON [DW].[DimPricePlan]
(
	[PricePlanId] ASC,
	[PricePlanKey] ASC,
	[Meta_IsCurrent] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
