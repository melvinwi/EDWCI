USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Views].[vDate]
AS
SELECT -- DimDate
       DimDate.Date,
       DimDate.DayOfWeek,
       DimDate.MonthName,
       DimDate.MonthNameShort,
       DimDate.Year,
       DimDate.MonthNumberInYear,
       DimDate.DayNumberInWeek,
       DimDate.DayNumberInMonth,
       DimDate.DayNumberInYear,
       DimDate.Qtr,
       DimDate.QtrAndYear,
       DimDate.FiscalMonthNumber,
       DimDate.FiscalYear,
       DimDate.FirstDayOfWeekIndicator,
       DimDate.FirstDayOfMonthIndicator,
       DimDate.LastDayofWeekIndicator,
       DimDate.LastDayofMonthIndicator,
       DimDate.WeekEndingDate,
       DimDate.MonthEndingDate,
       DimDate.WeekdayOrEnd,
       DimDate.NationalHolidayIndicator,
       DimDate.NationalHolidayName,
       DimDate.Season,
       DimDate.Meta_Insert_TaskExecutionInstanceId,
       DimDate.Meta_LatestUpdate_TaskExecutionInstanceId,
       DimDate.AccountingPeriod
FROM   DW_Dimensional.DW.DimDate


GO
