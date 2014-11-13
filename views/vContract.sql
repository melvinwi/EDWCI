CREATE VIEW Views.vContract
AS
SELECT -- DimAccount
       DimAccountCurrent.AccountCode,
       DimAccountCurrent.PostalAddressLine1,
       DimAccountCurrent.PostalSuburb,
       DimAccountCurrent.PostalPostcode,
       DimAccountCurrent.PostalState,
       DimAccountCurrent.PostalStateAsProvided,
       DimAccountCurrent.AccountStatus,
       DimAccountCurrent.AccountCreationDate,
       DimAccountCurrent.AccountClosedDate,
       DimAccountCurrent.CreditControlStatus,
       DimAccountCurrent.CreditControlCategory,
       DimAccountCurrent.InvoiceDeliveryMethod,
       DimAccountCurrent.PaymentMethod,
       DimAccountCurrent.MyAccountStatus,
       DimAccountCurrent.ACN,
       DimAccountCurrent.ABN,
       -- DimService
       DimServiceCurrent.MarketIdentifier,
       DimServiceCurrent.ServiceType,
       DimServiceCurrent.LossFactor,
       DimServiceCurrent.EstimatedDailyConsumption,
       DimServiceCurrent.MeteringType,
       DimServiceCurrent.ResidentialSuburb,
       DimServiceCurrent.ResidentialPostcode,
       DimServiceCurrent.ResidentialState,
       DimServiceCurrent.NextScheduledReadDate,
       DimServiceCurrent.FRMPDate,
       DimServiceCurrent.Threshold,
       -- DimProduct
       DimProductCurrent.ProductName,
       DimProductCurrent.ProductDesc,
       DimProductCurrent.ProductType,
       -- DimPricePlan
       DimPricePlanCurrent.PricePlanCode,
       DimPricePlanCurrent.PricePlanName,
       DimPricePlanCurrent.PricePlanDiscountPercentage,
       DimPricePlanCurrent.PricePlanValueRatio,
       -- FactContract
       CONVERT(DATE, CAST(FactContract.ContractStartDateId AS NCHAR(8)), 112) AS ContractStartDate,
       CONVERT(DATE, CAST(FactContract.ContractEndDateId AS NCHAR(8)), 112) AS ContractEndDate,
       CONVERT(DATE, CAST(FactContract.ContractTerminatedDateId AS NCHAR(8)), 112) AS ContractTerminatedDate,
       FactContract.ContractStatus,
       FactContract.ContractCounter
FROM   DW_Dimensional.DW.FactContract
LEFT   JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactContract.AccountId
LEFT   JOIN DW_Dimensional.DW.DimAccount AS DimAccountCurrent ON DimAccountCurrent.AccountKey = DimAccount.AccountKey AND DimAccountCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactContract.ServiceId
LEFT   JOIN DW_Dimensional.DW.DimService AS DimServiceCurrent ON DimServiceCurrent.ServiceKey = DimService.ServiceKey AND DimServiceCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimProduct ON DimProduct.ProductId = FactContract.ProductId
LEFT   JOIN DW_Dimensional.DW.DimProduct AS DimProductCurrent ON DimProductCurrent.ProductKey = DimProduct.ProductKey AND DimProductCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimPricePlan ON DimPricePlan.PricePlanId = FactContract.PricePlanId
LEFT   JOIN DW_Dimensional.DW.DimPricePlan AS DimPricePlanCurrent ON DimPricePlanCurrent.PricePlanKey = DimPricePlan.PricePlanKey AND DimPricePlanCurrent.Meta_IsCurrent = 1;