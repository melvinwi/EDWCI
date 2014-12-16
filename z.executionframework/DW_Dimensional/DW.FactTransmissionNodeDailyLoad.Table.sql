USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[FactTransmissionNodeDailyLoad](
	[TransmissionNodeId] [int] NULL,
	[SettlementDateId] [int] NULL,
	[SettlementRun] [int] NULL,
	[Region] [nvarchar](10) NULL,
	[ImportGrossEnergy] [decimal](25, 15) NULL,
	[ExportGrossEnergy] [decimal](25, 15) NULL,
	[ImportNetEnergy] [decimal](25, 15) NULL,
	[ExportNetEnergy] [decimal](25, 15) NULL,
	[ImportReactivePower] [decimal](25, 15) NULL,
	[ExportReactivePower] [decimal](25, 15) NULL,
	[SettlementAmount] [decimal](25, 15) NULL,
	[MeterRun] [int] NULL,
	[MeteringDataAgent] [nvarchar](10) NULL,
	[TransmissionNodeDailyLoadKey] [nvarchar](50) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NOT NULL
) ON [data]

GO
