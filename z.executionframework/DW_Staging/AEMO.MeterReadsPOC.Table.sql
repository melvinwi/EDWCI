USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AEMO].[MeterReadsPOC](
	[NMI] [int] NOT NULL,
	[ReadDate] [int] NOT NULL,
	[MinuteOfDay] [smallint] NOT NULL,
	[HourOfDay] [tinyint] NOT NULL,
	[Read_1] [decimal](6, 3) NOT NULL
) ON [ps_TOU_Data_Week_left]([ReadDate])

GO
