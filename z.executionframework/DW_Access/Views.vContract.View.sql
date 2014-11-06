USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Views].[vContract]
AS
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
       -- DimProduct
       ISNULL(NULLIF(DimProduct.ProductName,''),'{Unknown}') AS ProductName,
       ISNULL(NULLIF(DimProduct.ProductDesc,''),'{Unknown}') AS ProductDesc,
       ISNULL(NULLIF(DimProduct.ProductType,''),'{Unk}') AS ProductType,
       -- DimPricePlan
       ISNULL(NULLIF(DimPricePlan.PricePlanCode,''),'{Unknown}') AS PricePlanCode,
       ISNULL(NULLIF(DimPricePlan.PricePlanName,''),'{Unknown}') AS PricePlanName,
       DimPricePlan.PricePlanDiscountPercentage,
       DimPricePlan.PricePlanValueRatio,
       -- FactContract
       CONVERT(DATE, CAST(FactContract.ContractStartDateId AS NCHAR(8)), 112) AS ContractStartDate,
       CONVERT(DATE, CAST(FactContract.ContractEndDateId AS NCHAR(8)), 112) AS ContractEndDate,
       CONVERT(DATE, CAST(FactContract.ContractTerminatedDateId AS NCHAR(8)), 112) AS ContractTerminatedDate,
       ISNULL(NULLIF(FactContract.ContractStatus,''),'{Unknown}') AS ContractStatus,
       DATEDIFF(DAY,
                CONVERT(DATETIME, CAST(FactContract.ContractStartDateId AS NCHAR(8)), 112),
                CASE
                  WHEN CONVERT(DATETIME, CAST(FactContract.ContractStartDateId AS NCHAR(8)), 112) > GETDATE() OR FactContract.ContractTerminatedDateId < FactContract.ContractStartDateId THEN CONVERT(DATETIME, CAST(FactContract.ContractStartDateId AS NCHAR(8)), 112)
                  WHEN FactContract.ContractTerminatedDateId = 99991231 THEN GETDATE()
                  ELSE CONVERT(DATETIME, CAST(FactContract.ContractTerminatedDateId AS NCHAR(8)), 112)
                END) AS ContractTenure,
       DATEDIFF(DAY,DimAccount.AccountCreationDate,ISNULL(DimAccount.AccountClosedDate,GETDATE())) AS AccountTenure,
       FactContract.ContractCounter
FROM   DW_Dimensional.DW.FactContract
INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactContract.AccountId
INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactContract.ServiceId
INNER  JOIN DW_Dimensional.DW.DimProduct ON DimProduct.ProductId = FactContract.ProductId
INNER  JOIN DW_Dimensional.DW.DimPricePlan ON DimPricePlan.PricePlanId = FactContract.PricePlanId;
GO
