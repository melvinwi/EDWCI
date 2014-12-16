USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[FactServiceMeterRegister](
	[ServiceId] [int] NOT NULL,
	[MeterRegisterId] [int] NOT NULL,
	[RegisterRelationshipCounter] [tinyint] NOT NULL
) ON [data]

GO
