USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[CensusData](
	[Code] [nvarchar](8) NULL,
	[Suburb] [nvarchar](50) NULL,
	[State] [nvarchar](3) NULL,
	[Occupied Dwellings] [smallint] NULL
) ON [data]

GO
