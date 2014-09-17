CREATE PROCEDURE lumo.TRANSFORM_FactMarketingCampaignActivity
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

	INSERT INTO lumo.FactMarketingCampaignActivity (
		FactMarketingCampaignActivity.MarketingCampaignId,
		FactMarketingCampaignActivity.MarketingOfferId,
		FactMarketingCampaignActivity.CustomerId,
		FactMarketingCampaignActivity.ActivityDateId,
		FactMarketingCampaignActivity.ActivityTime,
		FactMarketingCampaignActivity.ActivityType,
		FactMarketingCampaignActivity.MarketingCampaignActivityKey)
	  SELECT
		csv_FactMarketingCampaignActivity.MarketingCampaignId,
		csv_FactMarketingCampaignActivity.MarketingOfferId,
		_DimCustomer.CustomerId,
		REPLACE( csv_FactMarketingCampaignActivity.ActivityDateId , '-', ''),
		csv_FactMarketingCampaignActivity.ActivityTime,
		csv_FactMarketingCampaignActivity.ActivityType,
		CAST(CONCAT( csv_FactMarketingCampaignActivity.MarketingCampaignActivityKey, '-',csv_FactMarketingCampaignActivity.CustomerKey, '-',csv_FactMarketingCampaignActivity.ActivityDateId, '-', csv_FactMarketingCampaignActivity.ActivityTime ) AS nvarchar(255))
	  FROM lumo.csv_FactMarketingCampaignActivity INNER JOIN lumo.DimCustomer as _DimCustomer ON _DimCustomer.CustomerKey = csv_FactMarketingCampaignActivity.CustomerKey AND _DimCustomer.Meta_IsCurrent = 1;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;