CREATE VIEW Views.vContractHistorical
AS
SELECT -- DimAccount
       DimAccount.AccountCode,
       DimAccount.PostalAddressLine1,
       DimAccount.PostalSuburb,
       DimAccount.PostalPostcode,
       DimAccount.PostalState,
       DimAccount.PostalStateAsProvided,
       DimAccount.AccountStatus,
       DimAccount.AccountCreationDate,
       DimAccount.AccountClosedDate,
       DimAccount.CreditControlStatus,
       DimAccount.CreditControlCategory,
       DimAccount.InvoiceDeliveryMethod,
       DimAccount.PaymentMethod,
       DimAccount.MyAccountStatus,
       DimAccount.ACN,
       DimAccount.ABN,
       -- DimService
       DimService.MarketIdentifier,
       DimService.ServiceType,
       DimService.LossFactor,
       DimService.EstimatedDailyConsumption,
       DimService.MeteringType,
       DimService.ResidentialSuburb,
       DimService.ResidentialPostcode,
       DimService.ResidentialState,
       DimService.NextScheduledReadDate,
       DimService.FRMPDate,
       DimService.Threshold,
       -- DimProduct
       DimProduct.ProductName,
       DimProduct.ProductDesc,
       DimProduct.ProductType,
       -- DimPricePlan
       DimPricePlan.PricePlanCode,
       DimPricePlan.PricePlanName,
       DimPricePlan.PricePlanDiscountPercentage,
       DimPricePlan.PricePlanValueRatio,
       -- FactContract
       CONVERT(DATE, CAST(FactContract.ContractStartDateId AS NCHAR(8)), 112) AS ContractStartDate,
       CONVERT(DATE, CAST(FactContract.ContractEndDateId AS NCHAR(8)), 112) AS ContractEndDate,
       CONVERT(DATE, CAST(FactContract.ContractTerminatedDateId AS NCHAR(8)), 112) AS ContractTerminatedDate,
       FactContract.ContractStatus,
       FactContract.ContractCounter
FROM   DW_Dimensional.DW.FactContract
LEFT   JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactContract.AccountId
LEFT   JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactContract.ServiceId
LEFT   JOIN DW_Dimensional.DW.DimProduct ON DimProduct.ProductId = FactContract.ProductId
LEFT   JOIN DW_Dimensional.DW.DimPricePlan ON DimPricePlan.PricePlanId = FactContract.PricePlanId;