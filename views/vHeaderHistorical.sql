CREATE VIEW [Views].[vHeaderHistorical]
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
       -- FactHeader
       CONVERT(DATE, CAST(FactHeader.IssueDateId AS NCHAR(8)), 112) AS IssueDate,
       CONVERT(DATE, CAST(FactHeader.DueDateId AS NCHAR(8)), 112) AS DueDate,
       FactHeader.HeaderType,
       FactHeader.PaidOnTime,
       FactHeader.HeaderKey
FROM   DW_Dimensional.DW.FactHeader
INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactHeader.AccountId

GO

