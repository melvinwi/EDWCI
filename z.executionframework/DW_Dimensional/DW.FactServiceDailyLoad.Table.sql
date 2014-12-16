USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[FactServiceDailyLoad](
	[ServiceId] [int] NOT NULL,
	[TransmissionNodeId] [int] NOT NULL,
	[TransmissionNodeIdentity] [nvarchar](20) NULL,
	[MarketIdentifier] [nvarchar](30) NULL,
	[SettlementDateId] [int] NULL,
	[SettlementCase] [int] NULL,
	[DatastreamType] [nvarchar](30) NULL,
	[ReadType] [nchar](8) NULL,
	[TotalEnergy] [decimal](10, 3) NULL,
	[ServiceDailyLoadKey] [nvarchar](100) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NOT NULL
) ON [data]

GO
