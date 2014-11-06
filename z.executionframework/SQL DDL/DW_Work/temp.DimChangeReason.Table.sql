USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimChangeReason](
	[ChangeReasonKey] [int] NULL,
	[ChangeReasonCode] [nchar](10) NULL,
	[ChangeReasonDesc] [nvarchar](100) NULL
) ON [data]

GO
