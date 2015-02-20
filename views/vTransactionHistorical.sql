CREATE VIEW [Views].[vTransactionHistorical]
AS
SELECT -- DimAccount
       DimAccount.AccountCode,
       DimAccount.PostalAddressLine1,
       DimAccount.PostalSuburb,
       DimAccount.PostalPostcode,
       DimAccount.PostalState,
       DimAccount.PostalStateAsProvided,
       DimAccount.MyAccountStatus,
       DimAccount.AccountCreationDate,
       DimAccount.AccountStatus,
       DimAccount.AccountClosedDate,
       DimAccount.CreditControlStatus,
       DimAccount.InvoiceDeliveryMethod,
       DimAccount.PaymentMethod,
       DimAccount.CreditControlCategory,
       DimAccount.ACN, 
       DimAccount.ABN,
       DimAccount.AccountType,
       DimAccount.BillCycleCode,
       DimAccount.DistrictState,
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
       -- DimFinancialAccount
       DimFinancialAccount.FinancialAccountName,
       DimFinancialAccount.FinancialAccountNumber,
       DimFinancialAccount.FinancialAccountType,
       DimFinancialAccount.Level1Name,
       DimFinancialAccount.Level2Name,
       DimFinancialAccount.Level3Name,
       -- DimVersion
       DimVersion.VersionName,
       -- DimUnitType
       DimUnitType.UnitTypeName,
       DimUnitType.MultiplicationFactorToBase,
       -- DimMeterRegister
       DimMeterRegister.MeterMarketSerialNumber,
       DimMeterRegister.MeterSystemSerialNumber,
       DimMeterRegister.MeterServiceType,
       DimMeterRegister.RegisterBillingType,
       DimMeterRegister.RegisterBillingTypeCode,
       DimMeterRegister.RegisterClass,
       DimMeterRegister.RegisterCreationDate,
       DimMeterRegister.RegisterEstimatedDailyConsumption,
       DimMeterRegister.RegisterMarketIdentifier,
       DimMeterRegister.RegisterSystemIdentifer,
       DimMeterRegister.RegisterMultiplier,
       DimMeterRegister.RegisterNetworkTariffCode,
       DimMeterRegister.RegisterReadDirection,
       DimMeterRegister.RegisterStatus,
       DimMeterRegister.RegisterVirtualStartDate,
       DimMeterRegister.RegisterVirtualType,
       --FactTransaction
       CONVERT(DATE, CAST(FactTransaction.TransactionDateId AS NCHAR(8)), 112) AS TransactionDate,
       FactTransaction.Units,
       FactTransaction.Value,
       FactTransaction.Currency,
       FactTransaction.Tax,
       FactTransaction.TransactionType,
       FactTransaction.TransactionDesc,
       FactTransaction.TransactionSubtype,
       FactTransaction.Reversal,
       FactTransaction.Reversed,
       FactTransaction.StartRead,
       FactTransaction.EndRead,
       FactTransaction.AccountingPeriod,
       CONVERT(DATE, CAST(FactTransaction.StartDateId AS NCHAR(8)), 112) AS StartDate,
       CONVERT(DATE, CAST(FactTransaction.EndDateId AS NCHAR(8)), 112) AS EndDate
FROM   DW_Dimensional.DW.FactTransaction
LEFT   JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactTransaction.AccountId
LEFT   JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactTransaction.ServiceId
LEFT   JOIN DW_Dimensional.DW.DimTransmissionNode ON DimTransmissionNode.TransmissionNodeId = DimService.TransmissionNodeId
LEFT   JOIN DW_Dimensional.DW.DimProduct ON DimProduct.ProductId = FactTransaction.ProductId
LEFT   JOIN DW_Dimensional.DW.DimFinancialAccount ON DimFinancialAccount.FinancialAccountId = FactTransaction.FinancialAccountId
LEFT   JOIN DW_Dimensional.DW.DimVersion ON DimVersion.VersionId = FactTransaction.VersionId
LEFT   JOIN DW_Dimensional.DW.DimUnitType ON DimUnitType.UnitTypeId = FactTransaction.UnitTypeId
LEFT   JOIN DW_Dimensional.DW.DimMeterRegister ON DimMeterRegister.MeterRegisterId = FactTransaction.MeterRegisterId


GO

