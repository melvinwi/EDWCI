USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [transform].[FactSurvey]
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

	;WITH _CX_Monitor AS ( SELECT CX_Monitor.QuestionDescription  ,CX_Monitor.QuestionKey ,CASE WHEN(CASE WHEN (CHARINDEX('#', CX_Monitor.QuestionKey)) = (LEN(CX_Monitor.QuestionKey)) THEN 1 ELSE 0 END) = 0  THEN REPLACE(SUBSTRING(CX_Monitor.QuestionKey, CHARINDEX(',', CX_Monitor.QuestionKey), LEN(CX_Monitor.QuestionKey)), ',', '')  ELSE CX_Monitor.QuestionKey END AS QuestionId ,CX_Monitor.RespondentId  ,CX_Monitor.Data ,CX_Monitor.ResearchProjectName   ,CX_Monitor.Meta_Insert_TaskExecutionInstanceId  ,CX_Monitor.Meta_LatestUpdate_TaskExecutionInstanceId ,SUBSTRING(CX_Monitor.QuestionDescription,CHARINDEX(' ',CX_Monitor.QuestionDescription)+1,LEN(CX_Monitor.QuestionDescription)) AS QuestionRef   FROM DW_Staging.csv.CX_Monitor  WHERE CHARINDEX('Q',CX_Monitor.QuestionDescription) > 0  AND  CHARINDEX('x.',CX_Monitor.QuestionDescription) = 0  ) , _CX_Monitor_Cust AS ( SELECT CX_Monitor.QuestionDescription  ,CX_Monitor.QuestionKey  ,CX_Monitor.RespondentId  ,CX_Monitor.Data  ,CX_Monitor.Meta_Insert_TaskExecutionInstanceId  ,CX_Monitor.Meta_LatestUpdate_TaskExecutionInstanceId  FROM DW_Staging.csv.CX_Monitor   WHERE CX_Monitor.QuestionKey = 'PARTY' )  , _DimCustomer AS ( SELECT DimCustomer.CustomerId ,DimCustomer.CustomerCode  FROM  DW_Dimensional.DW.DimCustomer  JOIN  (     SELECT     CX_Monitor.Data       FROM DW_Staging.csv.CX_Monitor       WHERE CX_Monitor.QuestionKey = 'PARTY'     AND  CX_Monitor.Data NOT LIKE ''    )party  ON DimCustomer.CustomerCode = party.Data   WHERE DimCustomer.Meta_IsCurrent = 1 )  , _Question_Id AS ( SELECT DimQuestion.QuestionId   ,DimQuestion.QuestionKey  FROM DW_Dimensional.DW.DimQuestion )  , _CX_Monitor_Activity_Closed_Date AS ( SELECT QuestionDescription  ,QuestionKey  ,RespondentId  ,CAST(DataYear+''+DataMonth+''+DataDay AS INT) AS Data ,Meta_Insert_TaskExecutionInstanceId  ,Meta_LatestUpdate_TaskExecutionInstanceId  FROM ( SELECT QuestionDescription  ,QuestionKey  ,RespondentId  ,Data ,CASE WHEN LEN(SUBSTRING((CAST(Data AS VARCHAR(255))),0,CHARINDEX('/',(CAST(Data AS VARCHAR(255)))))) <2 THEN '0'+''+(SUBSTRING((CAST(Data AS VARCHAR(255))),0,CHARINDEX('/',(CAST(Data AS VARCHAR(255)))))) ELSE (SUBSTRING((CAST(Data AS VARCHAR(255))),0,CHARINDEX('/',(CAST(Data AS VARCHAR(255)))))) END AS DataDay ,CASE WHEN (CASE WHEN SUBSTRING((CAST(Data AS VARCHAR(255))),CHARINDEX('/',(CAST(Data AS VARCHAR(255))))+1,LEN((CAST(Data AS VARCHAR(255))))-7) LIKE '%/' THEN NULL ELSE SUBSTRING((CAST(Data AS VARCHAR(255))),CHARINDEX('/',(CAST(Data AS VARCHAR(255))))+1,LEN((CAST(Data AS VARCHAR(255))))-7) END) IS NULL THEN (CASE WHEN SUBSTRING((CAST(Data AS VARCHAR(255))),CHARINDEX('/',(CAST(Data AS VARCHAR(255))))+1,LEN((CAST(Data AS VARCHAR(255))))-8) < 2 THEN NULL ELSE SUBSTRING((CAST(Data AS VARCHAR(255))),CHARINDEX('/',(CAST(Data AS VARCHAR(255))))+1,LEN((CAST(Data AS VARCHAR(255))))-8) END) ELSE  (CASE WHEN SUBSTRING((CAST(Data AS VARCHAR(255))),CHARINDEX('/',(CAST(Data AS VARCHAR(255))))+1,LEN((CAST(Data AS VARCHAR(255))))-7) LIKE '%/' THEN NULL ELSE SUBSTRING((CAST(Data AS VARCHAR(255))),CHARINDEX('/',(CAST(Data AS VARCHAR(255))))+1,LEN((CAST(Data AS VARCHAR(255))))-7) END) END AS DataMonth ,SUBSTRING((CAST(Data AS VARCHAR(255))),CHARINDEX('/',(CAST(Data AS VARCHAR(255))))+4,LEN((CAST(Data AS VARCHAR(255))))) AS DataYear ,Meta_Insert_TaskExecutionInstanceId  ,Meta_LatestUpdate_TaskExecutionInstanceId  FROM ( SELECT CX_Monitor.QuestionDescription  ,CX_Monitor.QuestionKey  ,CX_Monitor.RespondentId  ,CASE WHEN CX_Monitor.Data LIKE '' THEN CX_Monitor_Max_Date.Data ELSE CX_Monitor.Data END AS Data ,CX_Monitor.Meta_Insert_TaskExecutionInstanceId  ,CX_Monitor.Meta_LatestUpdate_TaskExecutionInstanceId  FROM  DW_Staging.csv.CX_Monitor LEFT JOIN ( SELECT ResearchProjectName ,Data  FROM ( SELECT  CX_Monitor.ResearchProjectName ,CX_Monitor.Data ,ROW_NUMBER() OVER (PARTITION BY CX_Monitor.ResearchProjectName ORDER BY CX_Monitor.Data DESC) AS rank_row  FROM DW_Staging.csv.CX_Monitor  WHERE CX_Monitor.QuestionKey = 'ACTCD' AND  CX_Monitor.Data NOT LIKE '' )a  WHERE rank_row = 1 ) CX_Monitor_Max_Date  ON CX_Monitor.ResearchProjectName = CX_Monitor_Max_Date.ResearchProjectName  WHERE CX_Monitor.QuestionKey = 'ACTCD' )a )b )
	INSERT INTO DW_Work.temp.FactSurvey (
		FactSurvey.CustomerId,
		FactSurvey.QuestionId,
		FactSurvey.ResponseDateId,
		FactSurvey.Response,
		FactSurvey.RespondentKey,
		FactSurvey.ResponseKey,
		FactSurvey.ResearchProjectName)
	  SELECT
		_DimCustomer.CustomerId,
		_Question_Id.QuestionId,
		/* _Question_Id.QuestionId */ CONVERT(NCHAR(8),ISNULL(_CX_Monitor_Activity_Closed_Date.Data, '99991231'),112),
		COALESCE( _CX_MonitorCodes.Label ,_CX_Monitor.Data) ,
		_CX_Monitor.RespondentId,
		CAST((REPLACE(SUBSTRING( _CX_Monitor.QuestionKey , CHARINDEX(',', _CX_Monitor.QuestionKey), LEN(_CX_Monitor.QuestionKey)), '#', ''))AS VARCHAR(MAX))
  + '' + CAST((REPLACE(SUBSTRING(_CX_Monitor.QuestionKey, CHARINDEX('#', _CX_Monitor.QuestionKey), LEN(_CX_Monitor.QuestionKey)), '#', ''))AS VARCHAR(MAX))
  + '' + CAST(_CX_Monitor.RespondentId AS VARCHAR(MAX)),
		_CX_Monitor.ResearchProjectName
	  FROM  DW_Staging.csv.CX_MonitorCodes _CX_MonitorCodes  LEFT JOIN _CX_Monitor       ON _CX_MonitorCodes.QuestionKey = _CX_Monitor.QuestionId             AND _CX_MonitorCodes.Value = _CX_Monitor.Data LEFT JOIN _CX_Monitor_Cust     ON _CX_Monitor.RespondentId = _CX_Monitor_Cust.RespondentId LEFT JOIN _Question_Id      ON _CX_Monitor.QuestionRef = _Question_Id.QuestionKey LEFT JOIN _DimCustomer      ON _CX_Monitor_Cust.Data = _DimCustomer.CustomerCode LEFT JOIN _CX_Monitor_Activity_Closed_Date ON _CX_Monitor.RespondentId = _CX_Monitor_Activity_Closed_Date.RespondentId  WHERE  _CX_Monitor.QuestionId IS NOT NULL;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;
GO
