USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [DW].[DimDate](
	[DateId] [int] NOT NULL,
	[Date] [date] NOT NULL,
	[DayOfWeek] [nchar](10) NOT NULL,
	[MonthName] [nchar](10) NOT NULL,
	[MonthNameShort] [nchar](3) NOT NULL,
	[Year] [smallint] NOT NULL,
	[MonthNumberInYear] [tinyint] NOT NULL,
	[DayNumberInWeek] [tinyint] NOT NULL,
	[DayNumberInMonth] [tinyint] NOT NULL,
	[DayNumberInYear] [smallint] NOT NULL,
	[Qtr] [nchar](2) NOT NULL,
	[QtrAndYear] [nchar](7) NOT NULL,
	[FiscalMonthNumber] [tinyint] NOT NULL,
	[FiscalQtr] [nchar](2) NOT NULL,
	[FiscalYear] [smallint] NOT NULL,
	[FiscalQtrAndYear] [nchar](9) NOT NULL,
	[FirstDayOfWeekIndicator] [nchar](3) NOT NULL,
	[FirstDayOfMonthIndicator] [nchar](3) NOT NULL,
	[LastDayofWeekIndicator] [nchar](3) NOT NULL,
	[LastDayofMonthIndicator] [nchar](3) NOT NULL,
	[WeekEndingDate] [date] NOT NULL,
	[MonthEndingDate] [date] NOT NULL,
	[MonthEndingDayOfWeek] [nchar](10) NOT NULL,
	[WeekdayOrEnd] [nchar](7) NOT NULL,
	[NationalHolidayIndicator] [nchar](3) NOT NULL,
	[NationalHolidayName] [varchar](20) NOT NULL,
	[Season] [nchar](6) NOT NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_dbo.DimDate] PRIMARY KEY CLUSTERED 
(
	[DateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [_dta_index_DimDate_9_82099333__K9_K2_K6_K7] ON [DW].[DimDate]
(
	[DayNumberInMonth] ASC,
	[Date] ASC,
	[Year] ASC,
	[MonthNumberInYear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
