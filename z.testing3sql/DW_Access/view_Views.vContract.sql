USE [DW_Access]
GO

/****** Object:  View [Views].[vContract]    Script Date: 2/09/2014 12:14:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Views].[vContract]
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
       CONVERT(DATE, CAST(FactContract.ContractStartDateId AS NCHAR(8)), 112) AS ContractStartDateId,
       CONVERT(DATE, CAST(FactContract.ContractEndDateId AS NCHAR(8)), 112) AS ContractEndDateId,
       CONVERT(DATE, CAST(FactContract.ContractTerminatedDateId AS NCHAR(8)), 112) AS ContractTerminatedDateId,
       FactContract.ContractStatus,
       FactContract.ContractKey,
       DATEDIFF(DAY,
                CONVERT(DATETIME, CAST(FactContract.ContractStartDateId AS NCHAR(8)), 112),
                CASE
                  WHEN CONVERT(DATETIME, CAST(FactContract.ContractStartDateId AS NCHAR(8)), 112) > GETDATE() OR FactContract.ContractTerminatedDateId < FactContract.ContractStartDateId THEN CONVERT(DATETIME, CAST(FactContract.ContractStartDateId AS NCHAR(8)), 112)
                  WHEN FactContract.ContractTerminatedDateId = 99991231 THEN GETDATE()
                  ELSE CONVERT(DATETIME, CAST(FactContract.ContractTerminatedDateId AS NCHAR(8)), 112)
                END) AS ContractTenure,
       FactContract.ContractCounter
FROM   DW_Dimensional.DW.FactContract
INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactContract.AccountId
INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactContract.ServiceId
INNER  JOIN DW_Dimensional.DW.DimProduct ON DimProduct.ProductId = FactContract.ProductId
WHERE  DimAccount.Meta_IsCurrent = 1
AND    DimService.Meta_IsCurrent = 1
AND    DimProduct.Meta_IsCurrent = 1


GO

