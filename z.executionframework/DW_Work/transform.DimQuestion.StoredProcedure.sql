USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [transform].[DimQuestion]
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

	INSERT INTO DW_Work.temp.DimQuestion (
		DimQuestion.QuestionKey,
		DimQuestion.Question)
	  SELECT
		DISTINCT SUBSTRING( _CX_Monitor.QuestionDescription ,CHARINDEX(' ',_CX_Monitor.QuestionDescription)+1,LEN(_CX_Monitor.QuestionDescription)),
		SUBSTRING( _CX_Monitor.QuestionDescription ,CHARINDEX(' ',_CX_Monitor.QuestionDescription)+1,LEN(_CX_Monitor.QuestionDescription))
	  FROM DW_Staging.csv.CX_Monitor AS _CX_Monitor WHERE CHARINDEX('Q',_CX_Monitor.QuestionDescription) > 0 AND _CX_Monitor.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;
GO
USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [transform].[DimQuestion]
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

	INSERT INTO DW_Work.temp.DimQuestion (
		DimQuestion.QuestionKey,
		DimQuestion.Question)
	  SELECT
		ROW_NUMBER()OVER(ORDER BY _d.question_key, _d.sequence1, _d.sequence2, _d.sequence3 ASC),
		_d.question
	  FROM ( SELECT  _c.QuestionDescription AS question ,_c.question_key ,SUM(_c.number1+_c.number2) AS sequence1  ,_c.number3 AS sequence2 ,_c.number4 AS sequence3      FROM  (  SELECT  _b.RespondentId  ,_b.QuestionKey  ,_b.QuestionDescription ,CAST(_b.question_key AS INT) AS question_key  ,_b.numeric1 AS number1  ,_b.numeric2 AS number2  ,_b.numeric3 AS number3  ,_b.numeric4 AS number4   FROM  (  SELECT  _a.RespondentId  ,_a.QuestionKey  ,_a.QuestionDescription   ,ISNULL(_a.question_key_a, _a.question_key_b) AS question_key ,ISNULL(ASCII(_a.question_key_b1) - 64, 0) AS numeric1 ,ISNULL(ASCII(_a.question_key_b2) - 64, 0) AS numeric2 ,ISNULL(ASCII(_a.question_key_c1) - 64, 0) AS numeric3 ,ISNULL(ASCII(_a.question_key_c2) - 64, 0) AS numeric4 FROM  (  SELECT DISTINCT  1 AS RespondentId  ,_CX_Monitor.QuestionKey  ,SUBSTRING( _CX_Monitor.QuestionDescription ,CHARINDEX(' ',_CX_Monitor.QuestionDescription)+1,LEN(_CX_Monitor.QuestionDescription)) AS QuestionDescription ,CASE WHEN (REPLACE(REPLACE(REPLACE(REPLACE(_CX_Monitor.QuestionKey,'Q', ''),'#', ''),'x', ''),'O', '')) LIKE '%[A-Z]%' THEN NULL ELSE (REPLACE(REPLACE(REPLACE(REPLACE(_CX_Monitor.QuestionKey,'Q', ''),'#', ''),'x', ''),'O', '')) END AS question_key_a  ,STUFF((REPLACE(REPLACE(REPLACE(REPLACE(_CX_Monitor.QuestionKey,'Q', ''),'#', ''),'x', ''),'O', '')), PATINDEX('%[^0-9]%', (REPLACE(REPLACE(REPLACE(REPLACE(_CX_Monitor.QuestionKey,'Q', ''),'#', ''),'x', ''),'O', ''))), 2, '') AS question_key_b  ,CASE WHEN CHARINDEX('#', _CX_Monitor.QuestionKey) >0 THEN (CASE WHEN (SUBSTRING(_CX_Monitor.QuestionKey, LEN(_CX_Monitor.QuestionKey)-1,1)) LIKE '%[#,0-9]%' THEN NULL ELSE (SUBSTRING(_CX_Monitor.QuestionKey, LEN(_CX_Monitor.QuestionKey)-1,1)) END) ELSE NULL END AS question_key_b1  ,CASE WHEN CHARINDEX('#', _CX_Monitor.QuestionKey) >0 THEN (CASE WHEN(RIGHT(_CX_Monitor.QuestionKey,1)) LIKE '%[#,0-9]%' THEN NULL ELSE (RIGHT(_CX_Monitor.QuestionKey,1)) END) ELSE NULL END AS question_key_b2  ,CASE WHEN CHARINDEX('x', _CX_Monitor.QuestionKey) >0 THEN (CASE WHEN (SUBSTRING(_CX_Monitor.QuestionKey, LEN(_CX_Monitor.QuestionKey)-1,1)) LIKE '%[x,0-9]%'  THEN NULL ELSE (SUBSTRING(_CX_Monitor.QuestionKey, LEN(_CX_Monitor.QuestionKey)-1,1)) END) ELSE NULL END AS question_key_c1  ,CASE WHEN CHARINDEX('x', _CX_Monitor.QuestionKey) >0 THEN (CASE WHEN(RIGHT(_CX_Monitor.QuestionKey,1)) LIKE '%[#,0-9]%' THEN NULL ELSE (RIGHT(_CX_Monitor.QuestionKey,1)) END) ELSE NULL END AS question_key_c2   FROM DW_Staging.csv.CX_Monitor _CX_Monitor   WHERE CHARINDEX('Q',_CX_Monitor.QuestionDescription) > 0  AND  _CX_Monitor.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID )_a  )_b  )_c GROUP BY _c.QuestionDescription ,_c.question_key ,_c.number3 ,_c.number4  )_d    ORDER BY  _d.question_key ,_d.sequence1 ,_d.sequence2;


SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;

GO
