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
       DimAccountCurrent.Meta_IsCurrent AS Account_Meta_IsCurrent,
       DimAccountCurrent.Meta_EffectiveStartDate AS Account_Meta_EffectiveStartDate,
       DimAccountCurrent.Meta_EffectiveEndDate AS Account_Meta_EffectiveEndDate,
       -- DimCustomer
       DimCustomerCurrent.CustomerCode,
       DimCustomerCurrent.Title,
       DimCustomerCurrent.FirstName,
       DimCustomerCurrent.MiddleInitial,
       DimCustomerCurrent.LastName,
       DimCustomerCurrent.PartyName,
       DimCustomerCurrent.ResidentialAddressLine1,
       DimCustomerCurrent.ResidentialSuburb,
       DimCustomerCurrent.ResidentialPostcode,
       DimCustomerCurrent.ResidentialState,
       DimCustomerCurrent.ResidentialStateAsProvided,
       DimCustomerCurrent.PrimaryPhone,
       DimCustomerCurrent.PrimaryPhoneType,
       DimCustomerCurrent.SecondaryPhone,
       DimCustomerCurrent.SecondaryPhoneType,
       DimCustomerCurrent.MobilePhone,
       DimCustomerCurrent.Email,
       DimCustomerCurrent.DateOfBirth,
       DATEDIFF(YEAR, DimCustomerCurrent.DateOfBirth, GETDATE())
       - CASE
           WHEN DATEDIFF(DAY, GETDATE(), DATEADD(YEAR, DATEDIFF (YEAR, DimCustomerCurrent.DateOfBirth, GETDATE()), DimCustomerCurrent.DateOfBirth)) > 0
           THEN 1 ELSE 0 --this is to subtract birthdays that are yet to occur in the current year
         END AS Age,
       DimCustomerCurrent.CustomerType,
       DimCustomerCurrent.CustomerStatus,
       DimCustomerCurrent.OmbudsmanComplaints,
       DimCustomerCurrent.CreationDate,
       DimCustomerCurrent.JoinDate,
       DimCustomerCurrent.PrivacyPreferredStatus,
       DimCustomerCurrent.InferredGender,
       DimCustomerCurrent.Meta_IsCurrent AS Customer_Meta_IsCurrent,
       DimCustomerCurrent.Meta_EffectiveStartDate AS Customer_Meta_EffectiveStartDate,
       DimCustomerCurrent.Meta_EffectiveEndDate AS Customer_Meta_EffectiveEndDate,
       -- FactCustomerAccount
       FactCustomerAccount.AccountRelationshipCounter,
       -- FactSalesActivity
       FactSalesActivity.OrganisationName AS AcquisitionOrganisationName
FROM   DW_Dimensional.DW.FactCustomerAccount
INNER  JOIN DW_Dimensional.DW.DimAccount AS DimAccountCurrent ON DimAccountCurrent.AccountId = FactCustomerAccount.AccountId
INNER  JOIN DW_Dimensional.DW.DimCustomer AS DimCustomerCurrent ON DimCustomerCurrent.CustomerId = FactCustomerAccount.CustomerId
LEFT   JOIN factSalesActivity ON factSalesActivity.AccountKey = DimAccountCurrent.AccountKey AND factSalesActivity.Instance = 1;