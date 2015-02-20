USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Views].[vActivityHistorical]
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
                  FactCustomerAccount.AccountId,
                  DimAccount.AccountClosedDate,
                  row_number() OVER (PARTITION BY FactCustomerAccount.CustomerId ORDER BY DimAccount.Meta_EffectiveStartDate DESC) AS recency
           FROM   DW_Dimensional.DW.FactCustomerAccount
           INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactCustomerAccount.AccountId),
       factContract
       AS (SELECT FactContract.AccountId,
                  MAX(FactContract.ContractStartDateId) AS MaxContractStartDateId
           FROM   DW_Dimensional.DW.FactContract
           GROUP  BY FactContract.AccountId)
SELECT -- DimCustomer
       DimCustomer.CustomerCode,
       DimCustomer.Title,
       DimCustomer.FirstName,
       DimCustomer.MiddleInitial,
       DimCustomer.LastName,
       DimCustomer.PartyName,
       DimCustomer.PostalAddressLine1,
       DimCustomer.PostalSuburb,
       DimCustomer.PostalPostcode,
       DimCustomer.PostalState,
       DimCustomer.PostalStateAsProvided,
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
           WHEN DATEDIFF(DAY, GETDATE(), DATEADD(YEAR, DATEDIFF (YEAR, DimCustomer.DateOfBirth, GETDATE()), DimCustomer.DateOfBirth)) > 0 THEN 1
           ELSE 0 -- Subtract birthdays that are yet to occur in the current year
         END AS Age,
       DimCustomer.CustomerType,
       DimCustomer.CustomerStatus,
       DimCustomer.OmbudsmanComplaints,
       DimCustomer.CreationDate,
       DimCustomer.JoinDate,
       DimCustomer.PrivacyPreferredStatus,
       DimCustomer.InferredGender,
       -- DimRepresentative
       DimRepresentative.RepresentativePartyName,
       -- DimOrganisation
       DimOrganisation.OrganisationName,
       DimOrganisation.Level1Name,
       DimOrganisation.Level2Name,
       DimOrganisation.Level3Name,
       DimOrganisation.Level4Name,
       -- DimActivityType
       DimActivityType.ActivityTypeCode,
       DimActivityType.ActivityTypeDesc,
       -- FactActivity
       CONVERT(DATETIME2, CAST(FactActivity.ActivityDateId AS NCHAR(8)) + ' ' + CAST(FactActivity.ActivityTime AS NCHAR(16))) AS ActivityDate,
       FactActivity.ActivityCommunicationMethod,
       FactActivity.ActivityNotes,
       -- DimCampaign
       dimMarketingCampaign.MarketingCampaignShortDesc,
       -- DimAccount
       dimAccount.AccountClosedDate,
       -- FactContract
       CONVERT(DATE, CAST(factContract.MaxContractStartDateId AS NCHAR(8)), 120) AS RecontractDate
FROM   DW_Dimensional.DW.FactActivity
LEFT   JOIN DW_Dimensional.DW.DimCustomer ON DimCustomer.CustomerId = FactActivity.CustomerId
LEFT   JOIN DW_Dimensional.DW.DimRepresentative ON DimRepresentative.RepresentativeId = FactActivity.RepresentativeId
LEFT   JOIN DW_Dimensional.DW.DimOrganisation ON DimOrganisation.OrganisationId = FactActivity.OrganisationId
LEFT   JOIN DW_Dimensional.DW.DimActivityType ON DimActivityType.ActivityTypeId = FactActivity.ActivityTypeId
LEFT   JOIN dimMarketingCampaign ON dimMarketingCampaign.ActivityTypeId = DimActivityType.ActivityTypeId AND dimMarketingCampaign.recency = 1
LEFT   JOIN dimAccount ON dimAccount.CustomerId = FactActivity.CustomerId AND dimAccount.recency = 1
LEFT   JOIN factContract ON factContract.AccountId = dimAccount.AccountId AND CONVERT(DATE, CAST(factContract.MaxContractStartDateId AS NCHAR(8)), 120) >= dimMarketingCampaign.MarketingCampaignStartDate;
GO
