USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [Views].[zz_vTransaction]
AS
WITH CustomerType
AS (SELECT DimCustomer.CustomerKey, DimCustomer.CustomerType FROM DW_Dimensional.DW.DimCustomer WHERE DimCustomer.Meta_IsCurrent = 1)
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
       -- DimService
       ISNULL(NULLIF(DimService.MarketIdentifier,''),'{Unknown}') AS MarketIdentifier,
       ISNULL(NULLIF(DimService.ServiceType,''),'{Unknown}') AS ServiceType,
	  DimService.LossFactor,
	  DimService.EstimatedDailyConsumption,
	  ISNULL(NULLIF(DimService.MeteringType,''),'{Unk}') AS MeteringType,
	  ISNULL(NULLIF(DimService.ResidentialSuburb,''),'{Unknown}') AS ServiceResidentialSuburb,
	  ISNULL(NULLIF(DimService.ResidentialPostcode,''),'{U}') AS ServiceResidentialPostcode,
	  ISNULL(NULLIF(DimService.ResidentialState,''),'{U}') AS ServiceResidentialState,
       -- DimProduct
       ISNULL(NULLIF(DimProduct.ProductName,''),'{Unknown}') AS ProductName,
       ISNULL(NULLIF(DimProduct.ProductDesc,''),'{Unknown}') AS ProductDesc,
       ISNULL(NULLIF(DimProduct.ProductType,''),'{Unk}') AS ProductType,
       -- DimFinancialAccount
       ISNULL(NULLIF(DimFinancialAccount.FinancialAccountName,''),'{Unknown}') AS FinancialAccountName,
       ISNULL(NULLIF(DimFinancialAccount.FinancialAccountType,''),'{Unknown}') AS FinancialAccountType,
       ISNULL(NULLIF(DimFinancialAccount.Level1Name,''),'{Unknown}') AS Level1Name,
       ISNULL(NULLIF(DimFinancialAccount.Level2Name,''),'{Unknown}') AS Level2Name,
       ISNULL(NULLIF(DimFinancialAccount.Level3Name,''),'{Unknown}') AS Level3Name,
       CONVERT(DATE, CAST(FactTransaction.TransactionDateId AS NCHAR(8)), 112) AS TransactionDate,
       -- DimVersion
       ISNULL(NULLIF(DimVersion.VersionName,''),'{Unknown}') AS VersionName,
       -- DimUnitType
       ISNULL(NULLIF(DimUnitType.UnitTypeName,''),'{Unknown}') AS UnitTypeName,
       DimUnitType.MultiplicationFactorToBase,
	  -- CustomerType
	  ISNULL(NULLIF(CustomerType.CustomerType,''),'{Unknown}') AS CustomerType,
	  --FactTransaction
       FactTransaction.Units,
       FactTransaction.Value,
       FactTransaction.Currency,
       FactTransaction.Tax,
       ISNULL(NULLIF(FactTransaction.TransactionDesc,''),'{Unknown}') AS TransactionDesc,
	  ISNULL(NULLIF(FactTransaction.TransactionType,''),'{Unknown}') AS TransactionType
FROM   DW_Dimensional.DW.FactTransaction
INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactTransaction.AccountId
INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactTransaction.ServiceId
INNER  JOIN DW_Dimensional.DW.DimProduct ON DimProduct.ProductId = FactTransaction.ProductId
INNER  JOIN DW_Dimensional.DW.DimFinancialAccount ON DimFinancialAccount.FinancialAccountId = FactTransaction.FinancialAccountId
INNER  JOIN DW_Dimensional.DW.DimVersion ON DimVersion.VersionId = FactTransaction.VersionId
INNER  JOIN DW_Dimensional.DW.DimUnitType ON DimUnitType.UnitTypeId = FactTransaction.UnitTypeId
LEFT   JOIN CustomerType ON CustomerType.CustomerKey = DimAccount.AccountKey





GO
