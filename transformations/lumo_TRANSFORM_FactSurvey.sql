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

	;WITH _CX_Monitor AS ( SELECT CX_Monitor.QuestionDescription  ,CX_Monitor.QuestionKey ,CASE WHEN(CASE WHEN (CHARINDEX('#', CX_Monitor.QuestionKey)) = (LEN(CX_Monitor.QuestionKey)) THEN 1 ELSE 0 END) = 0  THEN REPLACE(SUBSTRING(CX_Monitor.QuestionKey, CHARINDEX(',', CX_Monitor.QuestionKey), LEN(CX_Monitor.QuestionKey)), ',', '')  ELSE CX_Monitor.QuestionKey END AS QuestionId ,CX_Monitor.RespondentId  ,CX_Monitor.Data,CX_Monitor.FileDate  ,CX_Monitor.Meta_Insert_TaskExecutionInstanceId  ,CX_Monitor.Meta_LatestUpdate_TaskExecutionInstanceId ,SUBSTRING(CX_Monitor.QuestionDescription,CHARINDEX(' ',CX_Monitor.QuestionDescription)+1,LEN(CX_Monitor.QuestionDescription)) AS QuestionRef   FROM lumo.CX_Monitor  WHERE CHARINDEX('Q',CX_Monitor.QuestionDescription) > 0  AND  CHARINDEX('x.',CX_Monitor.QuestionDescription) = 0  ) , _CX_Monitor_Cust AS ( SELECT CX_Monitor.QuestionDescription  ,CX_Monitor.QuestionKey  ,CX_Monitor.RespondentId  ,CX_Monitor.Data  ,CX_Monitor.FileDate,CX_Monitor.Meta_Insert_TaskExecutionInstanceId  ,CX_Monitor.Meta_LatestUpdate_TaskExecutionInstanceId  FROM lumo.CX_Monitor   WHERE CX_Monitor.QuestionKey = 'PARTY' )  , _DimCustomer AS ( SELECT DimCustomer.CustomerId ,DimCustomer.CustomerCode  FROM lumo.DimCustomer   WHERE DimCustomer.Meta_IsCurrent = 1 )  , _Question_Id AS ( SELECT DimQuestion.QuestionId   ,DimQuestion.QuestionKey  FROM lumo.DimQuestion )
	INSERT INTO lumo.FactSurvey (
		FactSurvey.CustomerId,
		FactSurvey.QuestionId,
		FactSurvey.ResponseDateId,
		FactSurvey.Response,
		FactSurvey.RespondentKey,
		FactSurvey.ResponseKey)
	  SELECT
		_DimCustomer.CustomerId,
		_Question_Id.QuestionId,
		/* _Question_Id.QuestionId */ CONVERT(NCHAR(8),ISNULL(_CX_Monitor.FileDate, '99991231'),112),
		COALESCE( _CX_MonitorCodes.Label ,_CX_Monitor.Data) ,
		_CX_Monitor.RespondentId,
		CAST((REPLACE(SUBSTRING( _CX_Monitor.QuestionKey , CHARINDEX(',', _CX_Monitor.QuestionKey), LEN(_CX_Monitor.QuestionKey)), '#', ''))AS VARCHAR(MAX))
  + '' + CAST((REPLACE(SUBSTRING(_CX_Monitor.QuestionKey, CHARINDEX('#', _CX_Monitor.QuestionKey), LEN(_CX_Monitor.QuestionKey)), '#', ''))AS VARCHAR(MAX))
  + '' + CAST(_CX_Monitor.RespondentId AS VARCHAR(MAX))
	  FROM  lumo.CX_MonitorCodes  _CX_MonitorCodes LEFT JOIN _CX_Monitor       ON _CX_MonitorCodes.QuestionKey = _CX_Monitor.QuestionId             AND _CX_MonitorCodes.Value = _CX_Monitor.Data LEFT JOIN _CX_Monitor_Cust     ON _CX_Monitor.RespondentId = _CX_Monitor_Cust.RespondentId LEFT JOIN _Question_Id      ON _CX_Monitor.QuestionRef = _Question_Id.QuestionKey LEFT JOIN _DimCustomer      ON _CX_Monitor_Cust.Data = _DimCustomer.CustomerCode  WHERE  _CX_Monitor.QuestionId IS NOT NULL;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;