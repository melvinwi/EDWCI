CREATE PROCEDURE lumo.TRANSFORM_DimActivityType
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

	;WITH crmActivityType AS (SELECT crm_activity_type.act_type_code, crm_activity_type.act_type_desc, row_number() OVER (PARTITION BY crm_activity_type.act_type_code ORDER BY crm_activity_type.seq_act_type_id DESC) AS recency FROM /* Staging */ lumo.crm_activity_type)
	INSERT INTO lumo.DimActivityType (
		DimActivityType.ActivityTypeKey,
		DimActivityType.ActivityTypeCode,
		DimActivityType.ActivityTypeDesc)
	  SELECT
		csv_DimMarketingOffer.MarketingOfferKey,
		csv_DimMarketingOffer.MarketingOfferShortDesc,
		COALESCE( _crmActivityType.act_type_desc , csv_DimMarketingOffer.MarketingOfferDesc)
	  FROM /* Staging */ lumo.csv_DimMarketingOffer LEFT OUTER JOIN crmActivityType AS _crmActivityType ON _crmActivityType.act_type_code = csv_DimMarketingOffer.MarketingOfferShortDesc AND _crmActivityType.recency = 1;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;