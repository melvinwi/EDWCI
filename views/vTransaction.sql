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
         -- DimProduct
         DimProductCurrent.ProductName,
       DimProductCurrent.ProductDesc,
       DimProductCurrent.ProductType,
         -- DimFinancialAccount
         DimFinancialAccountCurrent.FinancialAccountName,
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
         FactTransaction.Units,
       FactTransaction.Value,
       FactTransaction.Currency,
       FactTransaction.Tax,
       FactTransaction.TransactionType,
         FactTransaction.TransactionDesc    
FROM   DW_Dimensional.DW.FactTransaction
LEFT   JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactTransaction.AccountId
LEFT   JOIN DW_Dimensional.DW.DimAccount AS DimAccountCurrent ON DimAccountCurrent.AccountKey = DimAccount.AccountKey AND DimAccountCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactTransaction.ServiceId
LEFT   JOIN DW_Dimensional.DW.DimService AS DimServiceCurrent ON DimServiceCurrent.ServiceKey = DimService.ServiceKey AND DimServiceCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimProduct ON DimProduct.ProductId = FactTransaction.ProductId
LEFT   JOIN DW_Dimensional.DW.DimProduct AS DimProductCurrent ON DimProductCurrent.ProductKey = DimProduct.ProductKey AND DimProductCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimFinancialAccount ON DimFinancialAccount.FinancialAccountId = FactTransaction.FinancialAccountId
LEFT   JOIN DW_Dimensional.DW.DimFinancialAccount AS DimFinancialAccountCurrent ON DimFinancialAccountCurrent.FinancialAccountKey = DimFinancialAccount.FinancialAccountKey AND DimFinancialAccountCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimVersion AS DimVersionCurrent ON DimVersionCurrent.VersionId = FactTransaction.VersionId
LEFT   JOIN DW_Dimensional.DW.DimUnitType ON DimUnitType.UnitTypeId = FactTransaction.UnitTypeId
LEFT   JOIN DW_Dimensional.DW.DimUnitType AS DimUnitTypeCurrent ON DimUnitTypeCurrent.UnitTypeKey = DimUnitType.UnitTypeKey AND DimUnitTypeCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimMeterRegister ON DimMeterRegister.MeterRegisterId = FactTransaction.MeterRegisterId
LEFT   JOIN DW_Dimensional.DW.DimMeterRegister AS DimMeterRegisterCurrent ON DimMeterRegisterCurrent.MeterRegisterKey = DimMeterRegister.MeterRegisterKey AND DimMeterRegisterCurrent.Meta_IsCurrent = 1;