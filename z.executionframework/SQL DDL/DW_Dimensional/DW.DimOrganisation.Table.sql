USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[DimOrganisation](
	[OrganisationId] [int] IDENTITY(1,1) NOT NULL,
	[OrganisationKey] [int] NULL,
	[OrganisationName] [nvarchar](100) NULL DEFAULT (NULL),
	[Level1Name] [nvarchar](100) NULL,
	[Level2Name] [nvarchar](100) NULL,
	[Level3Name] [nvarchar](100) NULL,
	[Level4Name] [nvarchar](100) NULL,
	[Meta_IsCurrent] [bit] NOT NULL,
	[Meta_EffectiveStartDate] [datetime2](0) NOT NULL,
	[Meta_EffectiveEndDate] [datetime2](0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_DW.DimOrganisation] PRIMARY KEY CLUSTERED 
(
	[OrganisationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
