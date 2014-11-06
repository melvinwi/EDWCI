USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [transform].[DimActivityType]
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

	;WITH marketing AS (SELECT crm_activity_type.seq_act_type_id, row_number() OVER (PARTITION BY crm_activity_type.act_type_code ORDER BY crm_activity_type.seq_act_type_id DESC) AS recency FROM DW_Staging.orion.crm_activity_type INNER JOIN DW_Staging.csv.csv_DimMarketingOffer ON csv_DimMarketingOffer.MarketingOfferShortDesc = crm_activity_type.act_type_code WHERE crm_activity_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR csv_DimMarketingOffer.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID), complaint AS (SELECT crm_activity_type.seq_act_type_id FROM DW_Staging.orion.crm_activity_type INNER JOIN DW_Staging.orion.crm_activity_category ON crm_activity_category.seq_act_category_id = crm_activity_type.seq_act_category_id AND crm_activity_category.act_cat_code IN ('COMPLAINT_A', 'COMPLAINT_C', 'COMPL_CN') WHERE crm_activity_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR crm_activity_category.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID), enquiry AS (SELECT DISTINCT crm_activity.seq_act_type_id FROM DW_Staging.orion.crm_activity INNER JOIN DW_Staging.orion.crm_activity_source ON crm_activity_source.seq_act_source_id = crm_activity.seq_act_source_id AND crm_activity_source.act_source_code IN ('EMAIL IN', 'FAX IN', 'LETTER IN', 'LIVECHAT', 'PHONE IN') WHERE crm_activity.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR crm_activity_source.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID), retention AS (SELECT crm_activity_type.seq_act_type_id FROM DW_Staging.orion.crm_activity_type WHERE crm_activity_type.seq_act_type_id IN (1010, 1057, 2122, 1286, 1647, 1648, 1904, 2127, 1913, 2647, 2648, 1043, 1287, 1758, 1759, 1760, 1761, 1762, 1763, 1902, 2128, 2123, 1903, 2130, 2156, 2158, 2512) AND crm_activity_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID)
	INSERT INTO temp.DimActivityType (
		DimActivityType.ActivityTypeKey,
		DimActivityType.ActivityTypeCode,
		DimActivityType.ActivityTypeDesc)
	  SELECT
		CAST( crm_activity_type.seq_act_type_id AS int),
		CAST( crm_activity_type.act_type_code AS nvarchar(20)),
		CAST( crm_activity_type.act_type_desc AS nvarchar(100))
	  FROM DW_Staging.orion.crm_activity_type LEFT JOIN marketing ON marketing.seq_act_type_id = crm_activity_type.seq_act_type_id AND marketing.recency = 1 LEFT JOIN complaint ON complaint.seq_act_type_id = crm_activity_type.seq_act_type_id LEFT JOIN enquiry ON enquiry.seq_act_type_id = crm_activity_type.seq_act_type_id LEFT JOIN retention ON retention.seq_act_type_id = crm_activity_type.seq_act_type_id WHERE (marketing.seq_act_type_id IS NOT NULL OR complaint.seq_act_type_id IS NOT NULL OR enquiry.seq_act_type_id IS NOT NULL OR retention.seq_act_type_id IS NOT NULL);

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;
GO
