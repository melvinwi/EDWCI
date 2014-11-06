USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[FactActivity](
	[CustomerId] [int] NULL,
	[RepresentativeId] [int] NULL,
	[OrganisationId] [int] NULL,
	[ActivityTypeId] [int] NULL,
	[ActivityDateId] [int] NULL,
	[ActivityTime] [time](7) NULL,
	[ActivityCommunicationMethod] [nvarchar](30) NULL,
	[ActivityCategory] [nvarchar](20) NULL,
	[ActivityNotes] [nvarchar](4000) NULL,
	[ActivityKey] [int] NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data]

GO
CREATE CLUSTERED COLUMNSTORE INDEX [ClusteredColumnStoreIndex-FactActivity] ON [DW].[FactActivity] WITH (DROP_EXISTING = OFF) ON [data]
GO
