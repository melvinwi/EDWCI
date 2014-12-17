DECLARE @InputDate date
DECLARE @ReportDate date
DECLARE @ReportStartDate date

SET @InputDate = '2014-07-31';

WITH t AS (SELECT FiscalMonthNumber, FiscalYear
FROM DW_Dimensional.DW.DimDate
WHERE [Date] = @InputDate)
SELECT @ReportDate = MAX([Date]) FROM DW_Dimensional.DW.DimDate
INNER JOIN t
ON t.FiscalMonthNumber = DimDate.FiscalMonthNumber
AND t.FiscalYear = DimDate.FiscalYear;


WITH t AS (SELECT
CASE WHEN (FiscalMonthNumber -8) < 1 THEN
(FiscalMonthNumber + 4)
ELSE (FiscalMonthNumber -8) END AS AdjustedFiscalMonth, 
CASE WHEN (FiscalMonthNumber -8) < 1 THEN
CAST(RIGHT(FiscalYear,4) AS int) - 1 ELSE 
CAST(RIGHT(FiscalYear,4) AS int) END AS AdjustedFiscalYear
FROM DW_Dimensional.DW.DimDate
WHERE DATE = @InputDate)
SELECT @ReportStartDate = MIN([Date]) FROM DW_Dimensional.DW.DimDate
INNER JOIN t
ON t.AdjustedFiscalMonth = DimDate.FiscalMonthNumber
AND t.AdjustedFiscalYear = CAST(RIGHT(DimDate.FiscalYear,4) AS int);

--Drop and create temporary table
IF OBJECT_ID (N'tempdb..#UnbilledRevenue') IS NOT NULL
    BEGIN
        DROP TABLE #UnbilledRevenue;
    END;

CREATE TABLE #UnbilledRevenue
(
FinancialMonth				 tinyint		  NULL,
ReportDate				 date		  NULL,
AccountingPeriod			 int			  NULL,
AccountNumber				 int			  NULL,
CustomerName				 nvarchar (100) NULL,
CustomerType				 nchar (11) NULL,
AccountStatus				 nchar (10) NULL,
BillingCycle				 nchar (10) NULL,
TNICode					 nvarchar (20) NULL,
NetworkState				 nchar (3) NULL,
MarketIdentifier			 nvarchar (30) NULL,
ServiceStatus				 nvarchar (30) NULL,
ServiceActiveStartDate		 date	   	  NULL,
ServiceActiveEndDate		 date	   	  NULL,
FRMPStartDate				 date		  NULL,
ContractTerminatedDate		 date		  NULL,
FuelType					 nvarchar (11) NULL,
SiteMeteringType			 nchar (6) NULL,
ServiceState				 nchar (3) NULL,
SiteEDC					 decimal (18, 6) NULL,
DLF						 decimal (6, 4) NULL,
MeterRegisterEDC			 decimal (18, 6) NULL,
MeterMarketSerialNumber		 nvarchar (50) NULL,
MeterRegisterKey			 int			  NULL,
MeterSystemSerialNumber		 nvarchar (50) NULL,
RegisterMultiplier			 decimal (18, 6) NULL,
MeterRegisterBillingType		 nvarchar (100) NULL,
MeterRegisterReadDirection	 nchar (6) NULL,
MeterRegisterStatus			 nchar (8) NULL,
MeterRegisterActiveStartDate	 date		  NULL,
MeterRegisterActiveEndDate	 date		  NULL,
NetworkTariffCode			 nvarchar (20) NULL,
LastBilledRead				 decimal (18, 4) NULL,
LastBilledReadDate			 date		  NULL,
ScheduleType				 nchar (5) NULL,
FixedTariffAdjustment		 decimal (5, 4) NULL,
VariableTariffAdjustment		 decimal (5, 4) NULL,
PricePlanStartDate			 date		  NULL,
PricePlanEndDate			 date		  NULL,
PricePlanCode				 nvarchar (20) NULL,
BundledFlag				 nvarchar (11) NULL,
PriceStep1				 money		  NULL,
PriceStep2				 money		  NULL,
PriceStep3				 money		  NULL,
PriceStep4				 money		  NULL,
PriceStep5				 money		  NULL,
UnitStep1					 decimal (18, 7) NULL,
UnitStep2					 decimal (18, 7) NULL,
UnitStep3					 decimal (18, 7) NULL,
UnitStep4					 decimal (18, 7) NULL,
UnbilledFromDate			 date		  NULL,
UnbilledToDate				 date		  NULL,
UnbilledDays				 int			  NULL,
SettlementUsageEndDate		 date		  NULL,
SettlementUsage			 decimal (18, 7) NULL,
ForecastedUsage			 decimal (18, 7) NULL,
TotalUnbilledUsage			 decimal (18, 7) NULL,
TotalUnbilledRevenue		 money		  NULL,
ServiceKey				 int			  NULL,
PricePlanKey				 nvarchar (30) NULL,
RateStartDateId			 int			  NULL,
RateEndDateId				 int			  NULL
);
--/

-- Insert testing records
INSERT INTO #UnbilledRevenue (
ReportDate,
ServiceKey,
MeterRegisterKey,
PricePlanKey,
RateStartDateId,
RateEndDateId,
UnbilledFromDate,
UnbilledToDate,
ScheduleType
)
VALUES (
@ReportDate,
1283940,
NULL,
N'DAILY.26116',
20130701,
20140630,
'2014-06-01',
'2014-06-30',
N'Daily'),
(
@ReportDate,
1283940,
NULL,
N'DAILY.26116',
20140701,
99991231,
'2014-07-01',
'2014-08-23',
N'Daily'), 
(
@ReportDate,
21255,
3269436,
N'USAGE.33382',
20140401,
20140630,
'2014-06-01',
'2014-06-30',
N'Usage'),
(
@ReportDate,
21255,
3269436,
N'USAGE.33382',
20140701,
99991231,
'2014-07-01',
'2014-08-23',
N'Usage'),
(
@ReportDate,
949521,
3269190,
N'USAGE.34684',
20140701,
99991231,
'2014-07-01',
'2014-08-23',
N'Usage')

-- Insert Daily rows
INSERT INTO #UnbilledRevenue (
  ReportDate,
  ScheduleType,
  ServiceKey,
  PricePlanKey,
  UnbilledFromDate,
  UnbilledToDate,
  RateStartDateId,
  RateEndDateId
)
SELECT DISTINCT
       @ReportDate,
       N'Daily',
       DailyPricePlans.ServiceKey,
       DailyPricePlans.PricePlanKey,
       CONVERT(DATE, CAST((SELECT MAX(UnbilledFromDate)
                          FROM    (VALUES (Transactions.LastBilledReadDate),
                                          (DailyPricePlans.DailyPricePlanStartDateId),
                                          (DailyPricePlans.ContractFRMPDateId),
                                          (DailyRates.RateStartDateId)) u(UnbilledFromDate)) AS NCHAR(8)), 112) AS UnbilledFromDate,
       CONVERT(DATE, CAST((SELECT MIN(UnbilledToDate)
                           FROM   (VALUES (CONVERT(NCHAR(8), @ReportDate, 112)),
                                          (DailyPricePlans.DailyPricePlanEndDateId),
                                          (DailyPricePlans.ContractTerminatedDateId),
                                          (DailyRates.RateEndDateId)) t(UnbilledToDate)) AS NCHAR(8)), 112) AS UnbilledToDate,
       DailyRates.RateStartDateId,
       DailyRates.RateEndDateId
FROM   (SELECT DimService.ServiceKey,
               DimPricePlan.PricePlanKey,
               FactDailyPricePlan.DailyPricePlanStartDateId,
               FactDailyPricePlan.DailyPricePlanEndDateId,
               FactDailyPricePlan.ContractFRMPDateId,
               FactDailyPricePlan.ContractTerminatedDateId
        FROM   DW_Dimensional.DW.FactDailyPricePlan
        INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactDailyPricePlan.ServiceId
        INNER  JOIN DW_Dimensional.DW.DimPricePlan ON DimPricePlan.PricePlanId = FactDailyPricePlan.PricePlanId
        WHERE  FactDailyPricePlan.DailyPricePlanStartDateId <= FactDailyPricePlan.ContractTerminatedDateId
        AND    FactDailyPricePlan.DailyPricePlanStartDateId < CONVERT(NCHAR(8), @ReportDate, 112)
        AND    FactDailyPricePlan.DailyPricePlanEndDateId >= FactDailyPricePlan.ContractFRMPDateId
        AND    FactDailyPricePlan.ContractFRMPDateId <= FactDailyPricePlan.ContractTerminatedDateId
        AND    FactDailyPricePlan.ContractFRMPDateId < CONVERT(NCHAR(8), @ReportDate, 112)
        AND    DimService.ServiceType = N'Electricity'
        AND    DimService.SiteStatusType = 'Energised Site') DailyPricePlans
INNER
JOIN   (SELECT DimPricePlan.PricePlanKey,
               FactPricePlanRate.RateStartDateId,
               FactPricePlanRate.RateEndDateId
        FROM   DW_Dimensional.DW.FactPricePlanRate
        INNER  JOIN DW_Dimensional.DW.DimPricePlan ON DimPricePlan.PricePlanId = FactPricePlanRate.PricePlanId) DailyRates
ON      DailyRates.PricePlanKey = DailyPricePlans.PricePlanKey
AND     DailyRates.RateStartDateId <= DailyPricePlans.DailyPricePlanEndDateId
AND     DailyRates.RateStartDateId <= DailyPricePlans.ContractTerminatedDateId
AND     DailyRates.RateStartDateId <= CONVERT(NCHAR(8), @ReportDate, 112)
AND     DailyRates.RateEndDateId >= DailyPricePlans.DailyPricePlanStartDateId
AND     DailyRates.RateEndDateId >= DailyPricePlans.ContractFRMPDateId
LEFT
JOIN   (SELECT DimService.ServiceKey,
               MAX(FactTransaction.EndDateId) AS LastBilledReadDate
        FROM   DW_Dimensional.DW.FactTransaction
        INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactTransaction.ServiceId
        WHERE  FactTransaction.TransactionSubtype = 'Daily charge'
        AND    FactTransaction.Reversal <> 'Yes'
        AND    FactTransaction.Reversed <> 'Yes'
        AND    FactTransaction.EndDateId >= CONVERT(NCHAR(8), @ReportStartDate, 112)
        AND    FactTransaction.EndDateId <= CONVERT(NCHAR(8), @ReportDate, 112)
        AND    FactTransaction.EndDateId <> 99991231
        GROUP  BY DimService.ServiceKey) Transactions ON Transactions.ServiceKey = DailyPricePlans.ServiceKey
WHERE  COALESCE(Transactions.LastBilledReadDate, CONVERT(NCHAR(8), @ReportStartDate, 112)) <= DailyPricePlans.DailyPricePlanEndDateId
AND    COALESCE(Transactions.LastBilledReadDate, CONVERT(NCHAR(8), @ReportStartDate, 112)) <= DailyPricePlans.ContractTerminatedDateId
AND    COALESCE(Transactions.LastBilledReadDate, CONVERT(NCHAR(8), @ReportStartDate, 112)) <= DailyRates.RateEndDateId;

-- Only report the last eight months of unbilled revenue
UPDATE #UnbilledRevenue
SET    UnbilledFromDate = @ReportStartDate
WHERE  UnbilledFromDate < @ReportStartDate;

-- Set Report Month from DimDate
UPDATE #UnbilledRevenue
SET	   FinancialMonth = t.FinancialMonth
FROM	   (SELECT FiscalMonthNumber AS FinancialMonth
	   FROM DW_Dimensional.DW.DimDate
	   WHERE [Date] = @ReportDate) AS t


-- Set columns from DimAccount, DimCustomer, DimPricePlan and DimProduct for Schedule Type Daily
UPDATE #UnbilledRevenue
SET    AccountNumber =			 t.AccountNumber,
	  CustomerName  =			 t.CustomerName,
	  CustomerType  =			 t.CustomerType,
	  AccountStatus =			 t.AccountStatus,
	  BillingCycle  =			 t.BillingCycle,
	  FRMPStartDate =			 t.FRMPStartDate,
	  ContractTerminatedDate =	 t.ContractTerminatedDate,
	  FixedTariffAdjustment =	 t.FixedTariffAdjustment,
	  VariableTariffAdjustment =	 t.VariableTariffAdjustment,
	  PricePlanStartDate =		 t.DailyPricePlanStartDate,
	  PricePlanEndDate =		 t.DailyPricePlanEndDate,
	  PricePlanCode =			 t.PricePlanCode,
	  BundledFlag =			 t.BundledFlag
FROM   (SELECT
	   DimAccountCurrent.AccountCode AS AccountNumber,
	   DimCustomer.PartyName AS CustomerName,
	   DimCustomer.CustomerType,
	   DimAccountCurrent.AccountStatus,
	   DimAccountCurrent.BillCycleCode  AS BillingCycle,
	   CONVERT(DATE, CAST(FactDailyPricePlan.ContractFRMPDateId AS NCHAR(8)), 112) AS FRMPStartDate,
	   CONVERT(DATE, CAST(FactDailyPricePlan.ContractTerminatedDateId AS NCHAR(8)), 112) AS ContractTerminatedDate,
	   DimProductCurrent.FixedTariffAdjustPercentage AS FixedTariffAdjustment,
	   DimProductCurrent.VariableTariffAdjustPercentage AS VariableTariffAdjustment,
	   CONVERT(DATE, CAST(FactDailyPricePlan.DailyPricePlanStartDateId AS NCHAR(8)), 112) AS DailyPricePlanStartDate,
	   CONVERT(DATE, CAST(FactDailyPricePlan.DailyPricePlanEndDateId AS NCHAR(8)), 112) AS DailyPricePlanEndDate,
	   DimPricePlanCurrent.PricePlanCode,
	   DimPricePlanCurrent.Bundled AS BundledFlag,
	   DimService.ServiceKey,
	   DimPricePlan.PricePlanKey  
        FROM   DW_Dimensional.DW.FactDailyPricePlan
	   INNER JOIN DW_Dimensional.DW.DimService
	   ON DimService.ServiceId = FactDailyPricePlan.ServiceId
	   INNER JOIN DW_Dimensional.DW.DimPricePlan
	   ON DimPricePlan.PricePlanId = FactDailyPricePlan.PricePlanId
	   INNER JOIN DW_Dimensional.DW.DimPricePlan AS DimPricePlanCurrent
	   ON DimPricePlanCurrent.PricePlanKey = DimPricePlan.PricePlanKey
	   AND DimPricePlanCurrent.Meta_IsCurrent = 1
	   INNER JOIN DW_Dimensional.DW.DimAccount
	   ON DimAccount.AccountId = FactDailyPricePlan.AccountId
	   INNER JOIN DW_Dimensional.DW.DimAccount AS DimAccountCurrent
	   ON DimAccountCurrent.AccountCode = DimAccount.AccountCode
	   AND DimAccountCurrent.Meta_IsCurrent = 1
	   INNER JOIN DW_Dimensional.DW.DimProduct
	   ON DimProduct.ProductId = FactDailyPricePlan.ProductId
	   INNER JOIN DW_Dimensional.DW.DimProduct AS DimProductCurrent
	   ON DimProductCurrent.ProductKey = DimProduct.ProductKey
	   AND DimProductCurrent.Meta_IsCurrent = 1
	   INNER JOIN DW_Dimensional.DW.DimCustomer
	   ON DimCustomer.CustomerCode = DimAccount.AccountCode
	   AND DimCustomer.Meta_IsCurrent = 1) AS t
WHERE  #UnbilledRevenue.ScheduleType = N'Daily'
AND	  #UnbilledRevenue.ServiceKey = t.ServiceKey
AND    #UnbilledRevenue.PricePlanKey = t.PricePlanKey
AND	  #UnbilledRevenue.UnbilledFromDate >= t.DailyPricePlanStartDate
AND	  #UnbilledRevenue.UnbilledFromDate >= t.FRMPStartDate
AND	  #UnbilledRevenue.UnbilledToDate   <= t.DailyPricePlanEndDate
AND	  #UnbilledRevenue.UnbilledToDate   <= t.ContractTerminatedDate;


-- Set columns from DimAccount, DimCustomer, DimPricePlan and DimProduct for Schedule Type Usage
UPDATE #UnbilledRevenue
SET    AccountNumber =			 t.AccountNumber,
	  CustomerName  =			 t.CustomerName,
	  CustomerType  =			 t.CustomerType,
	  AccountStatus =			 t.AccountStatus,
	  BillingCycle  =			 t.BillingCycle,
	  FRMPStartDate =			 t.FRMPStartDate,
	  ContractTerminatedDate =	 t.ContractTerminatedDate,
	  FixedTariffAdjustment =	 t.FixedTariffAdjustment,
	  VariableTariffAdjustment =	 t.VariableTariffAdjustment,
	  PricePlanStartDate =		 t.UsagePricePlanStartDate,
	  PricePlanEndDate =		 t.UsagePricePlanEndDate,
	  PricePlanCode =			 t.PricePlanCode,
	  BundledFlag =			 t.BundledFlag
FROM   (SELECT
	   DimAccountCurrent.AccountCode AS AccountNumber,
	   DimCustomer.PartyName AS CustomerName,
	   DimCustomer.CustomerType  AS CustomerType,
	   DimAccountCurrent.AccountStatus AS AccountStatus,
	   DimAccountCurrent.BillCycleCode  AS BillingCycle,
	   CONVERT(DATE, CAST(FactUsagePricePlan.ContractFRMPDateId AS NCHAR(8)), 112) AS FRMPStartDate,
	   CONVERT(DATE, CAST(FactUsagePricePlan.ContractTerminatedDateId AS NCHAR(8)), 112) AS ContractTerminatedDate,
	   DimProductCurrent.FixedTariffAdjustPercentage AS FixedTariffAdjustment,
	   DimProductCurrent.VariableTariffAdjustPercentage AS VariableTariffAdjustment,
	   CONVERT(DATE, CAST(FactUsagePricePlan.UsagePricePlanStartDateId AS NCHAR(8)), 112) AS UsagePricePlanStartDate,
	   CONVERT(DATE, CAST(FactUsagePricePlan.UsagePricePlanEndDateId AS NCHAR(8)), 112) AS UsagePricePlanEndDate,
	   DimPricePlanCurrent.PricePlanCode,
	   DimPricePlanCurrent.Bundled AS BundledFlag,
	   DimService.ServiceKey,
	   DimMeterRegister.MeterRegisterKey,
	   DimPricePlan.PricePlanKey
        FROM   DW_Dimensional.DW.FactUsagePricePlan
	   INNER JOIN DW_Dimensional.DW.DimService
	   ON DimService.ServiceId = FactUsagePricePlan.ServiceId
	   INNER JOIN DW_Dimensional.DW.DimMeterRegister
	   ON DimMeterRegister.MeterRegisterId = FactUsagePricePlan.MeterRegisterId
	   INNER JOIN DW_Dimensional.DW.DimPricePlan
	   ON DimPricePlan.PricePlanId = FactUsagePricePlan.PricePlanId
	   INNER JOIN DW_Dimensional.DW.DimPricePlan AS DimPricePlanCurrent
	   ON DimPricePlanCurrent.PricePlanKey = DimPricePlan.PricePlanKey
	   AND DimPricePlanCurrent.Meta_IsCurrent = 1
	   INNER JOIN DW_Dimensional.DW.DimAccount
	   ON DimAccount.AccountId = FactUsagePricePlan.AccountId
	   INNER JOIN DW_Dimensional.DW.DimAccount AS DimAccountCurrent
	   ON DimAccountCurrent.AccountCode = DimAccount.AccountCode
	   AND DimAccountCurrent.Meta_IsCurrent = 1
	   INNER JOIN DW_Dimensional.DW.DimProduct
	   ON DimProduct.ProductId = FactUsagePricePlan.ProductId
	   INNER JOIN DW_Dimensional.DW.DimProduct AS DimProductCurrent
	   ON DimProductCurrent.ProductKey = DimProduct.ProductKey
	   AND DimProductCurrent.Meta_IsCurrent = 1
	   INNER JOIN DW_Dimensional.DW.DimCustomer
	   ON DimCustomer.CustomerCode = DimAccount.AccountCode
	   AND DimCustomer.Meta_IsCurrent = 1) t
WHERE  #UnbilledRevenue.ScheduleType = N'Usage'
AND	  #UnbilledRevenue.ServiceKey = t.ServiceKey
AND	  #UnbilledRevenue.MeterRegisterKey = t.MeterRegisterKey
AND    #UnbilledRevenue.PricePlanKey = t.PricePlanKey
AND	  #UnbilledRevenue.UnbilledFromDate >= t.UsagePricePlanStartDate
AND	  #UnbilledRevenue.UnbilledFromDate >= t.FRMPStartDate
AND	  #UnbilledRevenue.UnbilledToDate   <= t.UsagePricePlanEndDate
AND	  #UnbilledRevenue.UnbilledToDate   <= t.ContractTerminatedDate;



-- Set TNICode, NetworkState, MarketIdentifier, FuelType, SiteMeteringType, SiteEDC and DLF from DimService and DimTransmissionNode
UPDATE #UnbilledRevenue
SET    TNICode =		   t.TNICode,
	  NetworkState  =	   t.NetworkState,
	  MarketIdentifier  =  t.MarketIdentifier,
	  ServiceStatus =	   t.ServiceStatus,
	  FuelType =		   t.FuelType,
	  SiteMeteringType =   t.SiteMeteringType,
	  ServiceState =	   t.ServiceState,
	  SiteEDC =		   t.SiteEDC,
	  DLF =			   t.DLF
FROM   (SELECT
	   DimService.ServiceKey,
	   DimTransmissionNode.TransmissionNodeIdentity AS TNICode,
	   DimTransmissionNode.TransmissionNodeState AS NetworkState,
	   DimService.MarketIdentifier,
	   DimService.SiteStatusType AS ServiceStatus,
	   DimService.ServiceType AS FuelType,
	   DimService.MeteringType AS SiteMeteringType,
	   DimService.ResidentialState AS ServiceState,
	   DimService.EstimatedDailyConsumption AS SiteEDC,
	   DimService.LossFactor AS DLF,
	   DimService.Meta_EffectiveStartDate,
	   DimService.Meta_EffectiveEndDate	   
        FROM   DW_Dimensional.DW.DimService
	   INNER JOIN DW_Dimensional.DW.DimTransmissionNode
	   ON DimTransmissionNode.TransmissionNodeId = DimService.TransmissionNodeId) t
WHERE  #UnbilledRevenue.ServiceKey = t.ServiceKey
AND	  #UnbilledRevenue.UnbilledToDate >= CAST(t.Meta_EffectiveStartDate AS date)
AND    #UnbilledRevenue.UnbilledToDate <= CAST(t.Meta_EffectiveEndDate AS date);




-- Set MeterRegisterEDC, MeterMarketSerialNumber, MeterSystemSerialNumber, RegisterMultiplier, MeterRegisterBillingType, MeterRegisterReadDirection and NetworkTariffCode from DimMeterRegister
UPDATE #UnbilledRevenue
SET	   MeterRegisterEDC =			t.MeterRegisterEDC,
	   MeterMarketSerialNumber =		t.MeterMarketSerialNumber,
	   MeterSystemSerialNumber =		t.MeterSystemSerialNumber,
	   RegisterMultiplier =			t.RegisterMultiplier,
	   MeterRegisterBillingType =		t.MeterRegisterBillingType,
	   MeterRegisterReadDirection =	t.MeterRegisterReadDirection,
	   NetworkTariffCode =			t.NetworkTariffCode
FROM   (SELECT
	   DimMeterRegister.MeterRegisterKey,
	   DimMeterRegister.RegisterEstimatedDailyConsumption AS MeterRegisterEDC,
	   DimMeterRegister.MeterMarketSerialNumber,
	   DimMeterRegister.MeterSystemSerialNumber,
	   DimMeterRegister.RegisterMultiplier,
	   DimMeterRegister.RegisterBillingType AS MeterRegisterBillingType,
	   DimMeterRegister.RegisterReadDirection AS MeterRegisterReadDirection,
	   DimMeterRegister.RegisterNetworkTariffCode AS NetworkTariffCode,
	   DimMeterRegister.Meta_EffectiveStartDate,
	   DimMeterRegister.Meta_EffectiveEndDate	   
        FROM   DW_Dimensional.DW.DimMeterRegister) t
WHERE  #UnbilledRevenue.MeterRegisterKey IS NOT NULL
AND	  #UnbilledRevenue.MeterRegisterKey = t.MeterRegisterKey
AND	  #UnbilledRevenue.UnbilledToDate >= CAST(t.Meta_EffectiveStartDate AS date)
AND    #UnbilledRevenue.UnbilledToDate <= CAST(t.Meta_EffectiveEndDate AS date);




-- Set Price for Schedule Type Daily
UPDATE #UnbilledRevenue
SET    PriceStep1 = t.PriceStep1,
	  UnitStep1 =	t.UnitStep1
FROM   (SELECT 
      FactPricePlanRate.Rate AS PriceStep1,
	 FactPricePlanRate.StepEnd AS UnitStep1,
	 DimPricePlan.PricePlanKey,
	 FactPricePlanRate.RateStartDateId,
      FactPricePlanRate.RateEndDateId
  FROM [DW_Dimensional].[DW].[FactPricePlanRate]
  INNER JOIN DW_Dimensional.DW.DimPricePlan
  ON DimPricePlan.PricePlanId = FactPricePlanRate.PricePlanId) AS t
WHERE  #UnbilledRevenue.ScheduleType = N'Daily'
AND    #UnbilledRevenue.PricePlanKey = t.PricePlanKey
AND	  #UnbilledRevenue.RateStartDateId = t.RateStartDateId
AND	  #UnbilledRevenue.RateEndDateId = t.RateEndDateId;


-- Usage Step 1
UPDATE #UnbilledRevenue
SET    PriceStep1 = t.PriceStep1,
	  UnitStep1 =	t.UnitStep1
FROM   (SELECT 
      FactPricePlanRate.Rate AS PriceStep1,
	 FactPricePlanRate.StepEnd AS UnitStep1,
	 DimPricePlan.PricePlanKey,
	 FactPricePlanRate.RateStartDateId,
      FactPricePlanRate.RateEndDateId
  FROM [DW_Dimensional].[DW].[FactPricePlanRate]
  INNER JOIN DW_Dimensional.DW.DimPricePlan
  ON DimPricePlan.PricePlanId = FactPricePlanRate.PricePlanId
  WHERE RIGHT(FactPricePlanRate.PricePlanRateKey,2) = N'.0'
  OR RIGHT(FactPricePlanRate.PricePlanRateKey,2) = N'.1') AS t
WHERE  #UnbilledRevenue.ScheduleType = N'Usage'
AND    #UnbilledRevenue.PricePlanKey = t.PricePlanKey
AND	  #UnbilledRevenue.RateStartDateId = t.RateStartDateId
AND	  #UnbilledRevenue.RateEndDateId = t.RateEndDateId;


-- Usage Step 2
UPDATE #UnbilledRevenue
SET    PriceStep2 = t.PriceStep2,
	  UnitStep2 =	t.UnitStep2
FROM   (SELECT 
      FactPricePlanRate.Rate AS PriceStep2,
	 FactPricePlanRate.StepEnd AS UnitStep2,
	 DimPricePlan.PricePlanKey,
	 FactPricePlanRate.RateStartDateId,
      FactPricePlanRate.RateEndDateId
  FROM [DW_Dimensional].[DW].[FactPricePlanRate]
  INNER JOIN DW_Dimensional.DW.DimPricePlan
  ON DimPricePlan.PricePlanId = FactPricePlanRate.PricePlanId
  WHERE RIGHT(FactPricePlanRate.PricePlanRateKey,2) = N'.2') AS t
WHERE  #UnbilledRevenue.ScheduleType = N'Usage'
AND    #UnbilledRevenue.PricePlanKey = t.PricePlanKey
AND	  #UnbilledRevenue.RateStartDateId = t.RateStartDateId
AND	  #UnbilledRevenue.RateEndDateId = t.RateEndDateId;


-- Usage Step 3
UPDATE #UnbilledRevenue
SET    PriceStep3 = t.PriceStep3,
	  UnitStep3 =	t.UnitStep3
FROM   (SELECT 
      FactPricePlanRate.Rate AS PriceStep3,
	 FactPricePlanRate.StepEnd AS UnitStep3,
	 DimPricePlan.PricePlanKey,
	 FactPricePlanRate.RateStartDateId,
      FactPricePlanRate.RateEndDateId
  FROM [DW_Dimensional].[DW].[FactPricePlanRate]
  INNER JOIN DW_Dimensional.DW.DimPricePlan
  ON DimPricePlan.PricePlanId = FactPricePlanRate.PricePlanId
  WHERE RIGHT(FactPricePlanRate.PricePlanRateKey,2) = N'.3') AS t
WHERE  #UnbilledRevenue.ScheduleType = N'Usage'
AND    #UnbilledRevenue.PricePlanKey = t.PricePlanKey
AND	  #UnbilledRevenue.RateStartDateId = t.RateStartDateId
AND	  #UnbilledRevenue.RateEndDateId = t.RateEndDateId;

-- Usage Step 4
UPDATE #UnbilledRevenue
SET    PriceStep4 = t.PriceStep4,
	  UnitStep4 =	t.UnitStep4
FROM   (SELECT 
      FactPricePlanRate.Rate AS PriceStep4,
	 FactPricePlanRate.StepEnd AS UnitStep4,
	 DimPricePlan.PricePlanKey,
	 FactPricePlanRate.RateStartDateId,
      FactPricePlanRate.RateEndDateId
  FROM [DW_Dimensional].[DW].[FactPricePlanRate]
  INNER JOIN DW_Dimensional.DW.DimPricePlan
  ON DimPricePlan.PricePlanId = FactPricePlanRate.PricePlanId
  WHERE RIGHT(FactPricePlanRate.PricePlanRateKey,2) = N'.4') AS t
WHERE  #UnbilledRevenue.ScheduleType = N'Usage'
AND    #UnbilledRevenue.PricePlanKey = t.PricePlanKey
AND	  #UnbilledRevenue.RateStartDateId = t.RateStartDateId
AND	  #UnbilledRevenue.RateEndDateId = t.RateEndDateId;

-- Usage Step 5
UPDATE #UnbilledRevenue
SET    PriceStep5 = t.PriceStep5
FROM   (SELECT 
      FactPricePlanRate.Rate AS PriceStep5,
	 DimPricePlan.PricePlanKey,
	 FactPricePlanRate.RateStartDateId,
      FactPricePlanRate.RateEndDateId
  FROM [DW_Dimensional].[DW].[FactPricePlanRate]
  INNER JOIN DW_Dimensional.DW.DimPricePlan
  ON DimPricePlan.PricePlanId = FactPricePlanRate.PricePlanId
  WHERE RIGHT(FactPricePlanRate.PricePlanRateKey,2) = N'.5') AS t
WHERE  #UnbilledRevenue.ScheduleType = N'Usage'
AND    #UnbilledRevenue.PricePlanKey = t.PricePlanKey
AND	  #UnbilledRevenue.RateStartDateId = t.RateStartDateId
AND	  #UnbilledRevenue.RateEndDateId = t.RateEndDateId;


-- Set Unbilled Days
UPDATE #UnbilledRevenue
SET    UnbilledDays = (DATEDIFF(day,UnbilledFromDate,UnbilledToDate) + 1)




select * from #UnbilledRevenue