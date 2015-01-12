CREATE proc [transform].[UnbilledRevenueReport]
    @TaskExecutionInstanceID INT
  , @LatestSuccessfulTaskExecutionInstanceID INT
  , @InputDate date
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


-- Establish reporting period from @InputDate
DECLARE @ReportDate date
DECLARE @ReportStartDate date
DECLARE @AccountingPeriod int

;WITH t AS (SELECT FiscalMonthNumber, FiscalYear, AccountingPeriod
FROM DW_Dimensional.DW.DimDate
WHERE [Date] = @InputDate)
SELECT @ReportDate = MAX(DimDate.[Date]), 
@AccountingPeriod = MAX(DimDate.[AccountingPeriod]) 
FROM DW_Dimensional.DW.DimDate
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
FinancialMonth         tinyint      NULL,
ReportDate         date     NULL,
AccountingPeriod       int        NULL,
AccountNumber        int        NULL,
CustomerName         nvarchar (100) NULL,
CustomerType         nchar (11) NULL,
AccountStatus        nchar (10) NULL,
BillingCycle         nchar (10) NULL,
TNICode          nvarchar (20) NULL,
NetworkState         nchar (3) NULL,
MarketIdentifier       nvarchar (30) NULL,
ServiceStatus        nvarchar (30) NULL,
ServiceActiveStartDate     date       NULL,
ServiceActiveEndDate     date       NULL,
FRMPStartDate        date     NULL,
ContractTerminatedDate     date     NULL,
FuelType           nvarchar (11) NULL,
SiteMeteringType       nchar (6) NULL,
ServiceState         nchar (3) NULL,
SiteEDC          decimal (18, 6) NULL,
DLF            decimal (6, 4) NULL,
MeterRegisterEDC       decimal (18, 6) NULL,
MeterMarketSerialNumber    nvarchar (50) NULL,
MeterRegisterKey       int        NULL,
MeterSystemSerialNumber    nvarchar (50) NULL,
RegisterMultiplier       decimal (18, 6) NULL,
MeterRegisterBillingTypeCode     nvarchar (100) NULL,
MeterRegisterReadDirection   nchar (6) NULL,
MeterRegisterStatus      nchar (8) NULL,
MeterRegisterActiveStartDate   date     NULL,
MeterRegisterActiveEndDate   date     NULL,
NetworkTariffCode      nvarchar (20) NULL,
LastBilledRead         decimal (18, 4) NULL,
LastBilledReadDate       date     NULL,
LastBilledReadType      nchar(9)  NULL,
ScheduleType         nchar (5) NULL,
FixedTariffAdjustment    decimal (5, 4) NULL,
VariableTariffAdjustment     decimal (5, 4) NULL,
PricePlanStartDate       date     NULL,
PricePlanEndDate       date     NULL,
PricePlanCode        nvarchar (20) NULL,
BundledFlag        nvarchar (11) NULL,
PriceStep1         money      NULL,
PriceStep2         money      NULL,
PriceStep3         money      NULL,
PriceStep4         money      NULL,
PriceStep5         money      NULL,
UnitStep1          decimal (18, 7) NULL,
UnitStep2          decimal (18, 7) NULL,
UnitStep3          decimal (18, 7) NULL,
UnitStep4          decimal (18, 7) NULL,
UnbilledFromDate       date     NULL,
UnbilledToDate         date     NULL,
UnbilledDays         int        NULL,
SettlementUsageEndDate     date     NULL,
SettlementUsage      decimal (18, 7) NULL,
EstimatedUsage      decimal (18, 7) NULL,
TotalUnbilledUsage       decimal (18, 7) NULL,
TotalUnbilledRevenue     money      NULL,
ServiceKey         int        NULL,
PricePlanKey         nvarchar (30) NULL,
RateStartDateId      int        NULL,
RateEndDateId        int        NULL
);
--/

-- Insert initial Daily and Usage rows
INSERT INTO #UnbilledRevenue (
  ReportDate,
  AccountingPeriod,
  ScheduleType,
  ServiceKey,
  MeterRegisterKey,
  PricePlanKey,
  UnbilledFromDate,
  UnbilledToDate,
  RateStartDateId,
  RateEndDateId,
  LastBilledReadDate,
  LastBilledRead
)
SELECT @ReportDate,
     @AccountingPeriod,
       PricePlans.ScheduleType,
       PricePlans.ServiceKey,
       PricePlans.MeterRegisterKey,
       PricePlans.PricePlanKey,
       CONVERT(DATE, CAST((SELECT MAX(UnbilledFromDate)
                          FROM    (VALUES (COALESCE(UsageTransactions.LastBilledReadDate, Transactions.LastBilledReadDate)),
                                          (PricePlans.DailyPricePlanStartDateId),
                                          (PricePlans.ContractFRMPDateId),
                                          (Rates.RateStartDateId)) u(UnbilledFromDate)) AS NCHAR(8)), 112) AS UnbilledFromDate,
       CONVERT(DATE, CAST((SELECT MIN(UnbilledToDate)
                           FROM   (VALUES (CONVERT(NCHAR(8), @ReportDate, 112)),
                                          (PricePlans.DailyPricePlanEndDateId),
                                          (PricePlans.ContractTerminatedDateId),
                                          (Rates.RateEndDateId)) t(UnbilledToDate)) AS NCHAR(8)), 112) AS UnbilledToDate,
       Rates.RateStartDateId,
       Rates.RateEndDateId,
     CASE PricePlans.ScheduleType WHEN N'Daily' THEN CONVERT(DATE, CAST(Transactions.LastBilledReadDate AS NCHAR(8)), 112)
                  WHEN N'Usage' THEN CONVERT(DATE, CAST(UsageTransactions.LastBilledReadDate AS NCHAR(8)), 112)
     END,
       UsageTransactions.LastBilledRead
FROM   (SELECT N'Daily' AS ScheduleType,
               DimService.ServiceKey,
               NULL AS MeterRegisterKey,
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
        AND    FactDailyPricePlan.ContractFRMPDateId <= FactDailyPricePlan.DailyPricePlanEndDateId
        AND    FactDailyPricePlan.ContractFRMPDateId < FactDailyPricePlan.ContractTerminatedDateId
        AND    FactDailyPricePlan.ContractFRMPDateId < CONVERT(NCHAR(8), @ReportDate, 112)
        AND    DimService.ServiceType = N'Electricity'
        AND    DimService.SiteStatusType = N'Energised Site'

        UNION

        SELECT N'Usage' AS ScheduleType,
               DimService.ServiceKey,
               DimMeterRegister.MeterRegisterKey,
               DimPricePlan.PricePlanKey,
               FactUsagePricePlan.UsagePricePlanStartDateId,
               FactUsagePricePlan.UsagePricePlanEndDateId,
               FactUsagePricePlan.ContractFRMPDateId,
               FactUsagePricePlan.ContractTerminatedDateId
        FROM   DW_Dimensional.DW.FactUsagePricePlan
        INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactUsagePricePlan.ServiceId
        INNER  JOIN DW_Dimensional.DW.DimMeterRegister ON DimMeterRegister.MeterRegisterId = FactUsagePricePlan.MeterRegisterId
        INNER  JOIN DW_Dimensional.DW.DimPricePlan ON DimPricePlan.PricePlanId = FactUsagePricePlan.PricePlanId
        WHERE  FactUsagePricePlan.UsagePricePlanStartDateId <= FactUsagePricePlan.ContractTerminatedDateId
        AND    FactUsagePricePlan.UsagePricePlanStartDateId < CONVERT(NCHAR(8), @ReportDate, 112)
        AND    FactUsagePricePlan.ContractFRMPDateId <= FactUsagePricePlan.UsagePricePlanEndDateId  
        AND    FactUsagePricePlan.ContractFRMPDateId < FactUsagePricePlan.ContractTerminatedDateId
        AND    FactUsagePricePlan.ContractFRMPDateId < CONVERT(NCHAR(8), @ReportDate, 112)
        AND    DimService.ServiceType = N'Electricity'
        AND    DimService.SiteStatusType = N'Energised Site'
        AND    DimMeterRegister.RegisterStatus = N'Active') PricePlans
INNER
JOIN   (SELECT DISTINCT
               DimPricePlan.PricePlanKey,
               FactPricePlanRate.RateStartDateId,
               FactPricePlanRate.RateEndDateId
        FROM   DW_Dimensional.DW.FactPricePlanRate
        INNER  JOIN DW_Dimensional.DW.DimPricePlan ON DimPricePlan.PricePlanId = FactPricePlanRate.PricePlanId) Rates
ON      Rates.PricePlanKey = PricePlans.PricePlanKey
AND     Rates.RateStartDateId <= PricePlans.DailyPricePlanEndDateId
AND     Rates.RateStartDateId <= PricePlans.ContractTerminatedDateId
AND     Rates.RateStartDateId <= CONVERT(NCHAR(8), @ReportDate, 112)
AND     Rates.RateEndDateId >= PricePlans.DailyPricePlanStartDateId
AND     Rates.RateEndDateId >= PricePlans.ContractFRMPDateId
LEFT
JOIN   (SELECT DimService.ServiceKey,
               MAX(FactTransaction.EndDateId) AS LastBilledReadDate
        FROM   DW_Dimensional.DW.FactTransaction
        INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactTransaction.ServiceId
        WHERE  FactTransaction.TransactionSubtype = N'Daily charge'
        AND    FactTransaction.Reversal = N'No '
        AND    FactTransaction.Reversed = N'No '
        AND    FactTransaction.EndDateId >= CONVERT(NCHAR(8), @ReportStartDate, 112)
        AND    FactTransaction.EndDateId <= CONVERT(NCHAR(8), @ReportDate, 112)
        AND    FactTransaction.EndDateId <> 99991231
      AND    FactTransaction.AccountingPeriod <= @AccountingPeriod
        GROUP  BY DimService.ServiceKey) Transactions ON Transactions.ServiceKey = PricePlans.ServiceKey
LEFT
JOIN  (SELECT DimService.ServiceKey,
      DimMeterRegister.MeterRegisterKey,
               FactTransaction.EndDateId AS LastBilledReadDate,
      FactTransaction.EndRead AS LastBilledRead,
      ROW_NUMBER () OVER (PARTITION BY DimService.ServiceKey, DimMeterRegister.MeterRegisterKey ORDER BY FactTransaction.EndDateId DESC) AS recency
        FROM   DW_Dimensional.DW.FactTransaction
        INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactTransaction.ServiceId
     INNER  JOIN DW_Dimensional.DW.DimMeterRegister ON DimMeterRegister.MeterRegisterId = FactTransaction.MeterRegisterId
        WHERE  FactTransaction.TransactionSubtype = N'Usage Revenue'
        AND    FactTransaction.Reversal = N'No '
        AND    FactTransaction.Reversed = N'No '
        AND    FactTransaction.EndDateId >= CONVERT(NCHAR(8), @ReportStartDate, 112)
        AND    FactTransaction.EndDateId <= CONVERT(NCHAR(8), @ReportDate, 112)
        AND    FactTransaction.EndDateId <> 99991231
      AND    FactTransaction.AccountingPeriod <= @AccountingPeriod
        GROUP  BY DimService.ServiceKey, DimMeterRegister.MeterRegisterKey, FactTransaction.EndDateId, FactTransaction.EndRead) UsageTransactions
     ON UsageTransactions.ServiceKey = PricePlans.ServiceKey AND UsageTransactions.MeterRegisterKey = PricePlans.MeterRegisterKey AND UsageTransactions.recency = 1
WHERE  COALESCE(Transactions.LastBilledReadDate, CONVERT(NCHAR(8), @ReportStartDate, 112)) <= PricePlans.DailyPricePlanEndDateId
AND    COALESCE(Transactions.LastBilledReadDate, CONVERT(NCHAR(8), @ReportStartDate, 112)) <= PricePlans.ContractTerminatedDateId
AND    COALESCE(Transactions.LastBilledReadDate, CONVERT(NCHAR(8), @ReportStartDate, 112)) <= Rates.RateEndDateId
AND    COALESCE(UsageTransactions.LastBilledReadDate, CONVERT(NCHAR(8), @ReportStartDate, 112)) <= PricePlans.DailyPricePlanEndDateId
AND    COALESCE(UsageTransactions.LastBilledReadDate, CONVERT(NCHAR(8), @ReportStartDate, 112)) <= PricePlans.ContractTerminatedDateId
AND    COALESCE(UsageTransactions.LastBilledReadDate, CONVERT(NCHAR(8), @ReportStartDate, 112)) <= Rates.RateEndDateId;

-- Only report the last eight months of unbilled revenue
UPDATE #UnbilledRevenue
SET    UnbilledFromDate = @ReportStartDate
WHERE  UnbilledFromDate < @ReportStartDate;

-- Remove single-day and negative unbilled periods
DELETE
FROM   #UnbilledRevenue
WHERE  DATEDIFF(DAY, UnbilledFromDate, UnbilledToDate) <= 0;

-- Set Report Month from DimDate
UPDATE #UnbilledRevenue
SET    FinancialMonth = t.FinancialMonth
FROM     (SELECT FiscalMonthNumber AS FinancialMonth
     FROM DW_Dimensional.DW.DimDate
     WHERE [Date] = @ReportDate) AS t


  -- 2m 1,569,902 rows
   
  --===================================================================================================

--Drop and create temporary table
IF OBJECT_ID (N'tempdb..#AccCustPPServiceDaily') IS NOT NULL
    BEGIN
        DROP TABLE #AccCustPPServiceDaily;
    END;


SELECT
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
     INTO #AccCustPPServiceDaily 
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
     AND DimCustomer.Meta_IsCurrent = 1
     WHERE CONVERT(DATE, CAST(FactDailyPricePlan.DailyPricePlanEndDateId AS NCHAR(8)), 112) >= @ReportStartDate
     AND CONVERT(DATE, CAST(FactDailyPricePlan.ContractTerminatedDateId AS NCHAR(8)), 112) >= @ReportStartDate;

     -- 15s, 755,619 rows

     --===========================================================================


-- Set columns from DimAccount, DimCustomer, DimPricePlan and DimProduct for Schedule Type Daily
UPDATE #UnbilledRevenue
SET    AccountNumber =       t.AccountNumber,
    CustomerName  =      t.CustomerName,
    CustomerType  =      t.CustomerType,
    AccountStatus =      t.AccountStatus,
    BillingCycle  =      t.BillingCycle,
    FRMPStartDate =      t.FRMPStartDate,
    ContractTerminatedDate =   t.ContractTerminatedDate,
    FixedTariffAdjustment =  t.FixedTariffAdjustment,
    VariableTariffAdjustment =   t.VariableTariffAdjustment,
    PricePlanStartDate =     t.DailyPricePlanStartDate,
    PricePlanEndDate =     t.DailyPricePlanEndDate,
    PricePlanCode =      t.PricePlanCode,
    BundledFlag =      t.BundledFlag
FROM   (SELECT
     AccountNumber,
     CustomerName,
     CustomerType,
     AccountStatus,
     BillingCycle,
     FRMPStartDate,
     ContractTerminatedDate,
     FixedTariffAdjustment,
     VariableTariffAdjustment,
     DailyPricePlanStartDate,
     DailyPricePlanEndDate,
     PricePlanCode,
     BundledFlag,
     ServiceKey,
     PricePlanKey  
        FROM   #AccCustPPServiceDaily) AS t
WHERE  #UnbilledRevenue.ScheduleType = N'Daily'
AND   #UnbilledRevenue.ServiceKey = t.ServiceKey
AND    #UnbilledRevenue.PricePlanKey = t.PricePlanKey
AND   #UnbilledRevenue.UnbilledFromDate >= t.DailyPricePlanStartDate
AND   #UnbilledRevenue.UnbilledFromDate >= t.FRMPStartDate
AND   #UnbilledRevenue.UnbilledToDate   <= t.DailyPricePlanEndDate
AND   #UnbilledRevenue.UnbilledToDate   <= t.ContractTerminatedDate;

-- 13s, 458,952 rows

--=============================================================================

--Drop and create temporary table
IF OBJECT_ID (N'tempdb..#AccCustPPServiceUsage') IS NOT NULL
    BEGIN
        DROP TABLE #AccCustPPServiceUsage;
    END;


SELECT
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
     INTO #AccCustPPServiceUsage
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
     AND DimCustomer.Meta_IsCurrent = 1
     WHERE CONVERT(DATE, CAST(FactUsagePricePlan.UsagePricePlanEndDateId AS NCHAR(8)), 112) >= @ReportStartDate
     AND CONVERT(DATE, CAST(FactUsagePricePlan.ContractTerminatedDateId AS NCHAR(8)), 112) >= @ReportStartDate;

     -- 31s, 1,846,039 rows
     --==========================================================================================================

-- Set columns from DimAccount, DimCustomer, DimPricePlan and DimProduct for Schedule Type Usage
UPDATE #UnbilledRevenue
SET    AccountNumber =       t.AccountNumber,
    CustomerName  =      t.CustomerName,
    CustomerType  =      t.CustomerType,
    AccountStatus =      t.AccountStatus,
    BillingCycle  =      t.BillingCycle,
    FRMPStartDate =      t.FRMPStartDate,
    ContractTerminatedDate =   t.ContractTerminatedDate,
    FixedTariffAdjustment =  t.FixedTariffAdjustment,
    VariableTariffAdjustment =   t.VariableTariffAdjustment,
    PricePlanStartDate =     t.UsagePricePlanStartDate,
    PricePlanEndDate =     t.UsagePricePlanEndDate,
    PricePlanCode =      t.PricePlanCode,
    BundledFlag =      t.BundledFlag
FROM   (SELECT
     AccountNumber,
     CustomerName,
     CustomerType,
     AccountStatus,
     BillingCycle,
     FRMPStartDate,
     ContractTerminatedDate,
     FixedTariffAdjustment,
     VariableTariffAdjustment,
     UsagePricePlanStartDate,
     UsagePricePlanEndDate,
     PricePlanCode,
     BundledFlag,
     ServiceKey,
     MeterRegisterKey,
     PricePlanKey
        FROM   #AccCustPPServiceUsage) t
WHERE  #UnbilledRevenue.ScheduleType = N'Usage'
AND   #UnbilledRevenue.ServiceKey = t.ServiceKey
AND   #UnbilledRevenue.MeterRegisterKey = t.MeterRegisterKey
AND    #UnbilledRevenue.PricePlanKey = t.PricePlanKey
AND   #UnbilledRevenue.UnbilledFromDate >= t.UsagePricePlanStartDate
AND   #UnbilledRevenue.UnbilledFromDate >= t.FRMPStartDate
AND   #UnbilledRevenue.UnbilledToDate   <= t.UsagePricePlanEndDate
AND   #UnbilledRevenue.UnbilledToDate   <= t.ContractTerminatedDate;

-- 41s, 1,110,947 rows
--========================================

--Drop and create temporary table
IF OBJECT_ID (N'tempdb..#ServiceTNI') IS NOT NULL
    BEGIN
        DROP TABLE #ServiceTNI;
    END;

SELECT
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
     INTO #ServiceTNI   
        FROM   DW_Dimensional.DW.DimService
     LEFT JOIN DW_Dimensional.DW.DimTransmissionNode
     ON DimTransmissionNode.TransmissionNodeId = DimService.TransmissionNodeId
     WHERE DimService.Meta_EffectiveEndDate > @ReportStartDate;

     --34s, 13,581,957 rows
     --=====================================================================


-- Set columns from DimService and DimTransmissionNode
UPDATE #UnbilledRevenue
SET    TNICode =       t.TNICode,
    NetworkState  =    t.NetworkState,
    MarketIdentifier  =  t.MarketIdentifier,
    ServiceStatus =    t.ServiceStatus,
    FuelType =       t.FuelType,
    SiteMeteringType =   t.SiteMeteringType,
    ServiceState =     t.ServiceState,
    SiteEDC =      t.SiteEDC,
    DLF =        t.DLF
FROM   (SELECT
     ServiceKey,
     TNICode,
     NetworkState,
     MarketIdentifier,
     ServiceStatus,
     FuelType,
     SiteMeteringType,
     ServiceState,
     SiteEDC,
     DLF,
     Meta_EffectiveStartDate,
     Meta_EffectiveEndDate     
        FROM #ServiceTNI) t
WHERE  #UnbilledRevenue.ServiceKey = t.ServiceKey
AND   #UnbilledRevenue.UnbilledToDate >= CAST(t.Meta_EffectiveStartDate AS date)
AND    #UnbilledRevenue.UnbilledToDate <= CAST(t.Meta_EffectiveEndDate AS date);

-- 1m28s, 1,569,641 rows
--===============================================================



-- Fix missing DimService and DimTransmissionNode columns
UPDATE #UnbilledRevenue
SET    TNICode =       t.TNICode,
    NetworkState  =    t.NetworkState,
    MarketIdentifier  =  t.MarketIdentifier,
    ServiceStatus =    t.ServiceStatus,
    FuelType =       t.FuelType,
    SiteMeteringType =   t.SiteMeteringType,
    ServiceState =     t.ServiceState,
    SiteEDC =      t.SiteEDC,
    DLF =        t.DLF
FROM   (SELECT
     ServiceKey,
     TNICode,
     NetworkState,
     MarketIdentifier,
     ServiceStatus,
     FuelType,
     SiteMeteringType,
     ServiceState,
     SiteEDC,
     DLF,
     ROW_NUMBER () OVER (PARTITION BY ServiceKey ORDER BY Meta_EffectiveStartDate ASC) AS recency
        FROM #ServiceTNI) t
WHERE  #UnbilledRevenue.MarketIdentifier IS NULL
AND   #UnbilledRevenue.ServiceKey = t.ServiceKey
AND   t.recency = 1;


-- 2m22s, 261 rows
--==========================================================================================

--Drop and create temporary table
IF OBJECT_ID (N'tempdb..#MeterRegister') IS NOT NULL
    BEGIN
        DROP TABLE #MeterRegister;
    END;

SELECT
     DimMeterRegister.MeterRegisterKey,
     DimMeterRegister.RegisterEstimatedDailyConsumption AS MeterRegisterEDC,
     DimMeterRegister.MeterMarketSerialNumber,
     DimMeterRegister.MeterSystemSerialNumber,
     DimMeterRegister.RegisterMultiplier,
     DimMeterRegister.RegisterBillingTypeCode AS MeterRegisterBillingTypeCode,
     DimMeterRegister.RegisterReadDirection AS MeterRegisterReadDirection,
     DimMeterRegister.RegisterNetworkTariffCode AS NetworkTariffCode,
     DimMeterRegister.RegisterStatus AS MeterRegisterStatus,
     DimMeterRegister.Meta_EffectiveStartDate,
     DimMeterRegister.Meta_EffectiveEndDate
     INTO #MeterRegister     
        FROM   DW_Dimensional.DW.DimMeterRegister
     WHERE DimMeterRegister.Meta_EffectiveEndDate > @ReportStartDate;


 -- 2s, 3,884,480 rows
 --==============================================
 


 -- Set columns from DimMeterRegister
UPDATE #UnbilledRevenue
SET    MeterRegisterEDC =     t.MeterRegisterEDC,
     MeterMarketSerialNumber =    t.MeterMarketSerialNumber,
     MeterSystemSerialNumber =    t.MeterSystemSerialNumber,
     RegisterMultiplier =     t.RegisterMultiplier,
     MeterRegisterBillingTypeCode =   t.MeterRegisterBillingTypeCode,
     MeterRegisterReadDirection = t.MeterRegisterReadDirection,
     NetworkTariffCode =      t.NetworkTariffCode,
     MeterRegisterStatus =      t.MeterRegisterStatus
FROM   (SELECT
     MeterRegisterKey,
     MeterRegisterEDC,
     MeterMarketSerialNumber,
     MeterSystemSerialNumber,
     RegisterMultiplier,
     MeterRegisterBillingTypeCode,
     MeterRegisterReadDirection,
     NetworkTariffCode,
     MeterRegisterStatus,
     Meta_EffectiveStartDate,
     Meta_EffectiveEndDate     
        FROM  #MeterRegister) t
WHERE  #UnbilledRevenue.MeterRegisterKey IS NOT NULL
AND   #UnbilledRevenue.MeterRegisterKey = t.MeterRegisterKey
AND   #UnbilledRevenue.UnbilledToDate >= CAST(t.Meta_EffectiveStartDate AS date)
AND    #UnbilledRevenue.UnbilledToDate <= CAST(t.Meta_EffectiveEndDate AS date);


-- 8s, 0 rows
--=========================================================

-- Fix missing DimMeterRegister columns
UPDATE #UnbilledRevenue
SET    MeterRegisterEDC =     t.MeterRegisterEDC,
     MeterMarketSerialNumber =    t.MeterMarketSerialNumber,
     MeterSystemSerialNumber =    t.MeterSystemSerialNumber,
     RegisterMultiplier =     t.RegisterMultiplier,
     MeterRegisterBillingTypeCode =   t.MeterRegisterBillingTypeCode,
     MeterRegisterReadDirection = t.MeterRegisterReadDirection,
     NetworkTariffCode =      t.NetworkTariffCode,
     MeterRegisterStatus =      t.MeterRegisterStatus
FROM   (SELECT
     MeterRegisterKey,
     MeterRegisterEDC,
     MeterMarketSerialNumber,
     MeterSystemSerialNumber,
     RegisterMultiplier,
     MeterRegisterBillingTypeCode,
     MeterRegisterReadDirection,
     NetworkTariffCode,
     MeterRegisterStatus,
     ROW_NUMBER () OVER (PARTITION BY MeterRegisterKey ORDER BY Meta_EffectiveStartDate ASC) AS recency 
        FROM  #MeterRegister) t
WHERE  #UnbilledRevenue.MeterRegisterKey IS NOT NULL
AND    #UnbilledRevenue.MeterRegisterReadDirection IS NULL
AND   #UnbilledRevenue.MeterRegisterKey = t.MeterRegisterKey
AND   t.recency = 1;


-- 1m10s, 1,110,947 rows
--=======================================================================
-- Set Price for Schedule Type Daily
UPDATE #UnbilledRevenue
SET    PriceStep1 = t.PriceStep1,
    UnitStep1 = t.UnitStep1
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
AND   #UnbilledRevenue.RateStartDateId = t.RateStartDateId
AND   #UnbilledRevenue.RateEndDateId = t.RateEndDateId;

-- 8s, 458,955 rows
-- ============================================

-- Usage Step 1
UPDATE #UnbilledRevenue
SET    PriceStep1 = t.PriceStep1,
    UnitStep1 = t.UnitStep1
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
AND   #UnbilledRevenue.RateStartDateId = t.RateStartDateId
AND   #UnbilledRevenue.RateEndDateId = t.RateEndDateId;

-- 19s, 1,110,947 rows
-- ===================================================================

-- Usage Step 2
UPDATE #UnbilledRevenue
SET    PriceStep2 = t.PriceStep2,
    UnitStep2 = t.UnitStep2
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
AND   #UnbilledRevenue.RateStartDateId = t.RateStartDateId
AND   #UnbilledRevenue.RateEndDateId = t.RateEndDateId;

-- 9s, 505,266 row
-- ===================================================================


-- Usage Step 3
UPDATE #UnbilledRevenue
SET    PriceStep3 = t.PriceStep3,
    UnitStep3 = t.UnitStep3
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
AND   #UnbilledRevenue.RateStartDateId = t.RateStartDateId
AND   #UnbilledRevenue.RateEndDateId = t.RateEndDateId;

-- 3s, 245,989 rows
-- =====================================================

-- Usage Step 4
UPDATE #UnbilledRevenue
SET    PriceStep4 = t.PriceStep4,
    UnitStep4 = t.UnitStep4
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
AND   #UnbilledRevenue.RateStartDateId = t.RateStartDateId
AND   #UnbilledRevenue.RateEndDateId = t.RateEndDateId;


-- 7s, 220,705 rows
-- =====================================================

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
AND   #UnbilledRevenue.RateStartDateId = t.RateStartDateId
AND   #UnbilledRevenue.RateEndDateId = t.RateEndDateId;


-- 0s, 0 rows
-- =====================================================

-- Set Unbilled Days
UPDATE #UnbilledRevenue
SET    UnbilledDays = (DATEDIFF(day,UnbilledFromDate,UnbilledToDate) + 1);

-- 21s, 1,569,902 rows
-- =========================================================

-- Set ServiceActiveStartDate and ServiceActiveEndDate
UPDATE UnbilledRevenue
SET    ServiceActiveStartDate = t.ServiceActiveStartDate,
       ServiceActiveEndDate = t.ServiceActiveEndDate
FROM   #UnbilledRevenue UnbilledRevenue
INNER
JOIN   (SELECT DimService.ServiceKey,
               MIN(DimService.Meta_EffectiveStartDate) AS ServiceActiveStartDate,
               MAX(DimService.Meta_EffectiveEndDate) AS ServiceActiveEndDate
        FROM   DW_Dimensional.DW.DimService
        WHERE  DimService.SiteStatusType = N'Energised Site'
        GROUP  BY DimService.ServiceKey) t ON t.ServiceKey = UnbilledRevenue.ServiceKey;

-- Set MeterRegisterActiveStartDate and MeterRegisterActiveEndDate
UPDATE UnbilledRevenue
SET    MeterRegisterActiveStartDate = t.MeterRegisterActiveStartDate,
       MeterRegisterActiveEndDate = t.MeterRegisterActiveEndDate
FROM   #UnbilledRevenue UnbilledRevenue
INNER
JOIN   (SELECT DimMeterRegister.MeterRegisterKey,
               MIN(DimMeterRegister.Meta_EffectiveStartDate) AS MeterRegisterActiveStartDate,
               MAX(DimMeterRegister.Meta_EffectiveEndDate) AS MeterRegisterActiveEndDate
        FROM   DW_Dimensional.DW.DimMeterRegister
        WHERE  DimMeterRegister.RegisterStatus = N'Active'
        GROUP  BY DimMeterRegister.MeterRegisterKey) t ON t.MeterRegisterKey = UnbilledRevenue.MeterRegisterKey;

-- Set SettlementUsageEndDate
UPDATE UnbilledRevenue
SET    SettlementUsageEndDate = t.SettlementUsageEndDate
FROM   #UnbilledRevenue UnbilledRevenue
INNER
JOIN   (SELECT DimService.ServiceKey,
               CONVERT(DATE, CAST(MAX(FactServiceDailyLoad.SettlementDateId) AS NCHAR(8)), 112) AS SettlementUsageEndDate
        FROM   DW_Dimensional.DW.FactServiceDailyLoad
        INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactServiceDailyLoad.ServiceId
        WHERE  FactServiceDailyLoad.SettlementDateId BETWEEN CONVERT(NCHAR(8), @ReportStartDate, 112) AND CONVERT(NCHAR(8), @ReportDate, 112)
        GROUP  BY DimService.ServiceKey) t ON t.ServiceKey = UnbilledRevenue.ServiceKey;

-- 9s, 1,568,879 rows
-- =========================================================

--Drop and create temporary table
IF OBJECT_ID (N'tempdb..#MeterReads') IS NOT NULL
    BEGIN
        DROP TABLE #MeterReads;
    END;

-- Populate temporary meter reads table
WITH meterReadCTE AS (SELECT ROW_NUMBER () OVER (PARTITION BY DimMeterRegister.MeterRegisterKey, FactBasicMeterRead.ReadDateId, FactBasicMeterRead.ReadValue ORDER BY FactBasicMeterRead.EstimatedRead ASC) AS recency,
DimMeterRegister.MeterRegisterKey, FactBasicMeterRead.EstimatedRead, FactBasicMeterRead.ReadValue, FactBasicMeterRead.ReadDateId
  FROM [DW_Dimensional].[DW].[FactBasicMeterRead]
  INNER JOIN DW_Dimensional.DW.DimMeterRegister
  ON DimMeterRegister.MeterRegisterId = FactBasicMeterRead.MeterRegisterId
  WHERE FactBasicMeterRead.ReadType = N'Actual Read' OR FactBasicMeterRead.ReadType = N'Closing Read')
  SELECT meterReadCTE.MeterRegisterKey, meterReadCTE.EstimatedRead, meterReadCTE.ReadValue, meterReadCTE.ReadDateId
  INTO #MeterReads
  FROM meterReadCTE
  WHERE meterReadCTE.recency = 1
   AND CONVERT(DATE, CAST(ReadDateID AS NCHAR(8)), 112) BETWEEN @ReportStartDate AND @ReportDate

--============================================================================

-- Set LastBilledReadType
UPDATE #UnbilledRevenue
SET LastBilledReadType = N'Actual'
WHERE SiteMeteringType = N'TOU'
AND   ScheduleType = N'Usage';

UPDATE #UnbilledRevenue
SET LastBilledReadType = N'Actual'
WHERE ScheduleType = N'Daily';

UPDATE #UnbilledRevenue
SET LastBilledReadType = N'Never'
WHERE #UnbilledRevenue.LastBilledReadDate IS NULL;

UPDATE UnbilledRevenue
SET    LastBilledReadType = t.LastBilledReadType
FROM   #UnbilledRevenue UnbilledRevenue
INNER
JOIN   (SELECT #MeterReads.MeterRegisterKey,
               #MeterReads.ReadValue AS LastBilledRead,
      CONVERT(DATE, CAST(#MeterReads.ReadDateId AS NCHAR(8)), 112) AS LastBilledReadDate,
               CASE #MeterReads.EstimatedRead WHEN N'No ' THEN N'Actual' WHEN N'Yes' THEN N'Estimated' END AS LastBilledReadType
        FROM   #MeterReads) t
ON     t.MeterRegisterKey = UnbilledRevenue.MeterRegisterKey
AND    t.LastBilledReadDate = UnbilledRevenue.LastBilledReadDate
AND    t.LastBilledRead = UnbilledRevenue.LastBilledRead
WHERE  UnbilledRevenue.SiteMeteringType = N'Deemed'
AND    UnbilledRevenue.ScheduleType = N'Usage'
AND    UnbilledRevenue.LastBilledReadDate IS NOT NULL;

UPDATE #UnbilledRevenue
SET LastBilledReadType = N'Unknown'
WHERE #UnbilledRevenue.LastBilledReadType IS NULL;

--==============================================

--Drop and create temporary table
IF OBJECT_ID (N'tempdb..#SettlementUsage') IS NOT NULL
    BEGIN
        DROP TABLE #SettlementUsage;
    END;

SELECT #UnbilledRevenue.ServiceKey,
       #UnbilledRevenue.MeterRegisterKey,
       #UnbilledRevenue.UnbilledFromDate,
       #UnbilledRevenue.MeterRegisterEDC,
       #UnbilledRevenue.DLF,
       DailySettlementUsage.SettlementDate,
       DailySettlementUsage.TotalEnergy
INTO   #SettlementUsage
FROM   #UnbilledRevenue
INNER
JOIN   (SELECT DimService.ServiceKey,
               CONVERT(DATE, CAST(FactServiceDailyLoad.SettlementDateId AS NCHAR(8)), 112) AS SettlementDate,
               FactServiceDailyLoad.TotalEnergy,
               ROW_NUMBER() OVER (PARTITION BY DimService.ServiceKey, FactServiceDailyLoad.SettlementDateId ORDER BY FactServiceDailyLoad.SettlementCase DESC) AS recency
        FROM   DW_Dimensional.DW.FactServiceDailyLoad
        INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactServiceDailyLoad.ServiceId
        WHERE  FactServiceDailyLoad.SettlementDateId BETWEEN CONVERT(NCHAR(8), @ReportStartDate, 112) AND CONVERT(NCHAR(8), @ReportDate, 112)) DailySettlementUsage
ON     DailySettlementUsage.ServiceKey = #UnbilledRevenue.ServiceKey
AND    DailySettlementUsage.SettlementDate BETWEEN #UnbilledRevenue.UnbilledFromDate AND #UnbilledRevenue.UnbilledToDate
AND    DailySettlementUsage.SettlementDate BETWEEN #UnbilledRevenue.ServiceActiveStartDate AND #UnbilledRevenue.ServiceActiveEndDate
AND    DailySettlementUsage.SettlementDate BETWEEN #UnbilledRevenue.MeterRegisterActiveStartDate AND #UnbilledRevenue.MeterRegisterActiveEndDate
WHERE  #UnbilledRevenue.ScheduleType = N'Usage'
AND    #UnbilledRevenue.MeterRegisterReadDirection = N'Export'
AND    DailySettlementUsage.recency = 1;

-- 6m, 30,387,597 rows
-- =========================================================

--Drop and create temporary table
IF OBJECT_ID (N'tempdb..#SiteEDC') IS NOT NULL
    BEGIN
        DROP TABLE #SiteEDC;
    END;

SELECT SettlementUsage.ServiceKey,
       SettlementUsage.SettlementDate,
       SUM(MeterRegisters.RegisterEstimatedDailyConsumption) AS EstimatedDailyConsumption
INTO   #SiteEDC
FROM   (SELECT DISTINCT
               #SettlementUsage.ServiceKey,
               #SettlementUsage.SettlementDate
        FROM   #SettlementUsage) SettlementUsage
INNER
JOIN   (SELECT DISTINCT
               DimService.ServiceKey,
               DimMeterRegister.MeterRegisterKey,
               DimMeterRegister.RegisterEstimatedDailyConsumption,
               DimMeterRegister.Meta_EffectiveStartDate,
               DimMeterRegister.Meta_EffectiveEndDate
        FROM   DW_Dimensional.DW.FactServiceMeterRegister
        INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactServiceMeterRegister.ServiceId
        INNER  JOIN DW_Dimensional.DW.DimMeterRegister ON DimMeterRegister.MeterRegisterId = FactServiceMeterRegister.MeterRegisterId
        WHERE  DimMeterRegister.RegisterStatus = N'Active') MeterRegisters
ON     MeterRegisters.ServiceKey = SettlementUsage.ServiceKey
AND    SettlementUsage.SettlementDate BETWEEN MeterRegisters.Meta_EffectiveStartDate AND MeterRegisters.Meta_EffectiveEndDate
GROUP  BY SettlementUsage.ServiceKey,
          SettlementUsage.SettlementDate;

-- 11s, 13,059,371 rows
-- =========================================================

-- Set SettlementUsage
UPDATE UnbilledRevenue
SET    SettlementUsage = t.SettlementUsage
FROM   #UnbilledRevenue UnbilledRevenue
INNER
JOIN   (SELECT #SettlementUsage.ServiceKey,
               #SettlementUsage.MeterRegisterKey,
               #SettlementUsage.UnbilledFromDate,
               SUM(CASE
                     WHEN COALESCE(#SiteEDC.EstimatedDailyConsumption, 0.0) = 0.0 THEN 0.0
                     ELSE #SettlementUsage.TotalEnergy * COALESCE(#SettlementUsage.MeterRegisterEDC, 0.0) / #SiteEDC.EstimatedDailyConsumption / COALESCE(#SettlementUsage.DLF, 1.0)
                   END) AS SettlementUsage
        FROM   #SettlementUsage
        LEFT   JOIN #SiteEDC ON #SiteEDC.ServiceKey = #SettlementUsage.ServiceKey AND #SiteEDC.SettlementDate = #SettlementUsage.SettlementDate
        GROUP  BY #SettlementUsage.ServiceKey,
                  #SettlementUsage.MeterRegisterKey,
                  #SettlementUsage.UnbilledFromDate) t
ON     t.ServiceKey = UnbilledRevenue.ServiceKey
AND    t.MeterRegisterKey = UnbilledRevenue.MeterRegisterKey
AND    t.UnbilledFromDate = UnbilledRevenue.UnbilledFromDate;

-- 1m, 1,100,456 rows
-- =========================================================

--Drop and create temporary table
IF OBJECT_ID (N'tempdb..#EstimatedUsage') IS NOT NULL
    BEGIN
        DROP TABLE #EstimatedUsage;
    END;

SELECT #UnbilledRevenue.TNICode,
       #UnbilledRevenue.ServiceKey,
       #UnbilledRevenue.MeterRegisterKey,
       #UnbilledRevenue.UnbilledFromDate,
       #UnbilledRevenue.MeterRegisterEDC,
       #UnbilledRevenue.DLF,
       #UnbilledRevenue.SettlementUsageEndDate,
       DailyEstimatedUsage.SettlementDate,
       DailyEstimatedUsage.ExportNetEnergy
INTO   #EstimatedUsage
FROM   #UnbilledRevenue
INNER
JOIN   (SELECT DimTransmissionNode.TransmissionNodeIdentity,
               CONVERT(DATE, CAST(FactTransmissionNodeDailyLoad.SettlementDateId AS NCHAR(8)), 112) AS SettlementDate,
               FactTransmissionNodeDailyLoad.ExportNetEnergy,
               ROW_NUMBER() OVER (PARTITION BY DimTransmissionNode.TransmissionNodeIdentity, FactTransmissionNodeDailyLoad.SettlementDateId ORDER BY FactTransmissionNodeDailyLoad.SettlementRun DESC) AS recency
        FROM   DW_Dimensional.DW.FactTransmissionNodeDailyLoad
        INNER  JOIN DW_Dimensional.DW.DimTransmissionNode ON DimTransmissionNode.TransmissionNodeId = FactTransmissionNodeDailyLoad.TransmissionNodeId
        WHERE  FactTransmissionNodeDailyLoad.SettlementDateId BETWEEN CONVERT(NCHAR(8), @ReportStartDate, 112) AND CONVERT(NCHAR(8), @ReportDate, 112)) DailyEstimatedUsage
ON     DailyEstimatedUsage.TransmissionNodeIdentity = #UnbilledRevenue.TNICode
AND    DailyEstimatedUsage.SettlementDate BETWEEN #UnbilledRevenue.UnbilledFromDate AND #UnbilledRevenue.UnbilledToDate
AND    DailyEstimatedUsage.SettlementDate BETWEEN #UnbilledRevenue.ServiceActiveStartDate AND #UnbilledRevenue.ServiceActiveEndDate
AND    DailyEstimatedUsage.SettlementDate BETWEEN #UnbilledRevenue.MeterRegisterActiveStartDate AND #UnbilledRevenue.MeterRegisterActiveEndDate
AND    DailyEstimatedUsage.SettlementDate > COALESCE(#UnbilledRevenue.SettlementUsageEndDate, '1900-01-01')
WHERE  #UnbilledRevenue.ScheduleType = N'Usage'
AND    #UnbilledRevenue.MeterRegisterReadDirection = N'Export'
AND    DailyEstimatedUsage.recency = 1;

-- 17s, 64,934,432 rows
-- =========================================================

--Drop and create temporary table
IF OBJECT_ID (N'tempdb..#TNIEDC') IS NOT NULL
    BEGIN
        DROP TABLE #TNIEDC;
    END;

SELECT EstimatedUsage.TNICode,
       EstimatedUsage.SettlementDate,
       SUM(MeterRegisters.RegisterEstimatedDailyConsumption) AS EstimatedDailyConsumption
INTO   #TNIEDC
FROM   (SELECT DISTINCT
               #EstimatedUsage.TNICode,
               #EstimatedUsage.SettlementDate
        FROM   #EstimatedUsage) EstimatedUsage
INNER
JOIN   (SELECT DISTINCT
               DimTransmissionNode.TransmissionNodeIdentity,
               DimMeterRegister.MeterRegisterKey,
               DimMeterRegister.RegisterEstimatedDailyConsumption,
               DimMeterRegister.Meta_EffectiveStartDate,
               DimMeterRegister.Meta_EffectiveEndDate
        FROM   DW_Dimensional.DW.FactServiceMeterRegister
        INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactServiceMeterRegister.ServiceId
        INNER  JOIN DW_Dimensional.DW.DimTransmissionNode ON DimTransmissionNode.TransmissionNodeId = DimService.TransmissionNodeId
        INNER  JOIN DW_Dimensional.DW.DimMeterRegister ON DimMeterRegister.MeterRegisterId = FactServiceMeterRegister.MeterRegisterId
        WHERE  DimMeterRegister.RegisterStatus = N'Active') MeterRegisters
ON     MeterRegisters.TransmissionNodeIdentity = EstimatedUsage.TNICode
AND    EstimatedUsage.SettlementDate BETWEEN MeterRegisters.Meta_EffectiveStartDate AND MeterRegisters.Meta_EffectiveEndDate
GROUP  BY EstimatedUsage.TNICode,
          EstimatedUsage.SettlementDate;

-- 34s, 40,823 rows
-- =========================================================

-- Set EstimatedUsage
UPDATE UnbilledRevenue
SET    EstimatedUsage = t.EstimatedUsage
FROM   #UnbilledRevenue UnbilledRevenue
INNER
JOIN   (SELECT #EstimatedUsage.TNICode,
               #EstimatedUsage.MeterRegisterKey,
               #EstimatedUsage.UnbilledFromDate,
               SUM(CASE
                     WHEN COALESCE(#TNIEDC.EstimatedDailyConsumption, 0.0) = 0.0 THEN 0.0
                     ELSE #EstimatedUsage.ExportNetEnergy * 1000.0 * COALESCE(#EstimatedUsage.MeterRegisterEDC, 0.0) / #TNIEDC.EstimatedDailyConsumption / COALESCE(#EstimatedUsage.DLF, 1.0)
                   END) AS EstimatedUsage
        FROM   #EstimatedUsage
        LEFT   JOIN #TNIEDC ON #TNIEDC.TNICode = #EstimatedUsage.TNICode AND #TNIEDC.SettlementDate = #EstimatedUsage.SettlementDate
        GROUP  BY #EstimatedUsage.TNICode,
                  #EstimatedUsage.MeterRegisterKey,
                  #EstimatedUsage.UnbilledFromDate) t
ON     t.TNICode = UnbilledRevenue.TNICode
AND    t.MeterRegisterKey = UnbilledRevenue.MeterRegisterKey
AND    t.UnbilledFromDate = UnbilledRevenue.UnbilledFromDate;

-- 37s, 924,428 rows
-- =========================================================

-- Set Total Usage
UPDATE #UnbilledRevenue
SET    TotalUnbilledUsage = COALESCE(SettlementUsage,0.0) + COALESCE(EstimatedUsage,0.0)
WHERE  #UnbilledRevenue.ScheduleType = N'Usage';

-- 
-- =========================================================

-- Set TotalUnbilledRevenue for Daily
UPDATE #UnbilledRevenue
SET    TotalUnbilledRevenue = PriceStep1 * UnbilledDays * FixedTariffAdjustment
WHERE  #UnbilledRevenue.ScheduleType = N'Daily';

-- 4s, 458,955 rows
--==========================================================

-- Set TotalUnbilledRevenue for Usage
UPDATE #UnbilledRevenue
SET    TotalUnbilledRevenue = SIGN(TotalUnbilledUsage) *
(CASE WHEN ABS(TotalUnbilledUsage) > (UnitStep1 * UnbilledDays) THEN UnitStep1 * UnbilledDays * PriceStep1 
WHEN ABS(TotalUnbilledUsage) > 0 THEN ABS(TotalUnbilledUsage) * PriceStep1
ELSE 0
END
+
CASE WHEN ABS(TotalUnbilledUsage) > (UnitStep2 * UnbilledDays) THEN (UnitStep2 - UnitStep1) * UnbilledDays * PriceStep2 
WHEN ABS(TotalUnbilledUsage) > (UnitStep1 * UnbilledDays) THEN (ABS(TotalUnbilledUsage) - (UnitStep1*UnbilledDays)) * PriceStep2
ELSE 0
END
+
CASE WHEN ABS(TotalUnbilledUsage) > (UnitStep3 * UnbilledDays) THEN (UnitStep3 - UnitStep2) * UnbilledDays * PriceStep3
WHEN ABS(TotalUnbilledUsage) > (UnitStep2 * UnbilledDays) THEN (ABS(TotalUnbilledUsage) - (UnitStep2*UnbilledDays)) * PriceStep3
ELSE 0
END
+
CASE WHEN ABS(TotalUnbilledUsage) > (UnitStep4 * UnbilledDays) THEN ((UnitStep4 - UnitStep3) * UnbilledDays * PriceStep4) + ((ABS(TotalUnbilledUsage) - (UnitStep4*UnbilledDays)) * PriceStep5)
WHEN ABS(TotalUnbilledUsage) > (UnitStep3 * UnbilledDays) THEN (ABS(TotalUnbilledUsage) - (UnitStep3*UnbilledDays)) * PriceStep4
ELSE 0
END) * VariableTariffAdjustment
WHERE  #UnbilledRevenue.ScheduleType = N'Usage';

-- 
--==========================================================

-- Remove historical records for this report date
DELETE FROM Views.UnbilledRevenueReport
    WHERE ReportDate = @ReportDate;

DECLARE @deleterowcount int 

    SET @deleterowcount = @@ROWCOUNT

-- Insert new records
INSERT INTO [Views].[UnbilledRevenueReport]
           ([FinancialMonth]
           ,[ReportDate]
           ,[AccountingPeriod]
           ,[AccountNumber]
           ,[CustomerName]
           ,[CustomerType]
           ,[AccountStatus]
           ,[BillingCycle]
           ,[TNICode]
           ,[NetworkState]
           ,[MarketIdentifier]
           ,[ServiceStatus]
           ,[ServiceActiveStartDate]
           ,[ServiceActiveEndDate]
           ,[FRMPStartDate]
           ,[ContractTerminatedDate]
           ,[FuelType]
           ,[SiteMeteringType]
           ,[ServiceState]
           ,[SiteEDC]
           ,[DLF]
           ,[MeterRegisterEDC]
           ,[MeterMarketSerialNumber]
           ,[MeterRegisterKey]
           ,[MeterSystemSerialNumber]
           ,[RegisterMultiplier]
           ,[MeterRegisterBillingTypeCode]
           ,[MeterRegisterReadDirection]
           ,[MeterRegisterStatus]
           ,[MeterRegisterActiveStartDate]
           ,[MeterRegisterActiveEndDate]
           ,[NetworkTariffCode]
           ,[LastBilledRead]
           ,[LastBilledReadDate]
     ,[LastBilledReadType]
           ,[ScheduleType]
           ,[FixedTariffAdjustment]
           ,[VariableTariffAdjustment]
           ,[PricePlanStartDate]
           ,[PricePlanEndDate]
           ,[PricePlanCode]
           ,[BundledFlag]
           ,[PriceStep1]
           ,[PriceStep2]
           ,[PriceStep3]
           ,[PriceStep4]
           ,[PriceStep5]
           ,[UnitStep1]
           ,[UnitStep2]
           ,[UnitStep3]
           ,[UnitStep4]
           ,[UnbilledFromDate]
           ,[UnbilledToDate]
           ,[UnbilledDays]
           ,[SettlementUsageEndDate]
           ,[SettlementUsage]
           ,[EstimatedUsage]
           ,[TotalUnbilledUsage]
           ,[TotalUnbilledRevenue]
     ,[Meta_Insert_TaskExecutionInstanceId])
    SELECT [FinancialMonth]
           ,[ReportDate]
           ,[AccountingPeriod]
           ,[AccountNumber]
           ,[CustomerName]
           ,[CustomerType]
           ,[AccountStatus]
           ,[BillingCycle]
           ,[TNICode]
           ,[NetworkState]
           ,[MarketIdentifier]
           ,[ServiceStatus]
           ,[ServiceActiveStartDate]
           ,[ServiceActiveEndDate]
           ,[FRMPStartDate]
           ,[ContractTerminatedDate]
           ,[FuelType]
           ,[SiteMeteringType]
           ,[ServiceState]
           ,[SiteEDC]
           ,[DLF]
           ,[MeterRegisterEDC]
           ,[MeterMarketSerialNumber]
           ,[MeterRegisterKey]
           ,[MeterSystemSerialNumber]
           ,[RegisterMultiplier]
           ,[MeterRegisterBillingTypeCode]
           ,[MeterRegisterReadDirection]
           ,[MeterRegisterStatus]
           ,[MeterRegisterActiveStartDate]
           ,[MeterRegisterActiveEndDate]
           ,[NetworkTariffCode]
           ,[LastBilledRead]
           ,[LastBilledReadDate]
     ,[LastBilledReadType]
           ,[ScheduleType]
           ,[FixedTariffAdjustment]
           ,[VariableTariffAdjustment]
           ,[PricePlanStartDate]
           ,[PricePlanEndDate]
           ,[PricePlanCode]
           ,[BundledFlag]
           ,[PriceStep1]
           ,[PriceStep2]
           ,[PriceStep3]
           ,[PriceStep4]
           ,[PriceStep5]
           ,[UnitStep1]
           ,[UnitStep2]
           ,[UnitStep3]
           ,[UnitStep4]
           ,[UnbilledFromDate]
           ,[UnbilledToDate]
           ,[UnbilledDays]
           ,[SettlementUsageEndDate]
           ,[SettlementUsage]
           ,[EstimatedUsage]
           ,[TotalUnbilledUsage]
           ,[TotalUnbilledRevenue]
     ,@TaskExecutionInstanceID
    FROM #UnbilledRevenue;

    DECLARE @insertrowcount int 

    SET @insertrowcount = @@ROWCOUNT
  

--Rebuild index
ALTER INDEX [ClusteredColumnStoreIndex-UnbilledRevenueReport] ON [Views].[UnbilledRevenueReport] 
    REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = COLUMNSTORE);

   
    --Return row counts
    SELECT  0 AS ExtractRowCount,
            @insertrowcount AS InsertRowCount,
            0 AS UpdateRowCount,
            0 AS DeleteRowCount,
            0 AS ErrorRowCount;
    --/



END;





GO