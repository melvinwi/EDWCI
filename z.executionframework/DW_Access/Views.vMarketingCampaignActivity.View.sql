USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Views].[vMarketingCampaignActivity]
AS
SELECT --	DimMarketingCampaign
       ISNULL(NULLIF(DimMarketingCampaign.MarketingCampaignShortDesc, ''), '{Unknown}') AS MarketingCampaignShortDesc,
       ISNULL(NULLIF(DimMarketingCampaign.MarketingCampaignDesc, ''), '{Unknown}') AS MarketingCampaignDesc,
       DimMarketingCampaign.MarketingCampaignStartDate,
       DimMarketingCampaign.MarketingCampaignEndDate,
       ISNULL(NULLIF(DimMarketingCampaign.ContactType, ''), '{Unknown}') AS ContactType,
       ISNULL(NULLIF(DimMarketingCampaign.PrivacyAssessmentKey, ''), '{Unknown}') AS PrivacyAssessmentKey,
       -- DimActivityType
       ISNULL(NULLIF(DimActivityType.ActivityTypeCode, ''), '{Unknown}') AS MarketingOfferShortDesc,
       ISNULL(NULLIF(DimActivityType.ActivityTypeDesc, ''), '{Unknown}') AS MarketingOfferDesc
FROM   DW_Dimensional.DW.FactMarketingCampaignActivity
INNER  JOIN DW_Dimensional.DW.DimMarketingCampaign ON DimMarketingCampaign.MarketingCampaignId = FactMarketingCampaignActivity.MarketingCampaignId
INNER  JOIN DW_Dimensional.DW.DimActivityType ON DimActivityType.ActivityTypeId = FactMarketingCampaignActivity.ActivityTypeId

GO
