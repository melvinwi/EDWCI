USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[FactFRMP](
	[ServiceId] [int] NOT NULL,
	[FRMPStartDateId] [int] NOT NULL,
	[FRMPEndDateId] [int] NOT NULL
) ON [data]

GO
