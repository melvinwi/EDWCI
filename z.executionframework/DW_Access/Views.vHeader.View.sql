USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [Views].[vHeader]
AS
SELECT --	DimAccount
       DimAccount.AccountCode,
       ISNULL(NULLIF(DimAccount.PostalAddressLine1,''),'{Unknown}') AS PostalAddressLine1,
       ISNULL(NULLIF(DimAccount.PostalSuburb,''),'{Unknown}') AS PostalSuburb,
       ISNULL(NULLIF(DimAccount.PostalPostcode,''),'{Un}') AS PostalPostcode,
       ISNULL(NULLIF(DimAccount.PostalState,''),'{U}') AS PostalState,
       ISNULL(NULLIF(DimAccount.PostalStateAsProvided,''),'{U}') AS PostalStateAsProvided,
       ISNULL(NULLIF(DimAccount.AccountStatus,''),'{Unkn}') AS AccountStatus,
       DimAccount.AccountCreationDate,
       DimAccount.AccountClosedDate,
       ISNULL(NULLIF(DimAccount.CreditControlStatus,''),'{Unknown}') AS CreditControlStatus,
       ISNULL(NULLIF(DimAccount.CreditControlCategory,''),'{Unknown}') AS CreditControlCategory,
       ISNULL(NULLIF(DimAccount.InvoiceDeliveryMethod,''),'{Unknown}') AS InvoiceDeliveryMethod,
       ISNULL(NULLIF(DimAccount.PaymentMethod,''),'{Unknown}') AS PaymentMethod,
       ISNULL(NULLIF(DimAccount.MyAccountStatus,''),'{Unknown}') AS MyAccountStatus,
       -- FactHeader
       CONVERT(DATE, CAST(FactHeader.IssueDateId AS NCHAR(8)), 112) AS IssueDate,
       CONVERT(DATE, CAST(FactHeader.DueDateId AS NCHAR(8)), 112) AS DueDate,
       ISNULL(NULLIF(FactHeader.HeaderType,''),'{Unkno}') AS HeaderType,
       ISNULL(NULLIF(FactHeader.PaidOnTime,''),'{U}') AS PaidOnTime,
	  ISNULL(NULLIF(FactHeader.HeaderKey,''),'{Unknown}') AS HeaderKey
FROM   DW_Dimensional.DW.FactHeader
INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactHeader.AccountId




GO
