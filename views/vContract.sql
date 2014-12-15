CREATE VIEW Views.vContract
AS
WITH dimCustomer
       AS (SELECT DimAccount.AccountKey,
                  DimCustomer.CustomerKey,
                  DimCustomer.LastName,
                  ROW_NUMBER() OVER (PARTITION BY DimAccount.AccountKey ORDER BY DimCustomer.Meta_EffectiveStartDate DESC) AS recency
           FROM   DW_Dimensional.DW.DimAccount
           INNER  JOIN DW_Dimensional.DW.FactCustomerAccount ON FactCustomerAccount.AccountId = DimAccount.AccountId
           INNER  JOIN DW_Dimensional.DW.DimCustomer ON DimCustomer.CustomerId = FactCustomerAccount.CustomerId)
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
	   DimAccountCurrent.BillCycleCode,
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
	   DimServiceCurrent.FirstImportRegisterDate,
       DimServiceCurrent.SiteStatus,
       DimServiceCurrent.SiteStatusType,
	   -- DimTransmissionNode
	   DimTransmissionNodeCurrent.TransmissionNodeIdentity,
	   DimTransmissionNodeCurrent.TransmissionNodeName,
	   DimTransmissionNodeCurrent.TransmissionNodeState,
	   DimTransmissionNodeCurrent.TransmissionNodeNetwork,
	   DimTransmissionNodeCurrent.TransmissionNodeServiceType,
	   DimTransmissionNodeCurrent.TransmissionNodeLossFactor,
       -- DimProduct
       DimProductCurrent.ProductName,
       DimProductCurrent.ProductDesc,
       DimProductCurrent.ProductType,
	   DimProductCurrent.FixedTariffAdjustPercentage,
	   DimProductCurrent.VariableTariffAdjustPercentage,
       -- DimPricePlan
       DimPricePlanCurrent.PricePlanCode,
       DimPricePlanCurrent.PricePlanName,
       DimPricePlanCurrent.PricePlanDiscountPercentage,
       DimPricePlanCurrent.PricePlanValueRatio,
	   DimPricePlanCurrent.PricePlanType,
	   DimPricePlanCurrent.Bundled,
	   DimPricePlanCurrent.ParentPricePlanCode,
	   -- dimCustomer
	   dimCustomer.LastName,
       -- FactContract
       CONVERT(DATE, CAST(FactContract.ContractConnectedDateId AS NCHAR(8)), 112) AS ContractConnectedDate,
	   CONVERT(DATE, CAST(FactContract.ContractFRMPDateId AS NCHAR(8)), 112) AS ContractFRMPDate,
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
LEFT   JOIN DW_Dimensional.DW.DimTransmissionNode AS DimTransmissionNodeCurrent ON DimTransmissionNodeCurrent.TransmissionNodeId = DimServiceCurrent.TransmissionNodeId
LEFT   JOIN DW_Dimensional.DW.DimProduct ON DimProduct.ProductId = FactContract.ProductId
LEFT   JOIN DW_Dimensional.DW.DimProduct AS DimProductCurrent ON DimProductCurrent.ProductKey = DimProduct.ProductKey AND DimProductCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimPricePlan ON DimPricePlan.PricePlanId = FactContract.PricePlanId
LEFT   JOIN DW_Dimensional.DW.DimPricePlan AS DimPricePlanCurrent ON DimPricePlanCurrent.PricePlanKey = DimPricePlan.PricePlanKey AND DimPricePlanCurrent.Meta_IsCurrent = 1
LEFT   JOIN dimCustomer ON dimCustomer.AccountKey = DimAccountCurrent.AccountKey AND dimCustomer.recency = 1;