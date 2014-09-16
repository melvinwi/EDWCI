CREATE PROCEDURE lumo.TRANSFORM_DimMarketingCampaign
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

	INSERT INTO lumo.DimMarketingCampaign (
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
	  FROM lumo.csv_DimMarketingCampaign;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;