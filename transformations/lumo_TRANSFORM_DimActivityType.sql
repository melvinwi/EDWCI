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

	INSERT INTO lumo.DimActivityType (
		DimActivityType.ActivityTypeKey,
		DimActivityType.ActivityTypeCode,
		DimActivityType.ActivityTypeDesc,
		DimActivityType.ActivityCategory)
	  SELECT
		CAST( crm_activity_type.seq_act_type_id AS int),
		CAST( crm_activity_type.act_type_code AS nvarchar(20)),
		CAST( crm_activity_type.act_type_desc AS nvarchar(100)),
		CAST( crm_activity_category.act_cat_desc AS nvarchar(100))
	  FROM /* Staging */ lumo.crm_activity_type LEFT JOIN /* Staging */ lumo.crm_activity_category ON crm_activity_category.seq_act_category_id = crm_activity_type.seq_act_category_id WHERE crm_activity_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR crm_activity_category.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;