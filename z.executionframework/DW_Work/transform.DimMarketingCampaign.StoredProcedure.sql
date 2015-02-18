USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [transform].[DimMarketingCampaign]
@TaskExecutionInstanceID INT
,@LatestSuccessfulTaskExecutionInstanceID INT
AS
BEGIN

--Get LatestSuccessfulTaskExecutionInstanceID
IF  @LatestSuccessfulTaskExecutionInstanceID IS NULL
BEGIN
EXEC DW_Utility.config.GetLatestSuccessfulTaskExecutionInstanceID
@TaskExecutionInstanceID = @TaskExecutionInstanceID
, @LatestSuccessfulTaskExecutionInstanceID  = @LatestSuccessfulTaskExecutionInstanceID OUTPUT
END
--/

	INSERT INTO temp.DimMarketingCampaign (
		DimMarketingCampaign.MarketingCampaignKey,
		DimMarketingCampaign.MarketingCampaignShortDesc,
		DimMarketingCampaign.MarketingCampaignDesc,
		DimMarketingCampaign.MarketingCampaignStartDate,
		DimMarketingCampaign.MarketingCampaignEndDate,
		DimMarketingCampaign.ContactType,
		DimMarketingCampaign.PrivacyAssessmentKey)
	  SELECT
		csv_DimMarketingCampaign.MarketingCampaignKey,
		csv_DimMarketingCampaign.MarketingCampaignShortDesc,
		csv_DimMarketingCampaign.MarketingCampaignDesc,
		csv_DimMarketingCampaign.MarketingCampaignStartDate,
		csv_DimMarketingCampaign.MarketingCampaignEndDate,
		csv_DimMarketingCampaign.ContactType,
		csv_DimMarketingCampaign.PrivacyAssessmentKey
	  FROM DW_Staging.csv.csv_DimMarketingCampaign;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;

GO
USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [transform].[DimMarketingCampaign]
@TaskExecutionInstanceID INT
,@LatestSuccessfulTaskExecutionInstanceID INT
AS
BEGIN

--Get LatestSuccessfulTaskExecutionInstanceID
IF  @LatestSuccessfulTaskExecutionInstanceID IS NULL
BEGIN
EXEC DW_Utility.config.GetLatestSuccessfulTaskExecutionInstanceID
@TaskExecutionInstanceID = @TaskExecutionInstanceID
, @LatestSuccessfulTaskExecutionInstanceID  = @LatestSuccessfulTaskExecutionInstanceID OUTPUT
END
--/

	INSERT INTO temp.DimMarketingCampaign (
		DimMarketingCampaign.MarketingCampaignKey,
		DimMarketingCampaign.MarketingCampaignShortDesc,
		DimMarketingCampaign.MarketingCampaignDesc,
		DimMarketingCampaign.MarketingCampaignStartDate,
		DimMarketingCampaign.MarketingCampaignEndDate,
		DimMarketingCampaign.ContactType,
		DimMarketingCampaign.PrivacyAssessmentKey)
	  SELECT
		DimMarketingCampaign.MarketingCampaignKey,
		DimMarketingCampaign.MarketingCampaignShortDesc,
		DimMarketingCampaign.MarketingCampaignDesc,
		DimMarketingCampaign.MarketingCampaignStartDate,
		DimMarketingCampaign.MarketingCampaignEndDate,
		DimMarketingCampaign.ContactType,
		DimMarketingCampaign.PrivacyAssessmentKey
	  FROM DW_Staging.csv.DimMarketingCampaign;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;

GO
