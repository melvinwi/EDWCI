USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Views].[vHeader]
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
       -- FactHeader
       CONVERT(DATE, CAST(FactHeader.IssueDateId AS NCHAR(8)), 112) AS IssueDate,
       CONVERT(DATE, CAST(FactHeader.DueDateId AS NCHAR(8)), 112) AS DueDate,
       FactHeader.HeaderType,
       FactHeader.PaidOnTime,
       FactHeader.HeaderKey
FROM   DW_Dimensional.DW.FactHeader
INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactHeader.AccountId
INNER  JOIN DW_Dimensional.DW.DimAccount AS DimAccountCurrent ON DimAccountCurrent.AccountKey = DimAccount.AccountKey AND DimAccountCurrent.Meta_IsCurrent = 1


GO
