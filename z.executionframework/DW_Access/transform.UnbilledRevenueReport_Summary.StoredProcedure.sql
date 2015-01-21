CREATE proc [transform].[UnbilledRevenueReport_Summary]
    @InputDate date,
    @CustomerType nvarchar(20)
AS
BEGIN

    ----Get LatestSuccessfulTaskExecutionInstanceID
    --IF  @LatestSuccessfulTaskExecutionInstanceID IS NULL
    --  BEGIN
    --    EXEC DW_Utility.config.GetLatestSuccessfulTaskExecutionInstanceID
    --        @TaskExecutionInstanceID = @TaskExecutionInstanceID
    --      , @LatestSuccessfulTaskExecutionInstanceID  = @LatestSuccessfulTaskExecutionInstanceID OUTPUT
    --  END
    ----/

SET @CustomerType = N'%' + ISNULL(@CustomerType,N'') + N'%';

-- Establish reporting period from @InputDate
DECLARE @ReportDate1 date
DECLARE @ReportDate2 date
DECLARE @ReportDate3 date
DECLARE @AccountingPeriod int

;WITH t AS (SELECT FiscalMonthNumber, FiscalYear, AccountingPeriod
FROM DW_Dimensional.DW.DimDate
WHERE [Date] = @InputDate)
SELECT @ReportDate1 = MAX(DimDate.[Date]), 
@AccountingPeriod = MAX(DimDate.[AccountingPeriod]) 
FROM DW_Dimensional.DW.DimDate
INNER JOIN t
ON t.FiscalMonthNumber = DimDate.FiscalMonthNumber
AND t.FiscalYear = DimDate.FiscalYear;

;WITH t AS (SELECT FiscalMonthNumber, FiscalYear, AccountingPeriod
FROM DW_Dimensional.DW.DimDate
WHERE [AccountingPeriod] = @AccountingPeriod - 1)
SELECT @ReportDate2 = MAX(DimDate.[Date])
FROM DW_Dimensional.DW.DimDate
INNER JOIN t
ON t.FiscalMonthNumber = DimDate.FiscalMonthNumber
AND t.FiscalYear = DimDate.FiscalYear;

;WITH t AS (SELECT FiscalMonthNumber, FiscalYear, AccountingPeriod
FROM DW_Dimensional.DW.DimDate
WHERE [AccountingPeriod] = @AccountingPeriod - 2)
SELECT @ReportDate3 = MAX(DimDate.[Date])
FROM DW_Dimensional.DW.DimDate
INNER JOIN t
ON t.FiscalMonthNumber = DimDate.FiscalMonthNumber
AND t.FiscalYear = DimDate.FiscalYear;

SET ARITHABORT OFF
SET ANSI_WARNINGS OFF

SELECT  0 AS Number, N'All' AS 'State',
     N'Report Period: ' + CAST(@AccountingPeriod AS nvarchar(3)) + ', Report Date: ' + CAST(@ReportDate1 AS nvarchar(20)) AS 'Column', NULL AS ReportPeriod, NULL AS PreviousPeriod, NULL AS PreviousPreviousPeriod
UNION
SELECT  1 AS Number, N'All' AS 'State',
     N'Consumption' AS 'Column', 
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage')
UNION
SELECT  2 AS Number, N'All' AS 'State',
     N'Unbilled Days' AS 'Column', 
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  3 AS Number, N'All' AS 'State',
     N'Sites' AS 'Column', 
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  4 AS Number, N'All' AS 'State',
     N'Usage Charge' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage')
UNION
SELECT  5 AS Number, N'All' AS 'State',
     N'Standing Charge' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  6 AS Number, N'All' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  7 AS Number, N'All' AS 'State',
     N'Average Usage Cost' AS 'Column', 
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage')/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage')/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage')/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage') * 1000)
UNION
SELECT  8 AS Number, N'All' AS 'State',
     N'Average Daily Cost' AS 'Column', 
     (SELECT AVG(UnbilledSum) FROM (SELECT SUM([TotalUnbilledRevenue]/[UnbilledDays]) AS UnbilledSum FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily' GROUP BY [MarketIdentifier]) inner_query),
     (SELECT AVG(UnbilledSum) FROM (SELECT SUM([TotalUnbilledRevenue]/[UnbilledDays]) AS UnbilledSum FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily' GROUP BY [MarketIdentifier]) inner_query),
     (SELECT AVG(UnbilledSum) FROM (SELECT SUM([TotalUnbilledRevenue]/[UnbilledDays]) AS UnbilledSum FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily' GROUP BY [MarketIdentifier]) inner_query)
UNION
SELECT  9 AS Number, N'All' AS 'State',
     N'Average Total Cost' AS 'Column', 
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1)/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2)/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3)/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage') * 1000)
UNION
SELECT  10 AS Number, N'All' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  11 AS Number, N'All' AS 'State',
     N'Customer type - % of Total Unbilled Revenue' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1)/(SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate1),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2)/(SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate2),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3)/(SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate3)

UNION
SELECT  12 AS Number, N'All' AS 'State',
     N'Customer type - % of Total Unbilled Sites' AS 'Column', 
     CAST((SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily') AS float)/(SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     CAST((SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily') AS float)/(SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     CAST((SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily') AS float)/(SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  13 AS Number, N'All' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  14 AS Number, N'All' AS 'State',
     N'Sites unbilled > 90 days (Sites)' AS 'Column', 
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')
UNION
SELECT  15 AS Number, N'All' AS 'State',
     N'Sites unbilled > 90 days (Usage)' AS 'Column', 
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate1 AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate2 AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate3 AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'))
UNION
SELECT  16 AS Number, N'All' AS 'State',
     N'Sites unbilled > 90 days (Days)' AS 'Column', 
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate1 AND [ScheduleType] = N'Daily' AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate2 AND [ScheduleType] = N'Daily' AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate3 AND [ScheduleType] = N'Daily' AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'))
UNION
SELECT  17 AS Number, N'All' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  18 AS Number, N'All' AS 'State',
     N'Unbilled Revenue' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3)

UNION

SELECT  21 AS Number, N'NSW' AS 'State',
     N'Consumption' AS 'Column', 
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage')
UNION
SELECT  22 AS Number, N'NSW' AS 'State',
     N'Unbilled Days' AS 'Column', 
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  23 AS Number, N'NSW' AS 'State',
     N'Sites' AS 'Column', 
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  24 AS Number, N'NSW' AS 'State',
     N'Usage Charge' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage')
UNION
SELECT  25 AS Number, N'NSW' AS 'State',
     N'Standing Charge' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  26 AS Number, N'NSW' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  27 AS Number, N'NSW' AS 'State',
     N'Average Usage Cost' AS 'Column', 
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage')/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage')/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage')/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage') * 1000)
UNION
SELECT  28 AS Number, N'NSW' AS 'State',
     N'Average Daily Cost' AS 'Column', 
     (SELECT AVG(UnbilledSum) FROM (SELECT SUM([TotalUnbilledRevenue]/[UnbilledDays]) AS UnbilledSum FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily' GROUP BY [MarketIdentifier]) inner_query),
     (SELECT AVG(UnbilledSum) FROM (SELECT SUM([TotalUnbilledRevenue]/[UnbilledDays]) AS UnbilledSum FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily' GROUP BY [MarketIdentifier]) inner_query),
     (SELECT AVG(UnbilledSum) FROM (SELECT SUM([TotalUnbilledRevenue]/[UnbilledDays]) AS UnbilledSum FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily' GROUP BY [MarketIdentifier]) inner_query)
UNION
SELECT  29 AS Number, N'NSW' AS 'State',
     N'Average Total Cost' AS 'Column', 
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1)/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2)/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3)/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage') * 1000)
UNION
SELECT  30 AS Number, N'NSW' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  31 AS Number, N'NSW' AS 'State',
     N'Customer type - % of Total Unbilled Revenue' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1)/(SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND ReportDate = @ReportDate1),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2)/(SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND ReportDate = @ReportDate2),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3)/(SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND ReportDate = @ReportDate3)

UNION
SELECT  32 AS Number, N'NSW' AS 'State',
     N'Customer type - % of Total Unbilled Sites' AS 'Column', 
     CAST((SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily') AS float)/(SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     CAST((SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily') AS float)/(SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     CAST((SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily') AS float)/(SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  33 AS Number, N'NSW' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  34 AS Number, N'NSW' AS 'State',
     N'Sites unbilled > 90 days (Sites)' AS 'Column', 
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')
UNION
SELECT  35 AS Number, N'NSW' AS 'State',
     N'Sites unbilled > 90 days (Usage)' AS 'Column', 
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate1 AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate2 AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate3 AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'))
UNION
SELECT  36 AS Number, N'NSW' AS 'State',
     N'Sites unbilled > 90 days (Days)' AS 'Column', 
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate1 AND [ScheduleType] = N'Daily' AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate2 AND [ScheduleType] = N'Daily' AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate3 AND [ScheduleType] = N'Daily' AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'))
UNION
SELECT  37 AS Number, N'NSW' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  38 AS Number, N'NSW' AS 'State',
     N'Unbilled Revenue' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'NSW' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3)

     UNION

SELECT  41 AS Number, N'QLD' AS 'State',
     N'Consumption' AS 'Column', 
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage')
UNION
SELECT  42 AS Number, N'QLD' AS 'State',
     N'Unbilled Days' AS 'Column', 
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  43 AS Number, N'QLD' AS 'State',
     N'Sites' AS 'Column', 
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  44 AS Number, N'QLD' AS 'State',
     N'Usage Charge' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage')
UNION
SELECT  45 AS Number, N'QLD' AS 'State',
     N'Standing Charge' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  46 AS Number, N'QLD' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  47 AS Number, N'QLD' AS 'State',
     N'Average Usage Cost' AS 'Column', 
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage')/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage')/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage')/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage') * 1000)
UNION
SELECT  48 AS Number, N'QLD' AS 'State',
     N'Average Daily Cost' AS 'Column', 
     (SELECT AVG(UnbilledSum) FROM (SELECT SUM([TotalUnbilledRevenue]/[UnbilledDays]) AS UnbilledSum FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily' GROUP BY [MarketIdentifier]) inner_query),
     (SELECT AVG(UnbilledSum) FROM (SELECT SUM([TotalUnbilledRevenue]/[UnbilledDays]) AS UnbilledSum FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily' GROUP BY [MarketIdentifier]) inner_query),
     (SELECT AVG(UnbilledSum) FROM (SELECT SUM([TotalUnbilledRevenue]/[UnbilledDays]) AS UnbilledSum FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily' GROUP BY [MarketIdentifier]) inner_query)
UNION
SELECT  49 AS Number, N'QLD' AS 'State',
     N'Average Total Cost' AS 'Column', 
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1)/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2)/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3)/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage') * 1000)
UNION
SELECT  50 AS Number, N'QLD' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  51 AS Number, N'QLD' AS 'State',
     N'Customer type - % of Total Unbilled Revenue' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1)/(SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND ReportDate = @ReportDate1),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2)/(SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND ReportDate = @ReportDate2),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3)/(SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND ReportDate = @ReportDate3)

UNION
SELECT  52 AS Number, N'QLD' AS 'State',
     N'Customer type - % of Total Unbilled Sites' AS 'Column', 
     CAST((SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily') AS float)/(SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     CAST((SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily') AS float)/(SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     CAST((SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily') AS float)/(SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  53 AS Number, N'QLD' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  54 AS Number, N'QLD' AS 'State',
     N'Sites unbilled > 90 days (Sites)' AS 'Column', 
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')
UNION
SELECT  55 AS Number, N'QLD' AS 'State',
     N'Sites unbilled > 90 days (Usage)' AS 'Column', 
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate1 AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate2 AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate3 AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'))
UNION
SELECT  56 AS Number, N'QLD' AS 'State',
     N'Sites unbilled > 90 days (Days)' AS 'Column', 
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate1 AND [ScheduleType] = N'Daily' AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate2 AND [ScheduleType] = N'Daily' AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate3 AND [ScheduleType] = N'Daily' AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'))
UNION
SELECT  57 AS Number, N'QLD' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  58 AS Number, N'QLD' AS 'State',
     N'Unbilled Revenue' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'QLD' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3)

     UNION

SELECT  61 AS Number, N'SA ' AS 'State',
     N'Consumption' AS 'Column', 
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage')
UNION
SELECT  62 AS Number, N'SA ' AS 'State',
     N'Unbilled Days' AS 'Column', 
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  63 AS Number, N'SA ' AS 'State',
     N'Sites' AS 'Column', 
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  64 AS Number, N'SA ' AS 'State',
     N'Usage Charge' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage')
UNION
SELECT  65 AS Number, N'SA ' AS 'State',
     N'Standing Charge' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  66 AS Number, N'SA ' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  67 AS Number, N'SA ' AS 'State',
     N'Average Usage Cost' AS 'Column', 
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage')/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage')/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage')/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage') * 1000)
UNION
SELECT  68 AS Number, N'SA ' AS 'State',
     N'Average Daily Cost' AS 'Column', 
     (SELECT AVG(UnbilledSum) FROM (SELECT SUM([TotalUnbilledRevenue]/[UnbilledDays]) AS UnbilledSum FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily' GROUP BY [MarketIdentifier]) inner_query),
     (SELECT AVG(UnbilledSum) FROM (SELECT SUM([TotalUnbilledRevenue]/[UnbilledDays]) AS UnbilledSum FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily' GROUP BY [MarketIdentifier]) inner_query),
     (SELECT AVG(UnbilledSum) FROM (SELECT SUM([TotalUnbilledRevenue]/[UnbilledDays]) AS UnbilledSum FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily' GROUP BY [MarketIdentifier]) inner_query)
UNION
SELECT  69 AS Number, N'SA ' AS 'State',
     N'Average Total Cost' AS 'Column', 
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1)/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2)/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3)/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage') * 1000)
UNION
SELECT  70 AS Number, N'SA ' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  71 AS Number, N'SA ' AS 'State',
     N'Customer type - % of Total Unbilled Revenue' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1)/(SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND ReportDate = @ReportDate1),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2)/(SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND ReportDate = @ReportDate2),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3)/(SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND ReportDate = @ReportDate3)
UNION
SELECT  72 AS Number, N'SA ' AS 'State',
     N'Customer type - % of Total Unbilled Sites' AS 'Column', 
     CAST((SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily') AS float)/(SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     CAST((SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily') AS float)/(SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     CAST((SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily') AS float)/(SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  73 AS Number, N'SA ' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  74 AS Number, N'SA ' AS 'State',
     N'Sites unbilled > 90 days (Sites)' AS 'Column', 
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')
UNION
SELECT  75 AS Number, N'SA ' AS 'State',
     N'Sites unbilled > 90 days (Usage)' AS 'Column', 
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate1 AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate2 AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate3 AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'))
UNION
SELECT  76 AS Number, N'SA ' AS 'State',
     N'Sites unbilled > 90 days (Days)' AS 'Column', 
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate1 AND [ScheduleType] = N'Daily' AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate2 AND [ScheduleType] = N'Daily' AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate3 AND [ScheduleType] = N'Daily' AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'))
UNION
SELECT  77 AS Number, N'SA ' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  78 AS Number, N'SA ' AS 'State',
     N'Unbilled Revenue' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'SA ' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3)

     UNION

SELECT  81 AS Number, N'VIC' AS 'State',
     N'Consumption' AS 'Column', 
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage')
UNION
SELECT  82 AS Number, N'VIC' AS 'State',
     N'Unbilled Days' AS 'Column', 
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  83 AS Number, N'VIC' AS 'State',
     N'Sites' AS 'Column', 
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  84 AS Number, N'VIC' AS 'State',
     N'Usage Charge' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage')
UNION
SELECT  85 AS Number, N'VIC' AS 'State',
     N'Standing Charge' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  86 AS Number, N'VIC' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  87 AS Number, N'VIC' AS 'State',
     N'Average Usage Cost' AS 'Column', 
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage')/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage')/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage')/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage') * 1000)
UNION
SELECT  88 AS Number, N'VIC' AS 'State',
     N'Average Daily Cost' AS 'Column', 
     (SELECT AVG(UnbilledSum) FROM (SELECT SUM([TotalUnbilledRevenue]/[UnbilledDays]) AS UnbilledSum FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily' GROUP BY [MarketIdentifier]) inner_query),
     (SELECT AVG(UnbilledSum) FROM (SELECT SUM([TotalUnbilledRevenue]/[UnbilledDays]) AS UnbilledSum FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily' GROUP BY [MarketIdentifier]) inner_query),
     (SELECT AVG(UnbilledSum) FROM (SELECT SUM([TotalUnbilledRevenue]/[UnbilledDays]) AS UnbilledSum FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily' GROUP BY [MarketIdentifier]) inner_query)
UNION
SELECT  89 AS Number, N'VIC' AS 'State',
     N'Average Total Cost' AS 'Column', 
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1)/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2)/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Usage') * 1000),
     ((SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3)/(SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Usage') * 1000)
UNION
SELECT  90 AS Number, N'VIC' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  91 AS Number, N'VIC' AS 'State',
     N'Customer type - % of Total Unbilled Revenue' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1)/(SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND ReportDate = @ReportDate1),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2)/(SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND ReportDate = @ReportDate2),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3)/(SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND ReportDate = @ReportDate3)
UNION
SELECT  92 AS Number, N'VIC' AS 'State',
     N'Customer type - % of Total Unbilled Sites' AS 'Column', 
     CAST((SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily') AS float)/(SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND ReportDate = @ReportDate1 AND ScheduleType = N'Daily'),
     CAST((SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily') AS float)/(SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND ReportDate = @ReportDate2 AND ScheduleType = N'Daily'),
     CAST((SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily') AS float)/(SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND ReportDate = @ReportDate3 AND ScheduleType = N'Daily')
UNION
SELECT  93 AS Number, N'VIC' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  94 AS Number, N'VIC' AS 'State',
     N'Sites unbilled > 90 days (Sites)' AS 'Column', 
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'),
     (SELECT COUNT(DISTINCT [MarketIdentifier]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')
UNION
SELECT  95 AS Number, N'VIC' AS 'State',
     N'Sites unbilled > 90 days (Usage)' AS 'Column', 
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate1 AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate2 AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([TotalUnbilledUsage]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate3 AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'))
UNION
SELECT  96 AS Number, N'VIC' AS 'State',
     N'Sites unbilled > 90 days (Days)' AS 'Column', 
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate1 AND [ScheduleType] = N'Daily' AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate2 AND [ScheduleType] = N'Daily' AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily')),
     (SELECT SUM([UnbilledDays]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE ReportDate = @ReportDate3 AND [ScheduleType] = N'Daily' AND [MarketIdentifier] IN (SELECT [MarketIdentifier] FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3 AND DATEDIFF(day,UnbilledFromDate,ReportDate) > 90 AND ScheduleType = N'Daily'))
UNION
SELECT  97 AS Number, N'VIC' AS 'State',
     N'' AS 'Column', 
     NULL,
     NULL,
     NULL
UNION
SELECT  98 AS Number, N'VIC' AS 'State',
     N'Unbilled Revenue' AS 'Column', 
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate1),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate2),
     (SELECT SUM([TotalUnbilledRevenue]) FROM [DW_Access].[Views].[UnbilledRevenueReport] WHERE DistrictState = N'VIC' AND CustomerType LIKE @CustomerType AND ReportDate = @ReportDate3)

END;






GO