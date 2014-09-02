USE [DW_Access]
GO

/****** Object:  View [Views].[vDate]    Script Date: 2/09/2014 12:15:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [Views].[vDate]
AS
SELECT [DateId]
      ,[Date]
      ,[DayOfWeek]
      ,[MonthName]
      ,[MonthNameShort]
      ,[Year]
      ,[MonthNumberInYear]
      ,[DayNumberInWeek]
      ,[DayNumberInMonth]
      ,[DayNumberInYear]
      ,[Qtr]
      ,[QtrAndYear]
      ,[FiscalMonthNumber]
      ,[FiscalQtr]
      ,[FiscalYear]
      ,[FiscalQtrAndYear]
      ,[FirstDayOfWeekIndicator]
      ,[FirstDayOfMonthIndicator]
      ,[LastDayofWeekIndicator]
      ,[LastDayofMonthIndicator]
      ,[WeekEndingDate]
      ,[MonthEndingDate]
      ,[MonthEndingDayOfWeek]
      ,[WeekdayOrEnd]
      ,[NationalHolidayIndicator]
      ,[NationalHolidayName]
      ,[Season]
  FROM [DW_Dimensional].[DW].[DimDate]
GO

