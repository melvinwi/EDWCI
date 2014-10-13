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

	;WITH Complaints AS  (  SELECT [seq_act_type_id], [act_type_Code], [act_type_desc] FROM lumo.crm_activity_type WHERE seq_act_category_id IN (7,33,59) AND Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID) , Enquiries AS (  SELECT  _ca.[seq_act_type_id], _ca.[act_type_Code], _ca.[act_type_desc]  FROM lumo.[crm_activity_type]  _ca  JOIN (SELECT DISTINCT    seq_act_type_id    FROM lumo.[crm_activity]    WHERE 1=1    AND  seq_act_source_id IN(3,6,8,13,22)         ) _crm_activity    ON _ca.[seq_act_type_id] = _crm_activity.[seq_act_type_id]      WHERE 1=1  AND Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID   ) ,DisconnectionNotice AS (    SELECT _ca.[seq_act_type_id], _ca.[act_type_Code], _ca.[act_type_desc]   FROM lumo.[crm_activity_type] _ca   JOIN (SELECT DISTINCT     seq_act_type_id     FROM lumo.[ar_treatment_detail]      WHERE  1=1     AND   treat_det_id IN (3,4,5,6)      ) _crm_activity    ON _ca.[seq_act_type_id] = _crm_activity.[seq_act_type_id]   WHERE 1=1   AND Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID   )
	INSERT INTO lumo.DimActivityType (
		DimActivityType.ActivityTypeKey,
		DimActivityType.ActivityTypeCode,
		DimActivityType.ActivityTypeDesc)
	  SELECT
		CAST( _ActivityType.seq_act_type_id AS int),
		CAST( _ActivityType.act_type_code AS nvarchar(20)),
		CAST( _ActivityType.act_type_desc AS nvarchar(100))
	  FROM (SELECT * FROM Complaints UNION SELECT * FROM Enquiries UNION SELECT * FROM DisconnectionNotice) _ActivityType;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;