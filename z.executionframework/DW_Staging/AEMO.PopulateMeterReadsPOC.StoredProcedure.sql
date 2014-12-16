USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [AEMO].[PopulateMeterReadsPOC] 
  @MinNMI INT
, @MaxNMI INT
, @NMIInterval INT

AS 
/*
Usage:
  EXEC AEMO.PopulateMeterReadsPOC @MinNMI = 1
                                , @MaxNMI = 500
                                , @NMIInterval = 1
*/

SET NOCOUNT ON

DECLARE @NMI INT = @MinNMI

DECLARE @MinDate Date = '20140101'
DECLARE @MaxDate Date = '20141231'
DECLARE @DateInterval SMALLINT = 1

DECLARE @MinMinute SMALLINT = 15
DECLARE @MaxMinute SMALLINT = 1440
DECLARE @MinuteInterval SMALLINT = 15

DECLARE @NMI_Table          Table ( NMI INT )
DECLARE @MinuteOfDay_Table  Table ( MinuteOfDay SMALLINT
                                  , HourOfDay TINYINT )
DECLARE @Date_Table         Table ( DateId INT  )

--MinuteOfDay
;WITH t1 AS (
  SELECT @MinMinute AS MinuteOfDay
  UNION ALL
  SELECT MinuteOfDay + @MinuteInterval FROM t1 WHERE MinuteOfDay < @MaxMinute
  )
INSERT INTO @MinuteOfDay_Table (MinuteOfDay, HourOfDay)
SELECT  MinuteOfDay, MinuteOfDay / 60 %24
FROM    t1 
OPTION  (maxrecursion 32767)
--/

--DateId
;WITH t2 AS (
  SELECT @MinDate AS [Date]
  UNION ALL
  SELECT DATEADD(dd, @DateInterval, [Date]) FROM t2 WHERE [Date] < @MaxDate
  )
INSERT INTO @Date_Table (DateId)
SELECT  CONVERT(CHAR(8),  [Date], 112)
FROM    t2 
OPTION  (maxrecursion 32767)
--/

--NMI
WHILE @NMI <= @MaxNMI
BEGIN
  INSERT INTO @NMI_Table (NMI)
  VALUES(@NMI)
  SET @nmi = @nmi+@NMIInterval
END
--/

INSERT INTO [AEMO].[MeterReadsPOC]
      ( NMI
      , ReadDate
      , MinuteOfDay
      , HourOfDay
      , READ_1
      )
SELECT  NMI
      , DateId
      , MinuteOfDay
      , HourOfDay
      , cast(( ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) % 1000000)/ 1000.0 as decimal(6,3)) 
FROM        @MinuteOfDay_Table
CROSS JOIN  @Date_Table
CROSS JOIN  @NMI_Table
ORDER BY  NMI
        , DateId
        , MinuteOfDay
        , HourOfDay


        
GO
