USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [AEMO].[zz_Level2_File_Summary_DoNotDelete](
	[Path] [varchar](500) NOT NULL,
	[YearFolder] [char](4) NULL,
	[MonthFolder] [varchar](2) NULL,
	[DayFolder] [varchar](2) NULL,
	[FileName] [varchar](255) NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
