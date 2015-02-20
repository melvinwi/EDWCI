USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[DimChangeReason](
	[ChangeReasonId] [int] IDENTITY(1,1) NOT NULL,
	[ChangeReasonKey] [int] NULL,
	[ChangeReasonCode] [nchar](10) NULL,
	[ChangeReasonDesc] [nvarchar](100) NULL,
	[Meta_IsCurrent] [bit] NOT NULL,
	[Meta_EffectiveStartDate] [datetime2](0) NOT NULL,
	[Meta_EffectiveEndDate] [datetime2](0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_DW.DimChangeReason] PRIMARY KEY CLUSTERED 
(
	[ChangeReasonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
) ON [INDEX]

GO
