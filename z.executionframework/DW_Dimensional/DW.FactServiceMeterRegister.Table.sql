USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[FactServiceMeterRegister](
	[ServiceId] [int] NOT NULL,
	[MeterRegisterId] [int] NOT NULL,
	[RegisterRelationshipCounter] [tinyint] NOT NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NOT NULL
) ON [data]

GO
CREATE CLUSTERED COLUMNSTORE INDEX [ClusteredColumnStoreIndex-FactServiceMeterRegister] ON [DW].[FactServiceMeterRegister] WITH (DROP_EXISTING = OFF) ON [data]
GO
