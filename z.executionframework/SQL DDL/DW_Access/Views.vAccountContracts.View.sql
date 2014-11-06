USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  VIEW [Views].[vAccountContracts]
AS

WITH factContract AS (SELECT DimAccount.AccountKey,
                             COUNT(*) AS NumberOfContracts,
                             SUM(CASE WHEN ContractStatus = 'Open' THEN 1 ELSE 0 END) AS NumberOfOpenContracts,
                             SUM(CASE WHEN DimService.ServiceType = 'Gas' Then 1 ELSE 0 END) AS NumberOfGasContracts,
                             SUM(CASE WHEN ContractStatus = 'Open' AND DimService.ServiceType = 'Gas' Then 1 ELSE 0 END) AS NumberOfOpenGasContracts,
                             SUM(CASE WHEN DimService.ServiceType = 'Electricity' Then 1 ELSE 0 END) AS NumberOfElectricityContracts,
                             SUM(CASE WHEN ContractStatus = 'Open' AND DimService.ServiceType = 'Electricity' Then 1 ELSE 0 END) AS NumberOfOpenElectricityContracts,
                             MAX(DimProduct.ProductId) AS MaxProductId
                      FROM   DW_Dimensional.DW.FactContract
                      INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactContract.AccountId
                      INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactContract.ServiceId
                      INNER  JOIN DW_Dimensional.DW.DimProduct ON DimProduct.ProductId = FactContract.ProductId
                      GROUP  BY DimAccount.AccountKey),
     factHeader AS (SELECT Dimaccount.AccountKey,
                           SUM(CASE FactHeader.PaidOnTime WHEN 'Yes' THEN 1 ELSE 0 END) AS NumberOfInvoicesPaidOnTime,
                        COUNT(*) AS NumberOfInvoices,
                        MIN(CASE FactHeader.PaidOnTime WHEN 'Yes' THEN FactHeader.IssueDateId ELSE 99991231 END) AS FirstInvoicePaidOnTime,
                        MAX(CASE FactHeader.PaidOnTime WHEN 'Yes' THEN FactHeader.IssueDateId ELSE 0 END) AS LastInvoicePaidOnTime
                    FROM   DW_Dimensional.DW.FactHeader
                    INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactHeader.AccountId
                    WHERE  CONVERT(DATE, CAST(FactHeader.DueDateId AS NCHAR(8)), 112) < GETDATE()
                    GROUP  BY DimAccount.AccountKey),
     promptPaymentDiscount AS (SELECT DimAccount.AccountKey,
                                   -1 * SUM(FactTransaction.Value + FactTransaction.Tax) AS PromptPaymentDiscountReceived
                               FROM   DW_Dimensional.DW.FactTransaction
             INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactTransaction.AccountId
             INNER  JOIN DW_Dimensional.DW.DimFinancialAccount ON DimFinancialAccount.FinancialAccountId = FactTransaction.FinancialAccountId AND DimFinancialAccount.FinancialAccountName = 'Prompt Payment Disc'
             GROUP  BY DimAccount.AccountKey)
SELECT -- DimAccount
       DimAccount.AccountCode,
       ISNULL(NULLIF(DimAccount.PostalAddressLine1,''),'{Unknown}') AS PostalAddressLine1,
       ISNULL(NULLIF(DimAccount.PostalSuburb,''),'{Unknown}') AS PostalSuburb,
       ISNULL(NULLIF(DimAccount.PostalPostcode,''),'{Un}') AS PostalPostcode,
       ISNULL(NULLIF(DimAccount.PostalState,''),'{U}') AS PostalState,
       ISNULL(NULLIF(DimAccount.PostalStateAsProvided,''),'{U}') AS PostalStateAsProvided,
       ISNULL(NULLIF(DimAccount.AccountStatus,''),'{Unkn}') AS AccountStatus,
       DimAccount.AccountCreationDate,
       DimAccount.AccountClosedDate,
       ISNULL(NULLIF(DimAccount.CreditControlStatus,''),'{Unknown}') AS CreditControlStatus,
       ISNULL(NULLIF(DimAccount.CreditControlCategory,''),'{Unknown}') AS CreditControlCategory,
       ISNULL(NULLIF(DimAccount.InvoiceDeliveryMethod,''),'{Unknown}') AS InvoiceDeliveryMethod,
       ISNULL(NULLIF(DimAccount.PaymentMethod,''),'{Unknown}') AS PaymentMethod,
       ISNULL(NULLIF(DimAccount.MyAccountStatus,''),'{Unknown}') AS MyAccountStatus,
       DATEDIFF(DAY, DimAccount.AccountCreationDate, ISNULL(DimAccount.AccountClosedDate, GETDATE())) AS AccountTenureInDays,
       -- DimCustomer
       DimCustomer.CustomerCode,
       ISNULL(NULLIF(DimCustomer.Title, ''), '{U}') AS Title,
       ISNULL(NULLIF(DimCustomer.FirstName, ''), '{Unknown}') AS FirstName,
       ISNULL(NULLIF(DimCustomer.MiddleInitial, ''), '{Unknown}') AS MiddleInitial,
       ISNULL(NULLIF(DimCustomer.LastName, ''), '{Unknown}') AS LastName,
       ISNULL(NULLIF(DimCustomer.PartyName, ''), '{Unknown}') AS PartyName,
       ISNULL(NULLIF(DimCustomer.ResidentialAddressLine1, ''), '{Unknown}') AS ResidentialAddressLine1,
       ISNULL(NULLIF(DimCustomer.ResidentialSuburb, ''), '{Unknown}') AS ResidentialSuburb,
       ISNULL(NULLIF(DimCustomer.ResidentialPostcode, ''), '{Un}') AS ResidentialPostcode,
       ISNULL(NULLIF(DimCustomer.ResidentialState, ''), '{U}') AS ResidentialState,
       ISNULL(NULLIF(DimCustomer.ResidentialStateAsProvided, ''), '{U}') AS ResidentialStateAsProvided,
       ISNULL(NULLIF(DimCustomer.PrimaryPhone, ''), '{Unknown}') AS PrimaryPhone,
       ISNULL(NULLIF(DimCustomer.PrimaryPhoneType, ''),'{Unk}') AS PrimaryPhoneType,
       ISNULL(NULLIF(DimCustomer.SecondaryPhone, ''), '{Unknown}') AS SecondaryPhone,
       ISNULL(NULLIF(DimCustomer.SecondaryPhoneType, ''),'{Unk}') AS SecondaryPhoneType,
       ISNULL(NULLIF(DimCustomer.MobilePhone, ''), '{Unknown}') AS MobilePhone,
       ISNULL(NULLIF(DimCustomer.Email, ''), '{Unknown}') AS Email,
       DimCustomer.DateOfBirth,
       DATEDIFF(YEAR, DimCustomer.DateOfBirth, GETDATE()) AS Age,
       ISNULL(NULLIF(DimCustomer.CustomerType, ''), '{Unknown}') AS CustomerType,
       ISNULL(NULLIF(DimCustomer.CustomerStatus, ''),'{Unk}') AS CustomerStatus,
       ISNULL(NULLIF(DimCustomer.OmbudsmanComplaints, ''),'{U}') AS OmbudsmanComplaints,
       DimCustomer.CreationDate,
       DimCustomer.JoinDate,
       ISNULL(NULLIF(DimCustomer.PrivacyPreferredStatus, ''),'{Unknown}') AS PrivacyPreferredStatus,
       -- factHeader
       COALESCE(factHeader.NumberOfInvoicesPaidOnTime, 0) AS NumberOfInvoicesPaidOnTime,
       COALESCE(factHeader.NumberOfInvoices, 0) AS NumberOfInvoices,
       CASE
         WHEN COALESCE(factHeader.FirstInvoicePaidOnTime, 99991231) = 99991231 THEN NULL
         ELSE CONVERT(DATE, CAST(factHeader.FirstInvoicePaidOnTime AS NCHAR(8)), 112)
       END AS FirstInvoicePaidOnTime,
       CASE
         WHEN COALESCE(factHeader.LastInvoicePaidOnTime, 0) = 0 THEN NULL
         ELSE CONVERT(DATE, CAST(factHeader.LastInvoicePaidOnTime AS NCHAR(8)), 112)
       END AS LastInvoicePaidOnTime,
       -- promptPaymentDiscount
       COALESCE(promptPaymentDiscount.PromptPaymentDiscountReceived, 0) AS PromptPaymentDiscountReceived,
       -- factContract
       COALESCE(factContract.NumberOfContracts, 0) AS NumberOfContracts,
       COALESCE(factContract.NumberOfOpenContracts, 0) AS NumberOfOpenContracts,
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
       COALESCE(DimProduct.ProductName, '{Unknown]') AS ProductName,
       -- Other
       YEAR(DimAccount.AccountClosedDate) AS AccountClosedYear,
       RIGHT('0' + CAST(MONTH(DimAccount.AccountClosedDate) AS NVARCHAR(2)), 2) AS AccountClosedMonth,
       CEILING(DATEDIFF(DAY, DimAccount.AccountCreationDate, ISNULL(DimAccount.AccountClosedDate, GETDATE())) / 30.4) AS AccountTenureInMonths
FROM   DW_Dimensional.DW.DimAccount
INNER  JOIN DW_Dimensional.DW.FactCustomerAccount ON FactCustomerAccount.AccountId = DimAccount.AccountId
INNER  JOIN DW_Dimensional.DW.DimCustomer ON DimCustomer.CustomerId = FactCustomerAccount.CustomerId
LEFT   JOIN factContract ON factContract.AccountKey = DimAccount.AccountKey
LEFT   JOIN DW_Dimensional.DW.DimProduct ON DimProduct.ProductId = factContract.MaxProductId
LEFT   JOIN factHeader ON factHeader.AccountKey = DimAccount.AccountKey
LEFT   JOIN promptPaymentDiscount ON promptPaymentDiscount.AccountKey = DimAccount.AccountKey
WHERE  DimAccount.Meta_IsCurrent = 1
AND    DimCustomer.Meta_IsCurrent = 1



GO
