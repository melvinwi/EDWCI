USE [DW_Access]
GO

/****** Object:  View [Views].[vContractHistorical]    Script Date: 2/09/2014 12:14:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Views].[vContractHistorical]
AS
SELECT DimAccount.AccountKey,
       DimService.ServiceKey,
       DimProduct.ProductKey,
       DimAccount.AccountCode,
       DimAccount.PostalAddressLine1,
       DimAccount.PostalSuburb,
       DimAccount.PostalPostcode,
       DimAccount.PostalState,
       DimAccount.PostalStateAsProvided,
       DimAccount.MyAccountStatus,
       DimAccount.CreationDate,
       DimAccount.AccountStatus,
       DimAccount.AccountClosedDate,
       DimAccount.AccountBillStartDate,
       DimAccount.CreditControlStatus,
       DimAccount.InvoiceDeliveryMethod,
       DimAccount.PaymentMethod,
       DimService.MarketIdentifier,
       DimService.ServiceType,
       DimProduct.ProductName,
       DimProduct.ProductDesc,
       DimProduct.ProductType,
       FactContract.ContractStartDateId,
       FactContract.ContractEndDateId,
       FactContract.ContractTerminatedDateId,
       FactContract.ContractStatus,
       FactContract.ContractKey,
       DATEDIFF(DAY,
                CONVERT(DATETIME, CAST(FactContract.ContractStartDateId AS NCHAR(8)), 112),
                CASE
                  WHEN CONVERT(DATETIME, CAST(FactContract.ContractStartDateId AS NCHAR(8)), 112) > GETDATE() OR FactContract.ContractTerminatedDateId < FactContract.ContractStartDateId THEN CONVERT(DATETIME, CAST(FactContract.ContractStartDateId AS NCHAR(8)), 112)
                  WHEN FactContract.ContractTerminatedDateId = 99991231 THEN GETDATE()
                  ELSE CONVERT(DATETIME, CAST(FactContract.ContractTerminatedDateId AS NCHAR(8)), 112)
                END) AS ContractTenure,
       FactContract.ContractCounter,
       (SELECT MAX(Meta_EffectiveStartDate)
        FROM   (VALUES (DimAccount.Meta_EffectiveStartDate),
                       (DimService.Meta_EffectiveStartDate),
                       (DimProduct.Meta_EffectiveStartdate)) t(Meta_EffectiveStartDate)) AS Meta_EffectiveStartDate,
       (SELECT MIN(Meta_EffectiveEndDate)
        FROM   (VALUES (DimAccount.Meta_EffectiveEndDate),
                       (DimService.Meta_EffectiveEndDate),
                       (DimProduct.Meta_EffectiveStartdate)) t(Meta_EffectiveEndDate)) AS Meta_EffectiveEndDate
FROM   DW_Dimensional.DW.FactContract
INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactContract.AccountId
INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactContract.ServiceId
INNER  JOIN DW_Dimensional.DW.DimProduct ON DimProduct.ProductId = FactContract.ProductId
WHERE  DimAccount.Meta_IsCurrent = 1
AND    DimService.Meta_IsCurrent = 1
AND    DimProduct.Meta_IsCurrent = 1


GO

