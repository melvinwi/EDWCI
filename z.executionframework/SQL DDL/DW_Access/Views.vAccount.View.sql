USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  VIEW [Views].[vAccount]
AS
WITH   factContract
       AS (SELECT DimAccount.AccountKey,
                  COUNT (*) AS NumberOfContracts,
                  SUM(CASE
                        WHEN ContractStatus = 'Open' THEN 1
                        ELSE 0
                      END) AS NumberOfOpenContracts,
                  SUM(CASE
                        WHEN DimService.ServiceType = 'Gas' THEN 1
                        ELSE 0
                      END) AS NumberOfGasContracts,
                  SUM(CASE
                        WHEN ContractStatus = 'Open' AND DimService.ServiceType = 'Gas' THEN 1
                        ELSE 0
                      END) AS NumberOfOpenGasContracts,
                  SUM(CASE
                        WHEN DimService.ServiceType = 'Electricity' THEN 1
                        ELSE 0
                      END) AS NumberOfElectricityContracts,
                  SUM(CASE
                        WHEN ContractStatus = 'Open' AND DimService.ServiceType = 'Electricity' THEN 1
                        ELSE 0
                      END) AS NumberOfOpenElectricityContracts,
                  MAX(DimProduct.ProductId) AS MaxProductId
           FROM   DW_Dimensional.DW.FactContract INNER JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactContract.AccountId
           INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactContract.ServiceId
           INNER  JOIN DW_Dimensional.DW.DimProduct ON DimProduct.ProductId = FactContract.ProductId
           GROUP  BY DimAccount.AccountKey),
       factHeader
       AS (SELECT Dimaccount.AccountKey,
                  SUM(CASE FactHeader.PaidOnTime
                        WHEN 'Yes' THEN 1
                        ELSE 0
                      END) AS NumberOfInvoicesPaidOnTime,
                  COUNT(*) AS NumberOfInvoices,
                  MIN(CASE FactHeader.PaidOnTime
                        WHEN 'Yes' THEN FactHeader.IssueDateId
                        ELSE 99991231
                      END) AS FirstInvoicePaidOnTime,
                  MAX(CASE FactHeader.PaidOnTime
                        WHEN 'Yes' THEN FactHeader.IssueDateId
                        ELSE 0
                      END) AS LastInvoicePaidOnTime
           FROM   DW_Dimensional.DW.FactHeader INNER JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactHeader.AccountId
           WHERE  CONVERT(date, CAST (FactHeader.DueDateId AS nchar (8)), 112) < GETDATE() 
           GROUP  BY DimAccount.AccountKey),
       promptPaymentDiscount
       AS (SELECT DimAccount.AccountKey,
                  -1 * SUM (FactTransaction.Value + FactTransaction.Tax) AS PromptPaymentDiscountReceived
           FROM DW_Dimensional.DW.FactTransaction
           INNER JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactTransaction.AccountId
           INNER JOIN DW_Dimensional.DW.DimFinancialAccount ON DimFinancialAccount.FinancialAccountId = FactTransaction.FinancialAccountId AND DimFinancialAccount.FinancialAccountName = 'Prompt Payment Disc'
           GROUP  BY DimAccount.AccountKey), 
       ATB
       AS (SELECT AccountId,
                  CurrentPeriod,
                  Days1To30,
                  Days31To60,
                  Days61To90,
                  Days90Plus
           FROM DW_Dimensional.DW.FactAgedTrialBalance AS FATB
           WHERE ATBDateId = (SELECT MAX(ATBDateId) 
                              FROM   DW_Dimensional.DW.FactAgedTrialBalance
                              WHERE  AccountId = FATB.AccountId
                              GROUP  BY AccountId)),
       gasUsage
       AS (SELECT DimAccount.AccountKey,
                  SUM(FactTransaction.Units) AS YearlyGasUsageMJ
           FROM   DW_Dimensional.DW.FactTransaction
           INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactTransaction.AccountId
           INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactTransaction.ServiceId
           INNER  JOIN DW_Dimensional.DW.DimFinancialAccount ON DimFinancialAccount.FinancialAccountId = FactTransaction.FinancialAccountId
           INNER  JOIN DW_Dimensional.DW.DimUnitType ON DimUnitType.UnitTypeId = FactTransaction.UnitTypeId
           WHERE  DimService.ServiceType = 'Gas'
           AND    DimFinancialAccount.FinancialAccountKey = 12
           AND    DimUnitType.UnitTypeKey = 4
           AND    FactTransaction.TransactionType = 'Energy Charges'
           AND    TransactionDateId <= CONVERT(nchar(8), GETDATE() , 112) 
           AND    TransactionDateId >= CONVERT(nchar(8), DATEADD(year, -1, GETDATE()) , 112) 
           GROUP  BY DimAccount.AccountKey
          ),
       elecUsage
       AS (SELECT DimAccount.AccountKey,
                  SUM (FactTransaction.Units) AS YearlyElecUsageKWH
           FROM   DW_Dimensional.DW.FactTransaction
           INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactTransaction.AccountId
           INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactTransaction.ServiceId
           INNER  JOIN DW_Dimensional.DW.DimFinancialAccount ON DimFinancialAccount.FinancialAccountId = FactTransaction.FinancialAccountId
           INNER  JOIN DW_Dimensional.DW.DimUnitType ON DimUnitType.UnitTypeId = FactTransaction.UnitTypeId
           WHERE  DimService.ServiceType = 'Electricity'
           AND    DimFinancialAccount.FinancialAccountKey = 11
           AND    DimUnitType.UnitTypeKey = 4
           AND    FactTransaction.TransactionType = 'Energy Charges'
           AND    TransactionDateId <= CONVERT(nchar(8) , GETDATE() , 112) 
           AND    TransactionDateId >= CONVERT(nchar(8) , DATEADD(year, -1, GETDATE()) , 112) 
           GROUP  BY DimAccount.AccountKey),
       accountContract
       AS (SELECT DimAccount.AccountKey,
                  DATEADD(DAY, -1, CONVERT(DATE, CAST(FactContract.ContractStartDateId AS NCHAR(8)), 112)) AS PossibleTenureStartDate,
                  CONVERT(DATE, CAST(FactContract.ContractStartDateId AS NCHAR(8)), 112) AS ContractStartDate,
                  CONVERT(DATE, CAST(FactContract.ContractTerminatedDateId AS NCHAR(8)), 112) AS ContractTerminatedDate,
                  FactContract.ContractStatus
           FROM   DW_Dimensional.DW.DimAccount
           INNER  JOIN DW_Dimensional.DW.FactContract ON FactContract.AccountId = DimAccount.AccountId),
       tenureStart
       AS (SELECT candidate.AccountKey,
                  DATEADD(DAY, 1, MAX(candidate.PossibleTenureStartDate)) as TenureStartDate
           FROM   accountContract AS candidate LEFT JOIN accountContract AS allContract
                  ON allContract.AccountKey = candidate.AccountKey AND candidate.PossibleTenureStartDate >= allContract.ContractStartDate AND candidate.PossibleTenureStartDate <= allContract.ContractTerminatedDate
           WHERE  allContract.AccountKey IS NULL
           GROUP  BY candidate.AccountKey),
       openContract
       AS (SELECT DISTINCT accountContract.AccountKey
           FROM   accountContract
           WHERE  accountContract.ContractStatus = 'Open')
SELECT -- DimAccount
       DimAccount.AccountCode,
       ISNULL(NULLIF(DimAccount.PostalAddressLine1, '') , '{Unknown}') AS PostalAddressLine1,
       ISNULL(NULLIF(DimAccount.PostalSuburb, '') , '{Unknown}') AS PostalSuburb,
       ISNULL(NULLIF(DimAccount.PostalPostcode, '') , '{Un}') AS PostalPostcode,
       ISNULL(NULLIF(DimAccount.PostalState, '') , '{U}') AS PostalState,
       ISNULL(NULLIF(DimAccount.PostalStateAsProvided, '') , '{U}') AS PostalStateAsProvided,
       ISNULL(NULLIF(DimAccount.AccountStatus, '') , '{Unkn}') AS AccountStatus,
       DimAccount.AccountCreationDate,
       DimAccount.AccountClosedDate,
       ISNULL(NULLIF(DimAccount.CreditControlStatus, '') , '{Unknown}') AS CreditControlStatus,
       ISNULL(NULLIF(DimAccount.CreditControlCategory, '') , '{Unknown}') AS CreditControlCategory,
       ISNULL(NULLIF(DimAccount.InvoiceDeliveryMethod, '') , '{Unknown}') AS InvoiceDeliveryMethod,
       ISNULL(NULLIF(DimAccount.PaymentMethod, '') , '{Unknown}') AS PaymentMethod,
       ISNULL(NULLIF(DimAccount.MyAccountStatus, '') , '{Unknown}') AS MyAccountStatus,
       DATEDIFF(DAY, DimAccount.AccountCreationDate, ISNULL(DimAccount.AccountClosedDate, GETDATE())) AS AccountTenureInDays,
       CASE
         WHEN openContract.AccountKey IS NULL THEN 0
         ELSE DATEDIFF(DAY, tenureStart.TenureStartDate, GETDATE())
       END AS ActiveTenureInDays,
	  ISNULL(NULLIF(DimAccount.ACN, '') , '{Unknown}') AS ACN,
	  ISNULL(NULLIF(DimAccount.ABN, '') , '{Unknown}') AS ABN,
	  ISNULL(NULLIF(DimAccount.AccountType, '') , '{Unknown}') AS AccountType,
       -- DimCustomer
       DimCustomer.CustomerCode,
       ISNULL(NULLIF(DimCustomer.Title, '') , '{U}') AS Title,
       ISNULL(NULLIF(DimCustomer.FirstName, '') , '{Unknown}') AS FirstName,
       ISNULL(NULLIF(DimCustomer.MiddleInitial, '') , '{Unknown}') AS MiddleInitial,
       ISNULL(NULLIF(DimCustomer.LastName, '') , '{Unknown}') AS LastName,
       ISNULL(NULLIF(DimCustomer.PartyName, '') , '{Unknown}') AS PartyName,
       ISNULL(NULLIF(DimCustomer.ResidentialAddressLine1, '') , '{Unknown}') AS ResidentialAddressLine1,
       ISNULL(NULLIF(DimCustomer.ResidentialSuburb, '') , '{Unknown}') AS ResidentialSuburb,
       ISNULL(NULLIF(DimCustomer.ResidentialPostcode, '') , '{Un}') AS ResidentialPostcode,
       ISNULL(NULLIF(DimCustomer.ResidentialState, '') , '{U}') AS ResidentialState,
       ISNULL(NULLIF(DimCustomer.ResidentialStateAsProvided, '') , '{U}') AS ResidentialStateAsProvided,
       ISNULL(NULLIF(DimCustomer.PrimaryPhone, '') , '{Unknown}') AS PrimaryPhone,
       ISNULL(NULLIF(DimCustomer.PrimaryPhoneType, '') , '{Unk}') AS PrimaryPhoneType,
       ISNULL(NULLIF(DimCustomer.SecondaryPhone, '') , '{Unknown}') AS SecondaryPhone,
       ISNULL(NULLIF(DimCustomer.SecondaryPhoneType, '') , '{Unk}') AS SecondaryPhoneType,
       ISNULL(NULLIF(DimCustomer.MobilePhone, '') , '{Unknown}') AS MobilePhone,
       ISNULL(NULLIF(DimCustomer.Email, '') , '{Unknown}') AS Email,
       DimCustomer.DateOfBirth,
       DATEDIFF(YEAR, DimCustomer.DateOfBirth, GETDATE())
       - CASE
           WHEN DATEDIFF(DAY, GETDATE(), DATEADD(YEAR, DATEDIFF (YEAR, DimCustomer.DateOfBirth, GETDATE()), DimCustomer.DateOfBirth)) > 0 THEN 1
           ELSE 0 --this is to subtract birthdays that are yet to occur in the current year
         END AS Age,
       ISNULL(NULLIF(DimCustomer.CustomerType, '') , '{Unknown}') AS CustomerType,
       ISNULL(NULLIF(DimCustomer.CustomerStatus, '') , '{Unk}') AS CustomerStatus,
       ISNULL(NULLIF(DimCustomer.OmbudsmanComplaints, '') , '{U}') AS OmbudsmanComplaints,
       DimCustomer.CreationDate,
       DimCustomer.JoinDate,
       ISNULL(NULLIF(DimCustomer.PrivacyPreferredStatus, '') , '{Unknown}') AS PrivacyPreferredStatus,
       -- factHeader
       ISNULL(factHeader.NumberOfInvoicesPaidOnTime, 0) AS NumberOfInvoicesPaidOnTime,
       ISNULL(factHeader.NumberOfInvoices, 0) AS NumberOfInvoices,
       CONVERT (DATE, CAST (NULLIF(factHeader.FirstInvoicePaidOnTime , 99991231) AS NCHAR(8)), 112) AS FirstInvoicePaidOnTime,
       CONVERT (DATE, CAST (NULLIF(factHeader.LastInvoicePaidOnTime  , 0)        AS NCHAR(8)), 112) AS LastInvoicePaidOnTime,
       -- promptPaymentDiscount
       ISNULL(promptPaymentDiscount.PromptPaymentDiscountReceived, 0) AS PromptPaymentDiscountReceived,
       -- factContract
       ISNULL(factContract.NumberOfContracts, 0) AS NumberOfContracts,
       ISNULL(factContract.NumberOfOpenContracts, 0) AS NumberOfOpenContracts,
       CASE
         WHEN factContract.NumberOfGasContracts > 0 AND factContract.NumberOfElectricityContracts > 0 THEN 'Dual Fuel'
         WHEN factContract.NumberOfGasContracts > 0 THEN 'Gas'
         WHEN factContract.NumberOfElectricityContracts > 0 THEN 'Electricity'
         ELSE '{Unknown}'
       END AS LifetimeFuelType,
       CASE
         WHEN factContract.NumberOfOpenGasContracts > 0 AND factContract.NumberOfOpenElectricityContracts > 0 THEN 'Dual Fuel'
         WHEN factContract.NumberOfOpenGasContracts > 0 THEN 'Gas'
         WHEN factContract.NumberOfOpenElectricityContracts > 0 THEN 'Electricity'
         ELSE 'None'
       END AS ActiveFuelType,
       ISNULL(DimProduct.ProductName, '{Unknown}') AS ProductName,
       -- Aged Trial Balance
       ISNULL(ATB.CurrentPeriod , 0.00) AS ATBCurrentPeriod,
       ISNULL(ATB.Days1To30     , 0.00) AS Days1To30,
       ISNULL(ATB.Days31To60    , 0.00) AS Days31To60,
       ISNULL(ATB.Days61To90    , 0.00) AS Days61To90,
       ISNULL(ATB.Days90Plus    , 0.00) AS Days90Plus,
       -- Gas Usage
       ISNULL(gasUsage.YearlyGasUsageMJ, 0) AS YearlyGasUsageMJ,
       -- Electricity Usage
       ISNULL(elecUsage.YearlyElecUsageKWH, 0) AS YearlyElecUsageKWH
FROM   DW_Dimensional.DW.DimAccount 
INNER  JOIN DW_Dimensional.DW.FactCustomerAccount ON FactCustomerAccount.AccountId = DimAccount.AccountId
INNER  JOIN DW_Dimensional.DW.DimCustomer ON DimCustomer.CustomerId = FactCustomerAccount.CustomerId
LEFT   JOIN factContract ON factContract.AccountKey = DimAccount.AccountKey
LEFT   JOIN DW_Dimensional.DW.DimProduct ON DimProduct.ProductId = factContract.MaxProductId
LEFT   JOIN factHeader ON factHeader.AccountKey = DimAccount.AccountKey
LEFT   JOIN promptPaymentDiscount ON promptPaymentDiscount.AccountKey = DimAccount.AccountKey
LEFT   JOIN ATB ON ATB.AccountId = DimAccount.AccountId
LEFT   JOIN gasUsage ON gasUsage.AccountKey = DimAccount.AccountKey
LEFT   JOIN elecUsage ON elecUsage.AccountKey = DimAccount.AccountKey
LEFT   JOIN tenureStart ON tenureStart.AccountKey = DimAccount.AccountKey
LEFT   JOIN openContract ON openContract.AccountKey = DimAccount.AccountKey
WHERE  DimAccount.Meta_IsCurrent = 1
AND    DimCustomer.Meta_IsCurrent = 1
AND DimAccount.AccountId > 0
AND DimCustomer.CustomerId >0;


GO
