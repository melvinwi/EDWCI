CREATE VIEW [Views].[vCustomerAccountHistorical]
AS
WITH   factSalesActivity
       AS (SELECT DimAccount.AccountKey,
                  DimOrganisation.OrganisationName,
                  ROW_NUMBER() OVER (PARTITION BY  DimAccount.AccountKey ORDER BY FactSalesActivity.SalesActivityDateId, FactSalesActivity.SalesActivityTime) AS Instance
           FROM   DW_Dimensional.DW.FactSalesActivity
           INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactSalesActivity.AccountId
           INNER  JOIN DW_Dimensional.DW.DimOrganisation ON DimOrganisation.OrganisationId = FactSalesActivity.OrganisationId)
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
       -- DimCustomer
       DimCustomer.CustomerCode,
       DimCustomer.Title,
       DimCustomer.FirstName,
       DimCustomer.MiddleInitial,
       DimCustomer.LastName,
       DimCustomer.PartyName,
       DimCustomer.ResidentialAddressLine1,
       DimCustomer.ResidentialSuburb,
       DimCustomer.ResidentialPostcode,
       DimCustomer.ResidentialState,
       DimCustomer.ResidentialStateAsProvided,
       DimCustomer.PrimaryPhone,
       DimCustomer.PrimaryPhoneType,
       DimCustomer.SecondaryPhone,
       DimCustomer.SecondaryPhoneType,
       DimCustomer.MobilePhone,
       DimCustomer.Email,
       DimCustomer.DateOfBirth,
       DATEDIFF(YEAR, DimCustomer.DateOfBirth, GETDATE())
       - CASE
           WHEN DATEDIFF(DAY, GETDATE(), DATEADD(YEAR, DATEDIFF (YEAR, DimCustomer.DateOfBirth, GETDATE()), DimCustomer.DateOfBirth)) > 0
           THEN 1 ELSE 0 --this is to subtract birthdays that are yet to occur in the current year
         END AS Age,
       DimCustomer.CustomerType,
       DimCustomer.CustomerStatus,
       DimCustomer.OmbudsmanComplaints,
       DimCustomer.CreationDate,
       DimCustomer.JoinDate,
       DimCustomer.PrivacyPreferredStatus,
       DimCustomer.InferredGender,
       -- FactCustomerAccount
       FactCustomerAccount.AccountRelationshipCounter,
       DimAccount.Meta_IsCurrent & DimCustomer.Meta_IsCurrent AS Meta_IsCurrent,
       (SELECT MAX(Meta_EffectiveStartDate)
        FROM   (VALUES (DimAccount.Meta_EffectiveStartDate),
               (DimCustomer.Meta_EffectiveStartDate)) t(Meta_EffectiveStartDate)) AS Meta_EffectiveStartDate,
       (SELECT MIN(Meta_EffectiveEndDate)
        FROM   (VALUES (DimAccount.Meta_EffectiveEndDate),
               (DimCustomer.Meta_EffectiveEndDate)) t(Meta_EffectiveEndDate)) AS Meta_EffectiveEndDate,
       -- FactSalesActivity
       FactSalesActivity.OrganisationName AS AcquisitionOrganisationName
FROM   DW_Dimensional.DW.FactCustomerAccount
INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactCustomerAccount.AccountId
INNER  JOIN DW_Dimensional.DW.DimCustomer ON DimCustomer.CustomerId = FactCustomerAccount.CustomerId
LEFT   JOIN factSalesActivity ON factSalesActivity.AccountKey = DimAccount.AccountKey AND factSalesActivity.Instance = 1;

GO

