CREATE VIEW [Views].[vTransaction]
AS
SELECT -- DimAccount
       DimAccountCurrent.AccountCode,
       DimAccountCurrent.PostalAddressLine1,
       DimAccountCurrent.PostalSuburb,
       DimAccountCurrent.PostalPostcode,
       DimAccountCurrent.PostalState,
       DimAccountCurrent.PostalStateAsProvided,
       DimAccountCurrent.MyAccountStatus,
       DimAccountCurrent.AccountCreationDate,
       DimAccountCurrent.AccountStatus,
       DimAccountCurrent.AccountClosedDate,
       DimAccountCurrent.CreditControlStatus,
       DimAccountCurrent.InvoiceDeliveryMethod,
       DimAccountCurrent.PaymentMethod,
       DimAccountCurrent.CreditControlCategory,
       DimAccountCurrent.ACN, 
       DimAccountCurrent.ABN,
       DimAccountCurrent.AccountType,
       DimAccountCurrent.BillCycleCode,
       DimAccountCurrent.DistrictState,
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
       -- DimFinancialAccount
       DimFinancialAccountCurrent.FinancialAccountName,
       DimFinancialAccount.FinancialAccountNumber,
       DimFinancialAccountCurrent.FinancialAccountType,
       DimFinancialAccountCurrent.Level1Name,
       DimFinancialAccountCurrent.Level2Name,
       DimFinancialAccountCurrent.Level3Name,
       -- DimVersion
       DimVersionCurrent.VersionName,
       -- DimUnitType
       DimUnitTypeCurrent.UnitTypeName,
       DimUnitTypeCurrent.MultiplicationFactorToBase,
       -- DimMeterRegister
       DimMeterRegisterCurrent.MeterMarketSerialNumber,
       DimMeterRegisterCurrent.MeterSystemSerialNumber,
       DimMeterRegisterCurrent.MeterServiceType,
       DimMeterRegisterCurrent.RegisterBillingType,
       DimMeterRegisterCurrent.RegisterBillingTypeCode,
       DimMeterRegisterCurrent.RegisterClass,
       DimMeterRegisterCurrent.RegisterCreationDate,
       DimMeterRegisterCurrent.RegisterEstimatedDailyConsumption,
       DimMeterRegisterCurrent.RegisterMarketIdentifier,
       DimMeterRegisterCurrent.RegisterSystemIdentifer,
       DimMeterRegisterCurrent.RegisterMultiplier,
       DimMeterRegisterCurrent.RegisterNetworkTariffCode,
       DimMeterRegisterCurrent.RegisterReadDirection,
       DimMeterRegisterCurrent.RegisterStatus,
       DimMeterRegisterCurrent.RegisterVirtualStartDate,
       DimMeterRegisterCurrent.RegisterVirtualType,
       --FactTransaction
       CONVERT(DATE, CAST(FactTransaction.TransactionDateId AS NCHAR(8)), 112) AS TransactionDate,
       CONVERT(DATE, CAST(FactTransaction.PostedDateId AS NCHAR(8)), 112) AS PostedDate,
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
       CONVERT(DATE, CAST(FactTransaction.EndDateId AS NCHAR(8)), 112) AS EndDate,
       FactTransaction.ReceiptBatch
FROM   DW_Dimensional.DW.FactTransaction
LEFT   JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactTransaction.AccountId
LEFT   JOIN DW_Dimensional.DW.DimAccount AS DimAccountCurrent ON DimAccountCurrent.AccountKey = DimAccount.AccountKey AND DimAccountCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactTransaction.ServiceId
LEFT   JOIN DW_Dimensional.DW.DimService AS DimServiceCurrent ON DimServiceCurrent.ServiceKey = DimService.ServiceKey AND DimServiceCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimTransmissionNode AS DimTransmissionNodeCurrent ON DimTransmissionNodeCurrent.TransmissionNodeId = DimServiceCurrent.TransmissionNodeId
LEFT   JOIN DW_Dimensional.DW.DimProduct ON DimProduct.ProductId = FactTransaction.ProductId
LEFT   JOIN DW_Dimensional.DW.DimProduct AS DimProductCurrent ON DimProductCurrent.ProductKey = DimProduct.ProductKey AND DimProductCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimFinancialAccount ON DimFinancialAccount.FinancialAccountId = FactTransaction.FinancialAccountId
LEFT   JOIN DW_Dimensional.DW.DimFinancialAccount AS DimFinancialAccountCurrent ON DimFinancialAccountCurrent.FinancialAccountKey = DimFinancialAccount.FinancialAccountKey AND DimFinancialAccountCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimVersion AS DimVersionCurrent ON DimVersionCurrent.VersionId = FactTransaction.VersionId
LEFT   JOIN DW_Dimensional.DW.DimUnitType ON DimUnitType.UnitTypeId = FactTransaction.UnitTypeId
LEFT   JOIN DW_Dimensional.DW.DimUnitType AS DimUnitTypeCurrent ON DimUnitTypeCurrent.UnitTypeKey = DimUnitType.UnitTypeKey AND DimUnitTypeCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimMeterRegister ON DimMeterRegister.MeterRegisterId = FactTransaction.MeterRegisterId
LEFT   JOIN DW_Dimensional.DW.DimMeterRegister AS DimMeterRegisterCurrent ON DimMeterRegisterCurrent.MeterRegisterKey = DimMeterRegister.MeterRegisterKey AND DimMeterRegisterCurrent.Meta_IsCurrent = 1


GO

