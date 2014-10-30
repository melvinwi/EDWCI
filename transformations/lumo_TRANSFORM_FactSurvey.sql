CREATE PROCEDURE lumo.TRANSFORM_FactSurvey
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

	;WITH _CX_Monitor AS ( SELECT     CX_Monitor.QuestionDescription      ,CX_Monitor.QuestionKey     ,CASE WHEN(CASE WHEN (CHARINDEX('#', CX_Monitor.QuestionKey)) = (LEN(CX_Monitor.QuestionKey)) THEN 1 ELSE 0 END) = 0        THEN REPLACE(SUBSTRING(CX_Monitor.QuestionKey, CHARINDEX(',', CX_Monitor.QuestionKey), LEN(CX_Monitor.QuestionKey)), ',', '')        ELSE CX_Monitor.QuestionKey END AS QuestionId     ,CX_Monitor.RespondentId      ,CX_Monitor.Data      ,CX_Monitor.Meta_Insert_TaskExecutionInstanceId      ,CX_Monitor.Meta_LatestUpdate_TaskExecutionInstanceId     ,SUBSTRING(CX_Monitor.QuestionDescription,CHARINDEX(' ',CX_Monitor.QuestionDescription)+1,LEN(CX_Monitor.QuestionDescription)) AS QuestionRef       FROM [Schema].CX_Monitor       WHERE 1=1     AND  CHARINDEX('Q',CX_Monitor.QuestionDescription) > 0      AND  CHARINDEX('x.',CX_Monitor.QuestionDescription) = 0  ) , _CX_Monitor_Cust AS ( SELECT     CX_Monitor.QuestionDescription      ,CX_Monitor.QuestionKey      ,CX_Monitor.RespondentId      ,CX_Monitor.Data      ,CX_Monitor.Meta_Insert_TaskExecutionInstanceId      ,CX_Monitor.Meta_LatestUpdate_TaskExecutionInstanceId      FROM [Schema].CX_Monitor       WHERE 1=1     AND  CX_Monitor.QuestionKey = 'PARTY' )
	INSERT INTO lumo.FactSurvey (
		FactSurvey.CustomerId,
		FactSurvey.QuestionId,
		FactSurvey.ResponseDateId,
		FactSurvey.Response,
		FactSurvey.RespondentKey,
		FactSurvey.ResponseKey)
	  SELECT
		_CX_Monitor_Cust.Data,
		_CX_Monitor.QuestionRef,
		CONVERT(DATETIME,CONVERT(CHAR,GETDATE(),103),103) ,
		_CX_MonitorCodes.Label,
		_CX_Monitor.RespondentId,
		CAST((REPLACE(SUBSTRING( _CX_Monitor.QuestionKey , CHARINDEX(',', _CX_Monitor.QuestionKey), LEN(_CX_Monitor.QuestionKey)), '#', ''))AS VARCHAR(MAX))
  + '' + CAST((REPLACE(SUBSTRING(_CX_Monitor.QuestionKey, CHARINDEX('#', _CX_Monitor.QuestionKey), LEN(_CX_Monitor.QuestionKey)), '#', ''))AS VARCHAR(MAX))
  + '' + CAST(_CX_Monitor.RespondentId AS VARCHAR(MAX))
	  FROM [Schema].CX_MonitorCodes  _CX_MonitorCodes LEFT JOIN _CX_Monitor ON _CX_MonitorCodes.QuestionKey = _CX_Monitor.QuestionId   AND _CX_MonitorCodes.Value = _CX_Monitor.Data  LEFT JOIN _CX_Monitor_Cust ON _CX_Monitor.RespondentId = _CX_Monitor_Cust.RespondentId  WHERE 1=1  AND _CX_Monitor.QuestionId IS NOT NULL;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;