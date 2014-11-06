USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [transform].[DimMarketingOffer]
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

	INSERT INTO temp.DimMarketingOffer (
		DimMarketingOffer.MarketingOfferKey,
		DimMarketingOffer.MarketingOfferShortDesc,
		DimMarketingOffer.MarketingOfferDesc)
	  SELECT
		csv_DimMarketingOffer.MarketingOfferKey,
		csv_DimMarketingOffer.MarketingOfferShortDesc,
		csv_DimMarketingOffer.MarketingOfferDesc
	  FROM DW_Staging.csv.csv_DimMarketingOffer;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;

GO
