CREATE VIEW Views.vSalesActivityHistorical
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
       DimAccount.AccountType,
       DimAccount.BillCycleCode,
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
       DimService.FirstImportRegisterDate,
       DimService.SiteStatus,
       DimService.SiteStatusType,
       -- DimProduct
       DimProduct.ProductName,
       DimProduct.ProductDesc,
       DimProduct.ProductType,
       DimProduct.FixedTariffAdjustPercentage,
       DimProduct.VariableTariffAdjustPercentage,
       -- DimPricePlan
       DimPricePlan.PricePlanCode,
       DimPricePlan.PricePlanName,
       DimPricePlan.PricePlanDiscountPercentage,
       DimPricePlan.PricePlanValueRatio,
       DimPricePlan.PricePlanType,
       DimPricePlan.Bundled,
       DimPricePlan.ParentPricePlanCode,
       -- DimRepresentative
       DimRepresentative.RepresentativePartyName,
       -- DimOrganisation
       DimOrganisation.OrganisationName,
       DimOrganisation.Level1Name,
       DimOrganisation.Level2Name,
       DimOrganisation.Level3Name,
       DimOrganisation.Level4Name,
       -- FactSalesActivity
       FactSalesActivity.SalesActivityType,
       CONVERT(DATETIME2, CAST(FactSalesActivity.SalesActivityDateId AS NCHAR(8)) + ' ' + CAST(FactSalesActivity.SalesActivityTime AS NCHAR(16))) AS SalesActivityDate
FROM   DW_Dimensional.DW.FactSalesActivity
LEFT   JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactSalesActivity.AccountId
LEFT   JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactSalesActivity.ServiceId
LEFT   JOIN DW_Dimensional.DW.DimProduct ON DimProduct.ProductId = FactSalesActivity.ProductId
LEFT   JOIN DW_Dimensional.DW.DimPricePlan ON DimPricePlan.PricePlanId = FactSalesActivity.PricePlanId
LEFT   JOIN DW_Dimensional.DW.DimRepresentative ON DimRepresentative.RepresentativeId = FactSalesActivity.RepresentativeId
LEFT   JOIN DW_Dimensional.DW.DimOrganisation ON DimOrganisation.OrganisationId = FactSalesActivity.OrganisationId;