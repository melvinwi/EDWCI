USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [AEMO].[zz_Level2_File_Summary2_DoNotDelete](
	[Path] [varchar](500) NULL,
	[YearWeekFolder] [varchar](50) NULL,
	[FileName] [varchar](50) NULL,
	[NeedToImport] [bit] NULL,
	[FileFound] [bit] NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
