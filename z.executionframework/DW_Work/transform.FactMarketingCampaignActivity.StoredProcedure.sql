USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [transform].[FactMarketingCampaignActivity]
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

	;WITH factMarketingCampaignActivity AS (SELECT DISTINCT csv_FactMarketingCampaignActivity.MarketingCampaignKey, csv_FactMarketingCampaignActivity.MarketingOfferKey FROM DW_Staging.csv.csv_FactMarketingCampaignActivity)
	INSERT INTO temp.FactMarketingCampaignActivity (
		FactMarketingCampaignActivity.MarketingCampaignId,
		FactMarketingCampaignActivity.ActivityTypeId,
		FactMarketingCampaignActivity.MarketingCampaignActivityKey)
	  SELECT
		_DimMarketingCampaign.MarketingCampaignId,
		_DimActivityType.ActivityTypeId,
		CAST( _factMarketingCampaignActivity.MarketingCampaignKey AS NVARCHAR(MAX)) + ' - ' + CAST(_factMarketingCampaignActivity.MarketingOfferKey AS NVARCHAR(MAX))
	  FROM factMarketingCampaignActivity AS _factMarketingCampaignActivity INNER JOIN DW_Dimensional.DW.DimMarketingCampaign AS _DimMarketingCampaign ON _DimMarketingCampaign.MarketingCampaignKey = _factMarketingCampaignActivity.MarketingCampaignKey INNER JOIN DW_Dimensional.DW.DimActivityType AS _DimActivityType ON _DimActivityType.ActivityTypeKey = _factMarketingCampaignActivity.MarketingOfferKey AND _DimActivityType.Meta_IsCurrent = 1;

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
CREATE PROCEDURE [transform].[FactMarketingCampaignActivity]
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

	;WITH factMarketingCampaignActivity AS (SELECT DISTINCT FactMarketingCampaignActivity.MarketingCampaignKey, FactMarketingCampaignActivity.MarketingOfferKey FROM DW_Staging.csv.FactMarketingCampaignActivity)
	INSERT INTO temp.FactMarketingCampaignActivity (
		FactMarketingCampaignActivity.MarketingCampaignId,
		FactMarketingCampaignActivity.ActivityTypeId,
		FactMarketingCampaignActivity.MarketingCampaignActivityKey)
	  SELECT
		_DimMarketingCampaign.MarketingCampaignId,
		_DimActivityType.ActivityTypeId,
		CAST( _factMarketingCampaignActivity.MarketingCampaignKey AS NVARCHAR(MAX)) + ' - ' + CAST(_factMarketingCampaignActivity.MarketingOfferKey AS NVARCHAR(MAX))
	  FROM factMarketingCampaignActivity AS _factMarketingCampaignActivity INNER JOIN DW_Dimensional.DW.DimMarketingCampaign AS _DimMarketingCampaign ON _DimMarketingCampaign.MarketingCampaignKey = _factMarketingCampaignActivity.MarketingCampaignKey INNER JOIN DW_Dimensional.DW.DimActivityType AS _DimActivityType ON _DimActivityType.ActivityTypeKey = _factMarketingCampaignActivity.MarketingOfferKey AND _DimActivityType.Meta_IsCurrent = 1;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;
GO
