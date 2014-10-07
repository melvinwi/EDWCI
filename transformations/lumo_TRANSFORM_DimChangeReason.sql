CREATE PROCEDURE lumo.TRANSFORM_DimChangeReason
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

	INSERT INTO lumo.DimChangeReason (
		DimChangeReason.ChangeReasonKey,
		DimChangeReason.ChangeReasonCode,
		DimChangeReason.ChangeReasonDesc)
	  SELECT
		nem_change_reason.change_reason_id,
		nem_change_reason.change_reason_code,
		nem_change_reason.change_reason_desc
	  FROM /* Staging */ lumo.nem_change_reason WHERE nem_change_reason.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;