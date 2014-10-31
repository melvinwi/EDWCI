CREATE PROCEDURE lumo.TRANSFORM_DimQuestion
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

	INSERT INTO lumo.DimQuestion (
		DimQuestion.QuestionKey,
		DimQuestion.Question)
	  SELECT
		DISTINCT SUBSTRING( _CX_Monitor.QuestionDescription ,CHARINDEX(' ',_CX_Monitor.QuestionDescription)+1,LEN(_CX_Monitor.QuestionDescription)),
		SUBSTRING( _CX_Monitor.QuestionDescription ,CHARINDEX(' ',_CX_Monitor.QuestionDescription)+1,LEN(_CX_Monitor.QuestionDescription))
	  FROM lumo.CX_Monitor AS _CX_Monitor WHERE CHARINDEX('Q',_CX_Monitor.QuestionDescription) > 0 AND CHARINDEX('x.',_CX_Monitor.QuestionDescription) = 0 AND _CX_Monitor.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;