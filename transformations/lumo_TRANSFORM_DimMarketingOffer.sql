CREATE PROCEDURE lumo.TRANSFORM_DimMarketingOffer
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

	INSERT INTO lumo.DimMarketingOffer (
		DimMarketingOffer.MarketingOfferKey,
		DimMarketingOffer.MarketingOfferShortDesc,
		DimMarketingOffer.MarketingOfferDesc)
	  SELECT
		csv_DimMarketingOffer.MarketingOfferKey,
		csv_DimMarketingOffer.MarketingOfferShortDesc,
		csv_DimMarketingOffer.MarketingOfferDesc
	  FROM lumo.csv_DimMarketingOffer;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;