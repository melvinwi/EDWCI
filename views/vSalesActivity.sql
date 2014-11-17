CREATE VIEW Views.vSalesActivity
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
       DimAccountCurrent.AccountType,
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
       -- DimRepresentative
       DimRepresentativeCurrent.RepresentativePartyName,
       -- DimOrganisation
       DimOrganisationCurrent.OrganisationName,
       DimOrganisationCurrent.Level1Name,
       DimOrganisationCurrent.Level2Name,
       DimOrganisationCurrent.Level3Name,
       DimOrganisationCurrent.Level4Name,
       -- FactSalesActivity
       FactSalesActivity.SalesActivityType,
       CONVERT(DATETIME2, CAST(FactSalesActivity.SalesActivityDateId AS NCHAR(8)) + ' ' + CAST(FactSalesActivity.SalesActivityTime AS NCHAR(16))) AS SalesActivityDate
FROM   DW_Dimensional.DW.FactSalesActivity
LEFT   JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactSalesActivity.AccountId
LEFT   JOIN DW_Dimensional.DW.DimAccount AS DimAccountCurrent ON DimAccountCurrent.AccountKey = DimAccount.AccountKey AND DimAccountCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactSalesActivity.ServiceId
LEFT   JOIN DW_Dimensional.DW.DimService AS DimServiceCurrent ON DimServiceCurrent.ServiceKey = DimService.ServiceKey AND DimServiceCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimProduct ON DimProduct.ProductId = FactSalesActivity.ProductId
LEFT   JOIN DW_Dimensional.DW.DimProduct AS DimProductCurrent ON DimProductCurrent.ProductKey = DimProduct.ProductKey AND DimProductCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimPricePlan ON DimPricePlan.PricePlanId = FactSalesActivity.PricePlanId
LEFT   JOIN DW_Dimensional.DW.DimPricePlan AS DimPricePlanCurrent ON DimPricePlanCurrent.PricePlanKey = DimPricePlan.PricePlanKey AND DimPricePlanCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimRepresentative ON DimRepresentative.RepresentativeId = FactSalesActivity.RepresentativeId
LEFT   JOIN DW_Dimensional.DW.DimRepresentative AS DimRepresentativeCurrent ON DimRepresentativeCurrent.RepresentativeKey = DimRepresentative.RepresentativeKey AND DimRepresentative.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimOrganisation ON DimOrganisation.OrganisationId = FactSalesActivity.OrganisationId
LEFT   JOIN DW_Dimensional.DW.DimOrganisation AS DimOrganisationCurrent ON DimOrganisationCurrent.OrganisationKey = DimOrganisation.OrganisationKey AND DimOrganisation.Meta_IsCurrent = 1;