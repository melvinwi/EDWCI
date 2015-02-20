USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [exceptions].[UnbilledRevenueReport](
	[ServiceKey] [int] NULL,
	[MarketIdentifier] [nvarchar](30) NULL,
	[ExceptionCode] [nvarchar](10) NULL,
	[ExceptionDesc] [nvarchar](255) NULL,
	[ExceptionDetails] [nvarchar](max) NULL,
	[ReportDateId] [date] NULL
) ON [data] TEXTIMAGE_ON [data]

GO
