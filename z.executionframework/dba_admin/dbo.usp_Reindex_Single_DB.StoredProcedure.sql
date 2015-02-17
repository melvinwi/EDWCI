USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[usp_Reindex_Single_DB] @DBNAME varchar(50)
AS 
DECLARE @Query NVARCHAR(1000)
DECLARE @Starttime datetime	
DECLARE @Endtime  numeric(5)
DECLARE @tableSchema NVARCHAR(128)	--To Check for New Tables and Add Into TableStatics Log 
DECLARE @tableName NVARCHAR(128)	--To Check for New Tables and Add Into TableStatics Log 
DECLARE @Indexname NVARCHAR(500)  --To Check for New Indexes and Add Into TableStatics Log 
DECLARE @Indexquery NVARCHAR(2000)

IF OBJECT_ID('tempdb..##WORKLOG') IS NOT NULL
   DROP TABLE ##WORKLOG

SET @Query ='DECLARE updatestats CURSOR FOR   SELECT  table_schema, table_name ,I.name as Indexname FROM '+@DBNAME+'.information_schema.tables InSc 
INNER JOIN '+@DBNAME+'.sys.tables T ON InSc.TABLE_NAME =T.name 
AND InSc.Table_schema =object_SCHEMA_NAME (t.object_id ,DB_ID('''+@DBNAME+'''))
INNER JOIN '+@DBNAME+'.sys.indexes  I 
ON T.object_id =I.object_id  where TABLE_TYPE = ''BASE TABLE'' 
AND I.index_id > 0 ORDER BY  TABLE_SCHEMA ,TABLE_NAME '
PRINT @Query

EXEC sp_executesql @Query
OPEN updatestats

FETCH NEXT FROM updatestats INTO @tableSchema, @tableName,@Indexname
WHILE (@@FETCH_STATUS = 0)
		BEGIN
	
				DECLARE @TempTable1 TABLE (dbname nvarchar(128),tableschema nvarchar(50),tablename nvarchar(128),indexname nvarchar(500))
				INSERT INTO @TempTable1
				Values(@dbname, @tableSchema, @tableName,@Indexname  )

				
				FETCH NEXT FROM updatestats INTO @tableSchema, @tableName,@Indexname
		END
					

				INSERT INTO TablestatisticsLog (database_name ,[schema_name],table_name,index_name )
				SELECT  dbname,tableschema,tablename,indexname   from  @TempTable1 T WHERE NOT EXISTS (SELECT 1 FROM 
				TableStatisticsLog TS  WHERE TS.database_name =t.dbname AND 
				TS.[schema_name] =t.tableschema AND TS.table_name =t.tablename AND ISNULL(TS.index_name,0)=ISNULL(t.indexname,0) )

				IF OBJECT_ID('dba_admin..tblcmp') IS NOT NULL
				DROP TABLE tblcmp
				SELECT * into tblcmp from TablestatisticsLog

				--;WITH QryA AS (
				--	 SELECT ROW_NUMBER() OVER(PARTITION BY T.database_name,T.[schema_name],T.Table_name  ORDER BY T.database_name,T.[schema_name],T.Table_name) AS ARowCount,
				--	 T.database_name as Adbname,T.[schema_name] as ASchname ,T.table_name as ATablename,T.index_name as Aindexname  from TableStatisticsLog T LEFT JOIN 
				--	 tblcmp TT ON  TT.[schema_name]   =T.[schema_name]  AND TT.table_name =t.table_name 
				--	 AND tt.database_name =T.database_name AND TT.index_name =t.index_name  
				--	 WHERE    tt.index_name  IS NULL ),
				--QryB AS (
				--	SELECT ROW_NUMBER() OVER(PARTITION BY tt.database_name,tt.[schema_name],tt.Table_name ORDER BY tt.database_name,tt.[schema_name],tt.Table_name) AS BRowCount,
				--	tt.database_name as Bdbname,tt.[schema_name]  as BSchname  ,tt.table_name as BTablename,tt.index_name as Bindexname    from TableStatisticsLog T RIGHT JOIN 
				--	tblcmp TT ON  TT.[schema_name]   =T.[schema_name]  AND TT.table_name =t.table_name 
				--	AND tt.database_name =T.database_name AND TT.index_name =t.index_name  
				--	WHERE   T.index_name  IS NULL ) 
				--UPDATE QryA SET Aindexname= Bindexname FROM QryA INNER JOIN QryB ON  Adbname=Bdbname  AND  ASchname=BSchname AND ATablename=BTablename
				--WHERE ARowCount=BRowcount
				
CLOSE updatestats
DEALLOCATE updatestats

--Calculating the Fragment percentage

SET @Indexquery ='SELECT INDEX_PROCESS,round(avg_fragmentation_in_percent,0) as fragpercent ,tablename,scname,LastRunTime  INTO ##WORKLOG FROM (  SELECT CASE 
            WHEN (a.avg_fragmentation_in_percent >  15  OR a.avg_page_space_used_in_percent < 60)  AND a.page_count > 0
                THEN ''ALTER INDEX ['' + i.NAME + ''] ON '' +'''+@DBNAME+'.'''+'+sc.name+'+'''.'''+'+t.NAME + '' REBUILD with(ONLINE=ON);''
            WHEN ((a.avg_fragmentation_in_percent   > 10   AND a.avg_fragmentation_in_percent   < 15)  
    OR (a.avg_page_space_used_in_percent > 60 AND a.avg_page_space_used_in_percent < 75))     AND a.page_count > 64 
                THEN ''ALTER INDEX ['' + i.NAME + ''] ON '' +'''+@DBNAME+'.'''+'+sc.name+'+'''.'''+'+t.NAME + '' REORGANIZE;''
            END AS INDEX_PROCESS
        ,avg_fragmentation_in_percent
        ,t.NAME as tablename,sc.name as scname,SL.end_time as LastRunTime
    FROM '+@DBNAME+'.sys.dm_db_index_physical_stats(NULL, NULL, NULL, NULL, NULL) AS a
    INNER JOIN '+@DBNAME+'.sys.indexes AS i ON a.object_id = i.object_id
        AND a.index_id = i.index_id
    INNER JOIN '+@DBNAME+'.sys.tables t ON t.object_id = i.object_id
	JOIN '+@DBNAME+'.sys.schemas sc ON t.schema_id =sc.schema_id 
	JOIN dba_admin..TableStatisticsLog SL ON sc.name =SL.schema_name 
	AND t.name =SL.table_name 
    WHERE i.NAME IS NOT NULL
    ) PROCESS
WHERE PROCESS.INDEX_PROCESS IS NOT NULL
ORDER BY avg_fragmentation_in_percent DESC'


EXEC sp_ExecuteSql @Indexquery

UPDATE dba_admin..TableStatisticsLog SET fragpercent=w.fragpercent
FROM ##WORKLOG W INNER JOIN dba_admin..TableStatisticsLog Ts
ON W.scname =ts.schema_name AND w.tablename =ts.table_name 

SET @Starttime =GETDATE()
print @Starttime
DECLARE IndexUpd CURSOR FOR SELECT INDEX_PROCESS,tablename,scname FROM ##WORKLOG 
 OPEN IndexUpd 
DECLARE @IndexStatement VARCHAR(2000)
DECLARE @IndexTable VARCHAR (50)
DECLARE @IndexSchema VARCHAR(50)
FETCH NEXT FROM IndexUpd INTO @IndexStatement,@IndexTable,@IndexSchema

WHILE (@@FETCH_STATUS =0)
		BEGIN
			PRINT @IndexStatement
			UPDATE dba_admin..TableStatisticsLog SET start_time =GETDATE() WHERE table_name =@IndexTable ANd [schema_name]=@IndexSchema 
			EXEC (@IndexStatement)
			UPDATE dba_admin..TableStatisticsLog SET end_time =GETDATE() WHERE table_name =@IndexTable ANd [schema_name]=@IndexSchema 
			UPDATE [dba_admin].[dbo].[TableStatisticsLog]	SET timetaken_seconds = DATEDIFF(ss, Start_time ,end_time) WHERE [SCHEMA_NAME] =@IndexSchema and table_name=@IndexTable	
			Select @Endtime= DateDiff(ss, @Starttime , getdate()) /60 --Time Calculation in minutes 
				PRINT 'Printing Endtime'
				PRINT @Endtime
				If @Endtime > 180  --Takes longer than 3 mintues stop the job
					EXEC msdb.dbo.sp_stop_job @job_name = 'Database Maintenance - Single_DB_Reindexing'
			FETCH NEXT FROM IndexUpd INTO @IndexStatement,@IndexTable,@IndexSchema

		END

CLOSE IndexUpd
DEALLOCATE IndexUpd




GO
