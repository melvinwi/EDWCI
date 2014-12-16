USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [Views].[vContractHistorical]
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
	  -- DimTransmissionNode
	  DimTransmissionNode.TransmissionNodeIdentity,
	  DimTransmissionNode.TransmissionNodeName,
	  DimTransmissionNode.TransmissionNodeState,
	  DimTransmissionNode.TransmissionNodeNetwork,
	  DimTransmissionNode.TransmissionNodeServiceType,
	  DimTransmissionNode.TransmissionNodeLossFactor,
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
LEFT   JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactContract.ServiceId
LEFT   JOIN DW_Dimensional.DW.DimTransmissionNode ON DimTransmissionNode.TransmissionNodeId = DimService.TransmissionNodeId
LEFT   JOIN DW_Dimensional.DW.DimProduct ON DimProduct.ProductId = FactContract.ProductId
LEFT   JOIN DW_Dimensional.DW.DimPricePlan ON DimPricePlan.PricePlanId = FactContract.PricePlanId
LEFT   JOIN dimCustomer ON dimCustomer.AccountKey = DimAccount.AccountKey AND dimCustomer.recency = 1;




GO
