USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Views].[vActivity]
AS
WITH   dimMarketingCampaign
       AS (SELECT DimActivityType.ActivityTypeKey,
                  DimMarketingCampaign.MarketingCampaignShortDesc,
                  DimMarketingCampaign.MarketingCampaignStartDate,
                  ROW_NUMBER() OVER (PARTITION BY DimActivityType.ActivityTypeKey ORDER BY DimMarketingCampaign.MarketingCampaignStartDate DESC) AS recency
           FROM   DW_Dimensional.DW.DimActivityType
           INNER  JOIN DW_Dimensional.DW.FactMarketingCampaignActivity ON FactMarketingCampaignActivity.ActivityTypeId = DimActivityType.ActivityTypeId
           INNER  JOIN DW_Dimensional.DW.DimMarketingCampaign ON DimMarketingCampaign.MarketingCampaignId = FactMarketingCampaignActivity.MarketingCampaignId),
       dimAccount
       AS (SELECT DimCustomer.CustomerKey,
                  DimAccount.AccountKey,
                  DimAccount.AccountClosedDate,
                  ROW_NUMBER() OVER (PARTITION BY DimCustomer.CustomerKey ORDER BY DimAccount.Meta_EffectiveStartDate DESC) AS recency
           FROM   DW_Dimensional.DW.DimCustomer
           INNER  JOIN DW_Dimensional.DW.FactCustomerAccount ON FactCustomerAccount.CustomerId = DimCustomer.CustomerId
           INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactCustomerAccount.AccountId),
       factContract
       AS (SELECT DimAccount.AccountKey,
                  MAX(FactContract.ContractStartDateId) AS MaxContractStartDateId
           FROM   DW_Dimensional.DW.DimAccount
           INNER  JOIN DW_Dimensional.DW.FactContract ON DimAccount.AccountId = FactContract.AccountId
           GROUP  BY DimAccount.AccountKey)
SELECT -- DimCustomer
       DimCustomerCurrent.CustomerCode,
       DimCustomerCurrent.Title,
       DimCustomerCurrent.FirstName,
       DimCustomerCurrent.MiddleInitial,
       DimCustomerCurrent.LastName,
       DimCustomerCurrent.PartyName,
       DimCustomerCurrent.PostalAddressLine1,
       DimCustomerCurrent.PostalSuburb,
       DimCustomerCurrent.PostalPostcode,
       DimCustomerCurrent.PostalState,
       DimCustomerCurrent.PostalStateAsProvided,
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
           WHEN DATEDIFF(DAY, GETDATE(), DATEADD(YEAR, DATEDIFF (YEAR, DimCustomerCurrent.DateOfBirth, GETDATE()), DimCustomerCurrent.DateOfBirth)) > 0 THEN 1
           ELSE 0 -- Subtract birthdays that are yet to occur in the current year
         END AS Age,
       DimCustomerCurrent.CustomerType,
       DimCustomerCurrent.CustomerStatus,
       DimCustomerCurrent.OmbudsmanComplaints,
       DimCustomerCurrent.CreationDate,
       DimCustomerCurrent.JoinDate,
       DimCustomerCurrent.PrivacyPreferredStatus,
       DimCustomerCurrent.InferredGender,
       -- DimRepresentative
       DimRepresentativeCurrent.RepresentativePartyName,
       -- DimOrganisation
       DimOrganisationCurrent.OrganisationName,
       DimOrganisationCurrent.Level1Name,
       DimOrganisationCurrent.Level2Name,
       DimOrganisationCurrent.Level3Name,
       DimOrganisationCurrent.Level4Name,
       -- DimActivityType
       DimActivityTypeCurrent.ActivityTypeCode,
       DimActivityTypeCurrent.ActivityTypeDesc,
       DimActivityTypeCurrent.ActivityCategory,
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
LEFT   JOIN DW_Dimensional.DW.DimCustomer AS DimCustomerCurrent ON DimCustomerCurrent.CustomerKey = DimCustomer.CustomerKey AND DimCustomerCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimRepresentative ON DimRepresentative.RepresentativeId = FactActivity.RepresentativeId
LEFT   JOIN DW_Dimensional.DW.DimRepresentative AS DimRepresentativeCurrent ON DimRepresentativeCurrent.RepresentativeKey = DimRepresentative.RepresentativeKey AND DimRepresentative.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimOrganisation ON DimOrganisation.OrganisationId = FactActivity.OrganisationId
LEFT   JOIN DW_Dimensional.DW.DimOrganisation AS DimOrganisationCurrent ON DimOrganisationCurrent.OrganisationKey = DimOrganisation.OrganisationKey AND DimOrganisation.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimActivityType ON DimActivityType.ActivityTypeId = FactActivity.ActivityTypeId
LEFT   JOIN DW_Dimensional.DW.DimActivityType AS DimActivityTypeCurrent ON DimActivityTypeCurrent.ActivityTypeKey = DimActivityType.ActivityTypeKey AND DimActivityTypeCurrent.Meta_IsCurrent = 1
LEFT   JOIN dimMarketingCampaign ON dimMarketingCampaign.ActivityTypeKey = DimActivityTypeCurrent.ActivityTypeKey AND dimMarketingCampaign.recency = 1
LEFT   JOIN dimAccount ON dimAccount.CustomerKey = DimCustomerCurrent.CustomerKey AND dimAccount.recency = 1
LEFT   JOIN factContract ON factContract.AccountKey = dimAccount.AccountKey AND CONVERT(DATE, CAST(factContract.MaxContractStartDateId AS NCHAR(8)), 120) >= dimMarketingCampaign.MarketingCampaignStartDate;


GO
