USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Views].[zz_vCustomerAccount]
AS 
SELECT DimAccount.AccountKey,
       DimAccount.AccountCode,               
       ISNULL(NULLIF(DimAccount.AccountStatus,''),'{Unkn}') AS AccountStatus,
       DimAccount.AccountCreationDate,
       DimAccount.AccountClosedDate,
       ISNULL(NULLIF(DimAccount.CreditControlStatus,''),'{Unknown}') AS CreditControlStatus,
       ISNULL(NULLIF(DimAccount.CreditControlCategory,''),'{Unknown}') AS CreditControlCategory,
       ISNULL(NULLIF(DimAccount.InvoiceDeliveryMethod,''),'{Unknown}') AS InvoiceDeliveryMethod,
       ISNULL(NULLIF(DimAccount.PaymentMethod,''),'{Unknown}') AS PaymentMethod,
       ISNULL(NULLIF(DimAccount.MyAccountStatus,''),'{Unknown}') AS MyAccountStatus,
       DATEDIFF(DAY,DimAccount.AccountCreationDate,ISNULL(DimAccount.AccountClosedDate,GETDATE())) AS TenureDays,              
       DimCustomer.CustomerKey,
       DimCustomer.CustomerCode                ,
       ISNULL(NULLIF(DimCustomer.Title, '') , '{U}') AS Title,
       ISNULL(NULLIF(DimCustomer.FirstName, '') , '{Unknown}') AS FirstName,
       ISNULL(NULLIF(DimCustomer.MiddleInitial, '') , '{Unknown}') AS MiddleInitial,
       ISNULL(NULLIF(DimCustomer.LastName, '') , '{Unknown}') AS LastName,
       ISNULL(NULLIF(DimCustomer.PartyName, '') , '{Unknown}') AS PartyName,
       ISNULL(NULLIF(DimCustomer.PostalAddressLine1, '') , '{Unknown}') AS PostalAddressLine1,
       ISNULL(NULLIF(DimCustomer.PostalSuburb, '') , '{Unknown}') AS PostalSuburb,
       ISNULL(NULLIF(DimCustomer.PostalPostcode, '') , '{Un}') AS PostalPostcode,
       ISNULL(NULLIF(DimCustomer.PostalState, '') , '{U}') AS PostalState,
       ISNULL(NULLIF(DimCustomer.PostalStateAsProvided, '') , '{U}') AS PostalStateAsProvided,
       ISNULL(NULLIF(DimCustomer.ResidentialAddressLine1, '') , '{Unknown}') AS ResidentialAddressLine1,
       ISNULL(NULLIF(DimCustomer.ResidentialSuburb, '') , '{Unknown}') AS ResidentialSuburb,
       ISNULL(NULLIF(DimCustomer.ResidentialPostcode, '') , '{Un}') AS ResidentialPostcode,
       ISNULL(NULLIF(DimCustomer.ResidentialState, '') , '{U}') AS ResidentialState,
       ISNULL(NULLIF(DimCustomer.ResidentialStateAsProvided, '') , '{U}') AS ResidentialStateAsProvided,
       ISNULL(NULLIF(DimCustomer.PrimaryPhone, '') , '{Unknown}') AS PrimaryPhone,
       ISNULL(NULLIF(DimCustomer.PrimaryPhoneType, '') , '{Unk}') AS PrimaryPhoneType,
       ISNULL(NULLIF(DimCustomer.SecondaryPhone, '') , '{Unknown}') AS SecondaryPhone,
       ISNULL(NULLIF(DimCustomer.SecondaryPhoneType, '') , '{Unk}') AS SecondaryPhoneType,
       ISNULL(NULLIF(DimCustomer.MobilePhone, '') , '{Unknown}') AS MobilePhone,
       ISNULL(NULLIF(DimCustomer.Email, '') , '{Unknown}') AS Email,
       DimCustomer.DateOfBirth,
       DATEDIFF(YEAR, DimCustomer.DateOfBirth, GETDATE())
       - CASE
           WHEN DATEDIFF(DAY, GETDATE(), DATEADD(YEAR, DATEDIFF (YEAR, DimCustomer.DateOfBirth, GETDATE()), DimCustomer.DateOfBirth)) > 0
           THEN 1 ELSE 0 --this is to subtract birthdays that are yet to occur in the current year
         END AS Age,
       ISNULL(NULLIF(DimCustomer.CustomerType, '') , '{Unknown}') AS CustomerType,
       ISNULL(NULLIF(DimCustomer.CustomerStatus, '') , '{Unk}') AS CustomerStatus,
       ISNULL(NULLIF(DimCustomer.OmbudsmanComplaints, '') , '{U}') AS OmbudsmanComplaints,
       DimCustomer.CreationDate,
       DimCustomer.JoinDate,
       ISNULL(NULLIF(DimCustomer.PrivacyPreferredStatus, '') , '{Unknown}') AS PrivacyPreferredStatus,
       FactCustomerAccount.AccountRelationshipCounter
FROM   DW_Dimensional.DW.FactCustomerAccount 
INNER  JOIN  DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactCustomerAccount.AccountId
INNER  JOIN  DW_Dimensional.DW.DimCustomer ON DimCustomer.CustomerId = FactCustomerAccount.CustomerId
WHERE  DimAccount.Meta_IsCurrent = 1
AND    DimCustomer.Meta_IsCurrent = 1;
GO
