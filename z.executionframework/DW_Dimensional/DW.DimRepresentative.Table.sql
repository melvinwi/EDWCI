USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[DimRepresentative](
	[RepresentativeId] [int] IDENTITY(1,1) NOT NULL,
	[RepresentativeKey] [int] NULL,
	[RepresentativeFirstName] [nvarchar](100) NULL DEFAULT (NULL),
	[RepresentativeMiddleInitial] [nchar](10) NULL DEFAULT (NULL),
	[RepresentativeLastName] [nvarchar](100) NULL DEFAULT (NULL),
	[RepresentativePartyName] [nvarchar](100) NULL DEFAULT (NULL),
	[Meta_IsCurrent] [bit] NOT NULL,
	[Meta_EffectiveStartDate] [datetime2](0) NOT NULL,
	[Meta_EffectiveEndDate] [datetime2](0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_DW.DimRepresentative] PRIMARY KEY CLUSTERED 
(
	[RepresentativeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
