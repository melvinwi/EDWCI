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

	;WITH _CX_Monitor AS ( SELECT  _CX_Monitor.QuestionDescription  ,_CX_Monitor.QuestionKey ,CASE WHEN (LEFT(_CX_Monitor.QuestionKey, CHARINDEX('#', _CX_Monitor.QuestionKey, 0))) = ''  THEN (LEFT(_CX_Monitor.QuestionKey, CHARINDEX('x', _CX_Monitor.QuestionKey, 0)))  ELSE (LEFT(_CX_Monitor.QuestionKey, CHARINDEX('#', _CX_Monitor.QuestionKey, 0)))  END AS QuestionId ,question_rank.rank_row AS ResponseKey ,_CX_Monitor.RespondentId  ,CASE WHEN _CX_Monitor.Data NOT LIKE '%[1-9]%' THEN NULL ELSE _CX_Monitor.Data END AS Data ,_CX_Monitor.ResearchProjectName  ,_CX_Monitor.Meta_Insert_TaskExecutionInstanceId  ,_CX_Monitor.Meta_LatestUpdate_TaskExecutionInstanceId ,SUBSTRING(_CX_Monitor.QuestionDescription,CHARINDEX(' ',_CX_Monitor.QuestionDescription)+1,LEN(_CX_Monitor.QuestionDescription)) AS QuestionRef   FROM  [Schema].CX_Monitor _CX_Monitor LEFT JOIN ( SELECT TOP 1000000 QuestionKey ,ROW_NUMBER() OVER (ORDER BY RespondentId ASC) AS rank_row  FROM ( SELECT RespondentId ,QuestionKey ,CAST(question_key AS INT) AS question_key ,numeric1 AS number1 ,numeric2 AS number2 ,numeric3 AS number3 ,numeric4 AS number4  FROM ( SELECT RespondentId ,QuestionKey ,CASE WHEN question_key_a IS NULL THEN question_key_b ELSE question_key_a END AS question_key ,CASE WHEN ASCII(question_key_b1) IS NULL THEN 0 ELSE ASCII(question_key_b1)-ASCII('A')+1 END AS numeric1 ,CASE WHEN ASCII(question_key_b2) IS NULL THEN 0 ELSE ASCII(question_key_b2)-ASCII('A')+1 END AS numeric2 ,CASE WHEN ASCII(question_key_c1) IS NULL THEN 0 ELSE ASCII(question_key_c1)-ASCII('A')+1 END AS numeric3 ,CASE WHEN ASCII(question_key_c2) IS NULL THEN 0 ELSE ASCII(question_key_c2)-ASCII('A')+1 END AS numeric4  FROM ( SELECT DISTINCT 1 AS RespondentId ,_CX_Monitor.QuestionKey ,CASE WHEN (REPLACE(REPLACE(REPLACE(REPLACE(_CX_Monitor.QuestionKey,'Q', ''),'#', ''),'x', ''),'O', '')) LIKE '%[A-Z]%' THEN NULL ELSE (REPLACE(REPLACE(REPLACE(REPLACE(_CX_Monitor.QuestionKey,'Q', ''),'#', ''),'x', ''),'O', '')) END AS question_key_a ,STUFF((REPLACE(REPLACE(REPLACE(REPLACE(_CX_Monitor.QuestionKey,'Q', ''),'#', ''),'x', ''),'O', '')), PATINDEX('%[^0-9]%', (REPLACE(REPLACE(REPLACE(REPLACE(_CX_Monitor.QuestionKey,'Q', ''),'#', ''),'x', ''),'O', ''))), 2, '') AS question_key_b ,CASE WHEN CHARINDEX('#', _CX_Monitor.QuestionKey) >0 THEN (CASE WHEN (SUBSTRING(_CX_Monitor.QuestionKey, LEN(_CX_Monitor.QuestionKey)-1,1)) LIKE '%[#,0-9]%' THEN NULL ELSE (SUBSTRING(_CX_Monitor.QuestionKey, LEN(_CX_Monitor.QuestionKey)-1,1)) END) ELSE NULL END AS question_key_b1 ,CASE WHEN CHARINDEX('#', _CX_Monitor.QuestionKey) >0 THEN (CASE WHEN(RIGHT(_CX_Monitor.QuestionKey,1)) LIKE '%[#,0-9]%' THEN NULL ELSE (RIGHT(_CX_Monitor.QuestionKey,1)) END) ELSE NULL END AS question_key_b2 ,CASE WHEN CHARINDEX('x', _CX_Monitor.QuestionKey) >0 THEN (CASE WHEN (SUBSTRING(_CX_Monitor.QuestionKey, LEN(_CX_Monitor.QuestionKey)-1,1)) LIKE '%[x,0-9]%'  THEN NULL ELSE (SUBSTRING(_CX_Monitor.QuestionKey, LEN(_CX_Monitor.QuestionKey)-1,1)) END) ELSE NULL END AS question_key_c1 ,CASE WHEN CHARINDEX('x', _CX_Monitor.QuestionKey) >0 THEN (CASE WHEN(RIGHT(_CX_Monitor.QuestionKey,1)) LIKE '%[#,0-9]%' THEN NULL ELSE (RIGHT(_CX_Monitor.QuestionKey,1)) END) ELSE NULL END AS question_key_c2  FROM  [Schema].CX_Monitor _CX_Monitor  WHERE  CHARINDEX('Q',_CX_Monitor.QuestionDescription) > 0 )a )b )c  ORDER BY RespondentId ,question_key ,number1 ,number2 ,number3 ,number4 ) question_rank  ON  _CX_Monitor.QuestionKey = question_rank.QuestionKey  WHERE  CHARINDEX('Q',_CX_Monitor.QuestionDescription) > 0  ) ,_CX_Monitor_Cust AS ( SELECT _CX_Monitor.QuestionDescription  ,_CX_Monitor.QuestionKey  ,_CX_Monitor.RespondentId  ,_CX_Monitor.Data  ,_CX_Monitor.Meta_Insert_TaskExecutionInstanceId  ,_CX_Monitor.Meta_LatestUpdate_TaskExecutionInstanceId  FROM [Schema].CX_Monitor _CX_Monitor  WHERE _CX_Monitor.QuestionKey = 'PARTY' ) ,_CX_Monitor_Seg AS ( SELECT _CX_Monitor.QuestionDescription  ,_CX_Monitor.QuestionKey  ,_CX_Monitor.RespondentId  ,_CX_Monitor.Data  ,_CX_Monitor.Meta_Insert_TaskExecutionInstanceId  ,_CX_Monitor.Meta_LatestUpdate_TaskExecutionInstanceId  FROM [Schema].CX_Monitor _CX_Monitor  WHERE _CX_Monitor.QuestionKey = 'SEG' ) ,_DimCustomer AS ( SELECT DISTINCT party.Data  ,_DimCustomer.CustomerId ,_DimCustomer.CustomerCode  FROM  [Schema].[DimCustomer] _DimCustomer JOIN  ( SELECT _CX_Monitor.Data   FROM [Schema].CX_Monitor _CX_Monitor  WHERE _CX_Monitor.QuestionKey = 'PARTY' AND  _CX_Monitor.Data NOT LIKE '' )party  ON _DimCustomer.CustomerCode = party.Data  WHERE _DimCustomer.Meta_IsCurrent = 1 ) ,_Question_Id AS ( SELECT _DimQuestion.QuestionId  ,_DimQuestion.QuestionKey  FROM [Schema].DimQuestion _DimQuestion ) ,_CX_Monitor_Activity_Closed_Date AS ( SELECT DISTINCT b.RespondentId  ,CAST(b.DataYear+''+b.DataMonth+''+b.DataDay AS INT) AS Data  FROM   ( SELECT RespondentId  ,CASE WHEN LEN(SUBSTRING((CAST(Data AS VARCHAR(255))),0,CHARINDEX('/',(CAST(Data AS VARCHAR(255)))))) <2 THEN '0'+''+(SUBSTRING((CAST(Data AS VARCHAR(255))),0,CHARINDEX('/',(CAST(Data AS VARCHAR(255)))))) ELSE (SUBSTRING((CAST(Data AS VARCHAR(255))),0,CHARINDEX('/',(CAST(Data AS VARCHAR(255)))))) END AS DataDay ,CASE WHEN (CASE WHEN SUBSTRING((CAST(Data AS VARCHAR(255))),CHARINDEX('/',(CAST(Data AS VARCHAR(255))))+1,LEN((CAST(Data AS VARCHAR(255))))-7) LIKE '%/' THEN NULL ELSE SUBSTRING((CAST(Data AS VARCHAR(255))),CHARINDEX('/',(CAST(Data AS VARCHAR(255))))+1,LEN((CAST(Data AS VARCHAR(255))))-7) END) IS NULL THEN (CASE WHEN SUBSTRING((CAST(Data AS VARCHAR(255))),CHARINDEX('/',(CAST(Data AS VARCHAR(255))))+1,LEN((CAST(Data AS VARCHAR(255))))-8) < 2 THEN NULL ELSE SUBSTRING((CAST(Data AS VARCHAR(255))),CHARINDEX('/',(CAST(Data AS VARCHAR(255))))+1,LEN((CAST(Data AS VARCHAR(255))))-8) END) ELSE  (CASE WHEN SUBSTRING((CAST(Data AS VARCHAR(255))),CHARINDEX('/',(CAST(Data AS VARCHAR(255))))+1,LEN((CAST(Data AS VARCHAR(255))))-7) LIKE '%/' THEN NULL ELSE SUBSTRING((CAST(Data AS VARCHAR(255))),CHARINDEX('/',(CAST(Data AS VARCHAR(255))))+1,LEN((CAST(Data AS VARCHAR(255))))-7) END) END AS DataMonth ,SUBSTRING((CAST(Data AS VARCHAR(255))),CHARINDEX('/',(CAST(Data AS VARCHAR(255))))+4,LEN((CAST(Data AS VARCHAR(255))))) AS DataYear  FROM (  SELECT CAST(_CX_Monitor.RespondentId AS INT) AS RespondentId  ,CASE WHEN _CX_Monitor.Data LIKE '' THEN _CX_Monitor_Max_Date.Data ELSE _CX_Monitor.Data  END AS Data   FROM  [Schema].CX_Monitor _CX_Monitor  LEFT JOIN  ( SELECT CAST(ResearchProjectName AS VARCHAR(255)) AS ResearchProjectName ,CAST(Data AS VARCHAR(255)) AS Data  FROM ( SELECT  _CX_Monitor.RespondentId ,_CX_Monitor.ResearchProjectName ,_CX_Monitor.Data ,ROW_NUMBER() OVER (PARTITION BY _CX_Monitor.ResearchProjectName ORDER BY _CX_Monitor.Data DESC) AS rank_row  FROM [Schema].CX_Monitor _CX_Monitor  WHERE _CX_Monitor.QuestionKey = 'ACTCD' AND  _CX_Monitor.Data NOT LIKE '' )a  WHERE rank_row = 1 ) _CX_Monitor_Max_Date  ON _CX_Monitor.ResearchProjectName = _CX_Monitor_Max_Date.ResearchProjectName  WHERE _CX_Monitor.QuestionKey = 'ACTCD' )a  )b)
	INSERT INTO lumo.FactSurvey (
		FactSurvey.CustomerId,
		FactSurvey.QuestionId,
		FactSurvey.ResponseDateId,
		FactSurvey.Response,
		FactSurvey.RespondentKey,
		FactSurvey.ResponseKey,
		FactSurvey.Segment,
		FactSurvey.ResearchProjectName)
	  SELECT
		_DimCustomer.CustomerId,
		_Question_Id.QuestionId,
		/* _Question_Id.QuestionId */ CONVERT(NCHAR(8),ISNULL(_CX_Monitor_Activity_Closed_Date.Data, '99991231'),112),
		COALESCE( _CX_MonitorCodes.Label ,_CX_Monitor.Data) ,
		_CX_Monitor.RespondentId,
		_CX_Monitor.ResponseKey,
		_CX_Monitor_Seg.Data,
		_CX_Monitor.ResearchProjectName
	  FROM  [Schema].CX_MonitorCodes _CX_MonitorCodes  LEFT JOIN _CX_Monitor         ON _CX_MonitorCodes.QuestionKey = _CX_Monitor.QuestionId AND _CX_MonitorCodes.Value = _CX_Monitor.Data LEFT JOIN _CX_Monitor_Cust       ON _CX_Monitor.RespondentId = _CX_Monitor_Cust.RespondentId LEFT JOIN _CX_Monitor_Seg        ON _CX_Monitor.RespondentId = _CX_Monitor_Seg.RespondentId LEFT JOIN _DimCustomer        ON _CX_Monitor_Cust.Data = _DimCustomer.Data LEFT JOIN _Question_Id        ON _CX_Monitor.QuestionRef = _Question_Id.QuestionKey LEFT JOIN _CX_Monitor_Activity_Closed_Date   ON _CX_Monitor.RespondentId = _CX_Monitor_Activity_Closed_Date.RespondentId  WHERE  _CX_Monitor.QuestionId IS NOT NULL;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;