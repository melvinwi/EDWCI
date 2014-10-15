CREATE VIEW Views.vCustomerHistorical
AS 
WITH   factActivity
       AS (SELECT DimCustomer.CustomerKey,
                  FactActivity.ActivityNotes,
                  ROW_NUMBER() OVER (PARTITION BY  DimCustomer.CustomerKey ORDER BY FactActivity.ActivityDateId DESC, FactActivity.ActivityTime DESC) AS Recency
           FROM   DW_Dimensional.DW.FactActivity
           INNER  JOIN DW_Dimensional.DW.DimCustomer ON DimCustomer.CustomerId = FactActivity.CustomerId)
SELECT CustomerCode,
       ISNULL(NULLIF(Title, ''),'{U}'      ) AS Title,
       ISNULL(NULLIF(FirstName, ''),'{Unknown}') AS FirstName,
       ISNULL(NULLIF(MiddleInitial, ''),'{Unknown}') AS MiddleInitial,
       ISNULL(NULLIF(LastName, ''),'{Unknown}') AS LastName,
       ISNULL(NULLIF(PartyName, ''),'{Unknown}') AS PartyName,
       ISNULL(NULLIF(PostalAddressLine1, ''),'{Unknown}') AS PostalAddressLine1,
       ISNULL(NULLIF(PostalSuburb, ''),'{Unknown}') AS PostalSuburb,
       ISNULL(NULLIF(PostalPostcode, ''),'{Un}'     ) AS PostalPostcode,
       ISNULL(NULLIF(PostalState, ''),'{U}'      ) AS PostalState,
       ISNULL(NULLIF(PostalStateAsProvided, ''),'{U}'      ) AS PostalStateAsProvided,
       ISNULL(NULLIF(ResidentialAddressLine1, ''),'{Unknown}') AS ResidentialAddressLine1,
       ISNULL(NULLIF(ResidentialSuburb, ''),'{Unknown}') AS ResidentialSuburb,
       ISNULL(NULLIF(ResidentialPostcode, ''),'{Un}'     ) AS ResidentialPostcode,
       ISNULL(NULLIF(ResidentialState, ''),'{U}'      ) AS ResidentialState,
       ISNULL(NULLIF(ResidentialStateAsProvided,''),'{U}'      ) AS ResidentialStateAsProvided,
       ISNULL(NULLIF(PrimaryPhone, ''),'{Unknown}') AS PrimaryPhone,
       ISNULL(NULLIF(PrimaryPhoneType, ''),'{Unk}'    ) AS PrimaryPhoneType,
       ISNULL(NULLIF(SecondaryPhone, ''),'{Unknown}') AS SecondaryPhone,
       ISNULL(NULLIF(SecondaryPhoneType, ''),'{Unk}'    ) AS SecondaryPhoneType,
       ISNULL(NULLIF(MobilePhone, ''),'{Unknown}') AS MobilePhone,
       ISNULL(NULLIF(Email, ''),'{Unknown}') AS Email,
       DateOfBirth,
       DATEDIFF(YEAR, DimCustomer.DateOfBirth, GETDATE())
       - CASE
           WHEN DATEDIFF(DAY, GETDATE(), DATEADD(YEAR, DATEDIFF (YEAR, DimCustomer.DateOfBirth, GETDATE()), DimCustomer.DateOfBirth)) > 0
           THEN 1 ELSE 0 --this is to subtract birthdays that are yet to occur in the current year
         END AS Age,
       ISNULL(NULLIF(CustomerType, ''),'{Unknown}') AS CustomerType,
       ISNULL(NULLIF(CustomerStatus, ''),'{Unk}'    ) AS CustomerStatus,
       ISNULL(NULLIF(OmbudsmanComplaints, ''),'{U}'      ) AS OmbudsmanComplaints,
       CreationDate,
       JoinDate,
       ISNULL(NULLIF(PrivacyPreferredStatus, ''),'{Unknown}') AS PrivacyPreferredStatus,
       -- factActivity
       ISNULL(factActivity.ActivityNotes, '{Unknown}') AS LatestActivityNotes,
       Meta_IsCurrent,
       Meta_EffectiveStartDate,
       Meta_EffectiveEndDate
FROM   DW_Dimensional.DW.DimCustomer
LEFT   JOIN factActivity ON factActivity.CustomerKey = DimCustomer.CustomerKey AND factActivity.recency = 1;