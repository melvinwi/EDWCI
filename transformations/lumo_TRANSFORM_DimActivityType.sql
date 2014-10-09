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
		DimActivityType.ActivityTypeDesc)
	  SELECT
		CAST( crm_activity_type.seq_act_type_id AS int),
		CAST( crm_activity_type.act_type_code AS nvarchar(20)),
		CAST( crm_activity_type.act_type_desc AS nvarchar(100))
	  FROM lumo.crm_activity_type WHERE (act_type_desc LIKE '%disconnection notice%' OR  act_type_desc LIKE '%complaint%' OR  act_type_desc LIKE '%enquiry%') AND (crm_activity_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID)
;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;