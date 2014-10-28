USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Views].[vActivity]
AS
WITH   dimMarketingCampaign
       AS (SELECT FactMarketingCampaignActivity.ActivityTypeId,
                  DimMarketingCampaign.MarketingCampaignShortDesc,
                  DimMarketingCampaign.MarketingCampaignStartDate,
                  row_number() OVER (PARTITION BY FactMarketingCampaignActivity.ActivityTypeId ORDER BY DimMarketingCampaign.MarketingCampaignStartDate DESC) AS recency
           FROM   DW_Dimensional.DW.FactMarketingCampaignActivity
           INNER  JOIN DW_Dimensional.DW.DimMarketingCampaign ON DimMarketingCampaign.MarketingCampaignId = FactMarketingCampaignActivity.MarketingCampaignId),
       dimAccount
       AS (SELECT FactCustomerAccount.CustomerId,
                  DimAccount.AccountKey,
                  DimAccount.AccountClosedDate,
                  row_number() OVER (PARTITION BY FactCustomerAccount.CustomerId ORDER BY DimAccount.Meta_EffectiveStartDate DESC) AS recency
           FROM   DW_Dimensional.DW.FactCustomerAccount
           INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactCustomerAccount.AccountId),
       factContract
       AS (SELECT DimAccount.AccountKey,
                  MAX(FactContract.ContractStartDateId) AS MaxContractStartDateId
           FROM   DW_Dimensional.DW.FactContract
           INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactContract.AccountId
           GROUP  BY DimAccount.AccountKey)
SELECT -- DimCustomer
       DimCustomer.CustomerCode,
       ISNULL(NULLIF(DimCustomer.Title, ''), '{U}') AS Title,
       ISNULL(NULLIF(DimCustomer.FirstName, ''), '{Unknown}') AS FirstName,
       ISNULL(NULLIF(DimCustomer.MiddleInitial, ''), '{Unknown}') AS MiddleInitial,
       ISNULL(NULLIF(DimCustomer.LastName, ''), '{Unknown}') AS LastName,
       ISNULL(NULLIF(DimCustomer.PartyName, ''), '{Unknown}') AS PartyName,
       ISNULL(NULLIF(DimCustomer.ResidentialAddressLine1, ''), '{Unknown}') AS ResidentialAddressLine1,
       ISNULL(NULLIF(DimCustomer.ResidentialSuburb, ''), '{Unknown}') AS ResidentialSuburb,
       ISNULL(NULLIF(DimCustomer.ResidentialPostcode, ''), '{Un}') AS ResidentialPostcode,
       ISNULL(NULLIF(DimCustomer.ResidentialState, ''), '{U}') AS ResidentialState,
       ISNULL(NULLIF(DimCustomer.ResidentialStateAsProvided, ''), '{U}') AS ResidentialStateAsProvided,
       ISNULL(NULLIF(DimCustomer.PrimaryPhone, ''), '{Unknown}') AS PrimaryPhone,
       ISNULL(NULLIF(DimCustomer.PrimaryPhoneType, ''),'{Unk}') AS PrimaryPhoneType,
       ISNULL(NULLIF(DimCustomer.SecondaryPhone, ''), '{Unknown}') AS SecondaryPhone,
       ISNULL(NULLIF(DimCustomer.SecondaryPhoneType, ''),'{Unk}') AS SecondaryPhoneType,
       ISNULL(NULLIF(DimCustomer.MobilePhone, ''), '{Unknown}') AS MobilePhone,
       ISNULL(NULLIF(DimCustomer.Email, ''), '{Unknown}') AS Email,
       DimCustomer.DateOfBirth,
       DATEDIFF(YEAR, DimCustomer.DateOfBirth, GETDATE()) AS Age,
       ISNULL(NULLIF(DimCustomer.CustomerType, ''), '{Unknown}') AS CustomerType,
       ISNULL(NULLIF(DimCustomer.CustomerStatus, ''),'{Unk}') AS CustomerStatus,
       ISNULL(NULLIF(DimCustomer.OmbudsmanComplaints, ''),'{U}') AS OmbudsmanComplaints,
       DimCustomer.CreationDate,
       DimCustomer.JoinDate,
       ISNULL(NULLIF(DimCustomer.PrivacyPreferredStatus, ''),'{Unknown}') AS PrivacyPreferredStatus,
       -- DimRepresentative
       ISNULL(NULLIF(DimRepresentative.RepresentativePartyName, ''),'{Unknown}') AS RepresentativePartyName,
       -- DimOrganisation
       ISNULL(NULLIF(DimOrganisation.OrganisationName, ''),'{Unknown}') AS OrganisationName,
       ISNULL(NULLIF(DimOrganisation.Level1Name, ''),'{Unknown}') AS Level1Name,
       ISNULL(NULLIF(DimOrganisation.Level2Name, ''),'{Unknown}') AS Level2Name,
       ISNULL(NULLIF(DimOrganisation.Level3Name, ''),'{Unknown}') AS Level3Name,
       ISNULL(NULLIF(DimOrganisation.Level4Name, ''),'{Unknown}') AS Level4Name,
       -- DimActivityType
       ISNULL(NULLIF(DimActivityType.ActivityTypeCode, ''),'{Unknown}') AS ActivityTypeCode,
       ISNULL(NULLIF(DimActivityType.ActivityTypeDesc, ''),'{Unknown}') AS ActivityTypeDesc,
       -- FactActivity
       CONVERT(DATE, CAST(FactActivity.ActivityDateId AS NCHAR(8)), 112) AS ActivityDate,
       FactActivity.ActivityTime,
       ISNULL(NULLIF(FactActivity.ActivityCategory, ''), '{Unknown}') AS ActivityCategory,
       ISNULL(NULLIF(FactActivity.ActivityNotes, ''), '{Unknown}') AS ActivityNotes,
       -- DimCampaign
       ISNULL(NULLIF(dimMarketingCampaign.MarketingCampaignShortDesc, ''), '{Unknown}') AS MarketingCampaignShortDesc,
       -- DimAccount
       dimAccount.AccountClosedDate,
       -- FactContract
       CONVERT(DATE, CAST(factContract.MaxContractStartDateId AS NCHAR(8)), 120) AS RecontractDate
FROM   DW_Dimensional.DW.FactActivity
INNER  JOIN DW_Dimensional.DW.DimCustomer ON DimCustomer.CustomerId = FactActivity.CustomerId
LEFT   JOIN DW_Dimensional.DW.DimRepresentative ON DimRepresentative.RepresentativeId = FactActivity.RepresentativeId
LEFT   JOIN DW_Dimensional.DW.DimOrganisation ON DimOrganisation.OrganisationId = FactActivity.OrganisationId
LEFT   JOIN DW_Dimensional.DW.DimActivityType ON DimActivityType.ActivityTypeId = FactActivity.ActivityTypeId
LEFT   JOIN dimMarketingCampaign ON dimMarketingCampaign.ActivityTypeId = DW_Dimensional.DW.DimActivityType.ActivityTypeId AND dimMarketingCampaign.recency = 1
LEFT   JOIN dimAccount ON dimAccount.CustomerId = FactActivity.CustomerId AND dimAccount.recency = 1
LEFT   JOIN factContract ON factContract.AccountKey = dimAccount.AccountKey AND CONVERT(DATE, CAST(factContract.MaxContractStartDateId AS NCHAR(8)), 120) >= dimMarketingCampaign.MarketingCampaignStartDate;

GO
