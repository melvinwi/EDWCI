USE [DW_Access]
GO

/****** Object:  StoredProcedure [exceptions].[UnbilledRevenueException]    Script Date: 19/12/2014 10:40:11 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Melvin Widodo
-- Create date: 19 Dec 2014
-- Description:	
-- =============================================
CREATE PROCEDURE [exceptions].[UnbilledRevenueException]
	-- Add the parameters for the stored procedure here
	@InputDate DATE
AS
BEGIN

--DECLARE @InputDate date6
DECLARE @ReportDate date
DECLARE @ReportStartDate INT

DECLARE @IntStartDate INT
DECLARE @IntEndDate INT


DECLARE @ReportId INT
DECLARE @ExceptionCode INT
DECLARE @ExceptionDesc VARCHAR(255)



IF OBJECT_ID (N'tempdb..#UnbilledRevenue') IS NOT NULL DROP TABLE #UnbilledRevenue;
CREATE TABLE #UnbilledRevenue
(
	ServiceId					INT
	, ServiceKey				INT 
	, MarketIdentifier			NVARCHAR (30) NULL
	, UnbilledFromDate			INT
	, UnbilledToDate			INT

	, ConnectedDate INT
	, LastBilledReadDate INT
	, FRMPDate INT
	, TerminatedDate INT
)




--SET @InputDate = '2014-07-01';

;WITH Fiscal AS 
(
	SELECT FiscalMonthNumber, FiscalYear
	FROM DW_Dimensional.DW.DimDate
	WHERE [Date] = @InputDate
)
SELECT @IntStartDate = MIN(DateId), @IntEndDate = MAX(DateId), @ReportDate = MAX([Date])
FROM DW_Dimensional.DW.DimDate
	INNER JOIN Fiscal ON Fiscal.FiscalMonthNumber = DimDate.FiscalMonthNumber
		AND Fiscal.FiscalYear = DimDate.FiscalYear;


WITH t AS (SELECT
CASE WHEN (FiscalMonthNumber -8) < 1 THEN
(FiscalMonthNumber + 4)
ELSE (FiscalMonthNumber -8) END AS AdjustedFiscalMonth, 
CASE WHEN (FiscalMonthNumber -8) < 1 THEN
CAST(RIGHT(FiscalYear,4) AS int) - 1 ELSE 
CAST(RIGHT(FiscalYear,4) AS int) END AS AdjustedFiscalYear
FROM DW_Dimensional.DW.DimDate
WHERE DATE = @InputDate)
SELECT @ReportStartDate = CONVERT(VARCHAR, MIN([Date]), 112) FROM DW_Dimensional.DW.DimDate
INNER JOIN t
ON t.AdjustedFiscalMonth = DimDate.FiscalMonthNumber
AND t.AdjustedFiscalYear = CAST(RIGHT(DimDate.FiscalYear,4) AS int);


--SELECT @ReportStartDate, @IntStartDate, @IntEndDate



----- Collect Site and Data Range --------------------
INSERT INTO #UnbilledRevenue(ServiceId, ServiceKey, MarketIdentifier, UnbilledFromDate, UnbilledToDate
	, ConnectedDate, FRMPDate, LastBilledReadDate, TerminatedDate)

	SELECT DimService.ServiceId, DimService.ServiceKey, DimService.MarketIdentifier

		, CAST((SELECT MAX(UnbilledFromDate)
			FROM (VALUES (Bill.LastBilledReadDate)
					--, (FactContract.ContractConnectedDateId)
					, (FactContract.ContractFRMPDateId)
				) u (UnbilledFromDate)) AS NCHAR(8)) AS UnbilledFromDate
		, CAST((SELECT MIN(UnbilledToDate)
			FROM   (VALUES (@IntEndDate)
					, (FactContract.ContractTerminatedDateId)
				) t (UnbilledToDate)) AS NCHAR(8)) AS UnbilledToDate

		, FactContract.ContractConnectedDateId, FactContract.ContractFRMPDateId, Bill.LastBilledReadDate, FactContract.ContractTerminatedDateId

	FROM [DW_Dimensional].DW.FactContract FactContract
		INNER JOIN [DW_Dimensional].DW.DimService DimService ON DimService.ServiceId = FactContract.ServiceId
			--AND DimService.Meta_IsCurrent = 1

		LEFT JOIN (
			SELECT DimService.ServiceKey, MAX(FactTransaction.EndDateId) AS LastBilledReadDate
			FROM   DW_Dimensional.DW.FactTransaction
				INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactTransaction.ServiceId
			WHERE  FactTransaction.TransactionSubtype = 'Daily charge'
				AND    FactTransaction.Reversal <> 'Yes' AND    FactTransaction.Reversed <> 'Yes'
				AND    (FactTransaction.EndDateId BETWEEN @IntStartDate AND @IntEndDate )
				AND    FactTransaction.EndDateId <> 99991231
			GROUP  BY DimService.ServiceKey
		) Bill ON Bill.ServiceKey = DimService.ServiceKey

	WHERE 0 = 0
		AND  ( ----- Active Customer --------------------
				(@IntStartDate BETWEEN FactContract.ContractConnectedDateId AND FactContract.ContractTerminatedDateId)
				OR (@IntEndDate BETWEEN FactContract.ContractConnectedDateId AND FactContract.ContractTerminatedDateId)
			
				OR (FactContract.ContractConnectedDateId BETWEEN @IntStartDate AND @IntEndDate)
				OR (FactContract.ContractTerminatedDateId  BETWEEN @IntStartDate AND @IntEndDate)
			)


-- Only report the last eight months of unbilled revenue
UPDATE #UnbilledRevenue
SET    UnbilledFromDate = @ReportStartDate
WHERE  UnbilledFromDate < @ReportStartDate;



--TRUNCATE TABLE  [DW_Access].exceptions.UnbilledRevenueReport


----- Exception Code Pattern -------------------------
-- '60001' 
-- 6#### = 'Finance'; 00001 = 'Unbilled Revenue'
-- '####' -- > Category



----- Meter --------------------------------------------------------------------------------
----- Site Without Meter Register --------------------
SET @ExceptionCode = '600010001'
SET @ExceptionDesc = 'Site without meter register'

INSERT INTO exceptions.UnbilledRevenueReport (ServiceKey, MarketIdentifier
	, ExceptionCode, ExceptionDesc, ReportDateId
	, ExceptionDetails)

SELECT DISTINCT #UnbilledRevenue.ServiceKey, #UnbilledRevenue.MarketIdentifier
	, @ExceptionCode, @ExceptionDesc, @ReportDate
	, 'ServiceId=''' + CONVERT(NVARCHAR, #UnbilledRevenue.ServiceId) + ''''
FROM #UnbilledRevenue
	LEFT JOIN [DW_Dimensional].DW.FactServiceMeterRegister FactMeter ON FactMeter.ServiceId = #UnbilledRevenue.ServiceId
	LEFT JOIN [DW_Dimensional].DW.DimMeterRegister DimMeter ON DimMeter.MeterRegisterId = FactMeter.MeterRegisterId
		AND DimMeter.Meta_IsCurrent = 1
WHERE DimMeter.MeterRegisterId  IS NULL



----- Price Plan ----------------------------------------------------------------------------------------------------
----- Daily Price Plan --------------------
SET @ExceptionCode = '600010002'
SET @ExceptionDesc = 'Site without Daily Price Plan'

INSERT INTO exceptions.UnbilledRevenueReport (ServiceKey, MarketIdentifier
	, ExceptionCode, ExceptionDesc, ReportDateId
	, ExceptionDetails)

	SELECT  DISTINCT  #UnbilledRevenue.ServiceKey, #UnbilledRevenue.MarketIdentifier
		, @ExceptionCode, @ExceptionDesc, @ReportDate
		, 'ServiceId=''' + CONVERT(NVARCHAR, #UnbilledRevenue.ServiceId) + ''''

	FROM #UnbilledRevenue
	
		LEFT JOIN [DW_Dimensional].DW.FactDailyPricePlan FactDailyPlan ON FactDailyPlan.ServiceId = #UnbilledRevenue.ServiceId
			AND (
				(@IntStartDate BETWEEN FactDailyPlan.DailyPricePlanStartDateId AND FactDailyPlan.DailyPricePlanEndDateId)
				OR (@IntEndDate BETWEEN FactDailyPlan.DailyPricePlanStartDateId AND FactDailyPlan.DailyPricePlanEndDateId)
			
				OR (FactDailyPlan.DailyPricePlanStartDateId BETWEEN @IntStartDate AND @IntEndDate)
				OR (FactDailyPlan.DailyPricePlanStartDateId  BETWEEN @IntStartDate AND @IntEndDate)
			)

		LEFT JOIN [DW_Dimensional].DW.DimPricePlan DimPricePlan ON DimPricePlan.PricePlanId = FactDailyPlan.PricePlanId
			--AND DimPricePlan.Meta_IsCurrent = 1
	WHERE PricePlanCode IS NULL



----- Usage Price Plan --------------------
SET @ExceptionCode = '600010003'
SET @ExceptionDesc = 'Site / Meter without Meter / Usage Price Plan'

INSERT INTO exceptions.UnbilledRevenueReport (ServiceKey, MarketIdentifier
	, ExceptionCode, ExceptionDesc, ReportDateId
	, ExceptionDetails)

	SELECT DISTINCT #UnbilledRevenue.ServiceKey, #UnbilledRevenue.MarketIdentifier
		, @ExceptionCode, @ExceptionDesc, @ReportDate
		, 'ServiceId=''' + CONVERT(NVARCHAR, #UnbilledRevenue.ServiceId) + ''''
			+ ' AND DimMeter.MeterMarketSerialNumber=''' + ISNULL(CONVERT(NVARCHAR, DimMeter.MeterMarketSerialNumber), '') + ''''
			+ ' AND DimMeter.RegisterMarketIdentifier=''' + ISNULL(CONVERT(NVARCHAR, DimMeter.RegisterMarketIdentifier), '') + ''''

	FROM #UnbilledRevenue
		INNER JOIN [DW_Dimensional].DW.FactServiceMeterRegister FactMeter ON FactMeter.ServiceId = #UnbilledRevenue.ServiceId
		INNER JOIN [DW_Dimensional].DW.DimMeterRegister DimMeter ON DimMeter.MeterRegisterId = FactMeter.MeterRegisterId
			--AND DimMeter.Meta_IsCurrent = 1
	
		LEFT JOIN [DW_Dimensional].DW.FactUsagePricePlan FactUsagePlan ON FactUsagePlan.ServiceId = #UnbilledRevenue.ServiceId
			AND FactUsagePlan.MeterRegisterId = DimMeter.MeterRegisterId
			AND (
				(@IntStartDate BETWEEN FactUsagePlan.UsagePricePlanStartDateId AND FactUsagePlan.UsagePricePlanEndDateId)
				OR (@IntEndDate BETWEEN FactUsagePlan.UsagePricePlanStartDateId AND FactUsagePlan.UsagePricePlanEndDateId)
			
				OR (FactUsagePlan.UsagePricePlanStartDateId BETWEEN @IntStartDate AND @IntEndDate)
				OR (FactUsagePlan.UsagePricePlanEndDateId  BETWEEN @IntStartDate AND @IntEndDate)
			)

		LEFT JOIN [DW_Dimensional].DW.DimPricePlan DimPricePlan ON DimPricePlan.PricePlanId = FactUsagePlan.PricePlanId
			AND DimPricePlan.Meta_IsCurrent = 1
	WHERE PricePlanCode IS NOT NULL




----- Consumption ----------------------------------------------------------------------------------------------------
----- Collect Consumption --------------------
IF OBJECT_ID (N'tempdb..#SettlementCase') IS NOT NULL DROP TABLE #SettlementCase;
SELECT SettlementCase, MIN(SettlementDateId) PeriodStart, MAX(SettlementDateId) PeriodEnd
	, RANK ( ) OVER ( PARTITION BY MIN(SettlementDateId), MAX(SettlementDateId) ORDER BY SettlementCase DESC ) RankIdx
INTO #SettlementCase
FROM [DW_Dimensional].[DW].[FactServiceDailyLoad] FactCons
	LEFT JOIN #UnbilledRevenue ON #UnbilledRevenue.MarketIdentifier = FactCons.MarketIdentifier
WHERE FactCons.SettlementDateId BETWEEN ISNULL(#UnbilledRevenue.UnbilledFromDate, @IntStartDate) AND ISNULL(#UnbilledRevenue.UnbilledToDate, @IntEndDate)
GROUP BY SettlementCase

IF OBJECT_ID (N'tempdb..#Consumption') IS NOT NULL DROP TABLE #Consumption;
SELECT DISTINCT MarketIdentifier, SettlementDateId
INTO #Consumption
FROM [DW_Dimensional].[DW].[FactServiceDailyLoad] FactCons
	INNER JOIN  #SettlementCase ON #SettlementCase.SettlementCase = FactCons.SettlementCase



----- Sites in AEMO not in ORION --------------------
SET @ExceptionCode = '600010004'
SET @ExceptionDesc = 'Sites in AEMO not in ORION'

INSERT INTO exceptions.UnbilledRevenueReport (ServiceKey, MarketIdentifier
	, ExceptionCode, ExceptionDesc, ReportDateId
	, ExceptionDetails)

	SELECT DISTINCT NULL, #Consumption.MarketIdentifier
		, @ExceptionCode, @ExceptionDesc, @ReportDate

		, 'MarketIdentifier=''' + CONVERT(NVARCHAR, #Consumption.MarketIdentifier) + ''''
			+ ' AND MinimumSettlemendDateId=''' + ISNULL(CONVERT(NVARCHAR, MIN(#Consumption.SettlementDateId)), '') + ''''
			+ ' AND MaximumSettlemendDateId=''' + ISNULL(CONVERT(NVARCHAR, MAX(#Consumption.SettlementDateId)), '') + ''''
	
	FROM #Consumption
		LEFT JOIN #UnbilledRevenue ON #UnbilledRevenue.MarketIdentifier = #Consumption.MarketIdentifier
			AND #Consumption.SettlementDateId BETWEEN #UnbilledRevenue.UnbilledFromDate AND #UnbilledRevenue.UnbilledToDate
	WHERE #UnbilledRevenue.UnbilledFromDate IS NULL
	GROUP BY #Consumption.MarketIdentifier
	ORDER BY MarketIdentifier




IF OBJECT_ID (N'tempdb..#WithoutConsumption') IS NOT NULL DROP TABLE #WithoutConsumption;

SELECT DISTINCT #UnbilledRevenue.ServiceId, #UnbilledRevenue.ServiceKey, #UnbilledRevenue.MarketIdentifier
	, #UnbilledRevenue.UnbilledFromDate, #UnbilledRevenue.UnbilledToDate
INTO #WithoutConsumption
FROM #UnbilledRevenue
	LEFT JOIN #Consumption ON #Consumption.MarketIdentifier = #UnbilledRevenue.MarketIdentifier
		AND #Consumption.SettlementDateId BETWEEN #UnbilledRevenue.UnbilledFromDate AND #UnbilledRevenue.UnbilledToDate

WHERE  #Consumption.SettlementDateId IS NULL



----- Sites in Orion not in AEMO  --------------------
SET @ExceptionCode = '600010005'
SET @ExceptionDesc = 'Sites in Orion not in AEMO'

INSERT INTO exceptions.UnbilledRevenueReport (ServiceKey, MarketIdentifier
	, ExceptionCode, ExceptionDesc, ReportDateId
	, ExceptionDetails)
		
	SELECT DISTINCT ServiceKey, MarketIdentifier
		, @ExceptionCode, @ExceptionDesc, @ReportDate
		, 'ServiceId=''' + CONVERT(NVARCHAR, ServiceId) + ''''
			+ ' AND UnbilledFromDate=''' + ISNULL(CONVERT(NVARCHAR, UnbilledFromDate), '') + ''''
			+ ' AND UnbilledToDate=''' + ISNULL(CONVERT(NVARCHAR, UnbilledToDate), '') + ''''

	FROM #WithoutConsumption





----- Site without consumption but Energised  --------------------
SET @ExceptionCode = '600010006'
SET @ExceptionDesc = 'Site without consumption but energised'

INSERT INTO exceptions.UnbilledRevenueReport (ServiceKey, MarketIdentifier
	, ExceptionCode, ExceptionDesc, ReportDateId
	, ExceptionDetails)
		
	SELECT DISTINCT Cons.ServiceId, Cons.MarketIdentifier
		, @ExceptionCode, @ExceptionDesc, @ReportDate
		, 'MarketIdentifier=''' + CONVERT(NVARCHAR, Cons.MarketIdentifier) + ''''
			+ ' AND UnbilledFromDate=''' + ISNULL(CONVERT(NVARCHAR, UnbilledFromDate), '') + ''''
			+ ' AND UnbilledToDate=''' + ISNULL(CONVERT(NVARCHAR, UnbilledToDate), '') + ''''
	FROM #WithoutConsumption Cons
		LEFT JOIN [DW_Dimensional].[DW].[DimService] DimService ON DimService.MarketIdentifier = Cons.MarketIdentifier
			AND DimService.SiteStatusType = 'Energised Site'
			AND DimService.ServiceType = 'Electricity'
			AND 
			(
				(Cons.UnbilledFromDate BETWEEN CONVERT(VARCHAR(8), DimService.Meta_EffectiveStartDate, 112) AND CONVERT(VARCHAR(8), DimService.Meta_EffectiveEndDate, 112))
				OR (Cons.UnbilledToDate BETWEEN CONVERT(VARCHAR(8), DimService.Meta_EffectiveStartDate, 112) AND CONVERT(VARCHAR(8), DimService.Meta_EffectiveEndDate, 112))

				OR (CONVERT(VARCHAR(8), DimService.Meta_EffectiveStartDate, 112) BETWEEN Cons.UnbilledFromDate AND Cons.UnbilledToDate)
				OR (CONVERT(VARCHAR(8), DimService.Meta_EffectiveEndDate, 112) BETWEEN Cons.UnbilledFromDate AND Cons.UnbilledToDate)
			)
	WHERE DimService.ServiceId IS NOT NULL


----- Site without consumption but Energised  --------------------
SET @ExceptionCode = '600010007'
SET @ExceptionDesc = 'Site with consumption but de-energised'

INSERT INTO exceptions.UnbilledRevenueReport (ServiceKey, MarketIdentifier
	, ExceptionCode, ExceptionDesc, ReportDateId
	, ExceptionDetails)
		
	SELECT DISTINCT NULL, Cons.MarketIdentifier
		, @ExceptionCode, @ExceptionDesc, @ReportDate
		, 'MarketIdentifier=''' + CONVERT(NVARCHAR, Cons.MarketIdentifier) + ''''
			+ ' AND MinimumSettlemendDateId=''' + ISNULL(CONVERT(NVARCHAR, MIN(Cons.SettlementDateId)), '') + ''''
			+ ' AND MaximumSettlemendDateId=''' + ISNULL(CONVERT(NVARCHAR, MAX(Cons.SettlementDateId)), '') + ''''
----- De-Energised Site --------------------
	FROM #Consumption Cons
		LEFT JOIN [DW_Dimensional].[DW].[DimService] DimService ON DimService.MarketIdentifier = Cons.MarketIdentifier
			AND DimService.SiteStatusType = 'De-Energised Site'
			AND DimService.ServiceType = 'Electricity'
			AND Cons.SettlementDateId BETWEEN CONVERT(VARCHAR(8), Meta_EffectiveStartDate, 112) AND CONVERT(VARCHAR(8), Meta_EffectiveEndDate, 112)
	WHERE ServiceId IS NOT NULL
	GROUP BY Cons.MarketIdentifier





--SELECT DISTINCT ExceptionCode
--FROM exceptions.UnbilledRevenueReport






END

GO


