USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[usp_StatUpdate_Single_DB] @DBNAME varchar(50)
AS 
DECLARE @Query NVARCHAR(255)

SET @Query ='DECLARE updatestats CURSOR FOR SELECT  table_schema, table_name FROM '+@DBNAME+'.information_schema.tables where TABLE_TYPE = ''BASE TABLE'' and TABLE_NAME in (''crm_party'',''inv_client_charges'') '

PRINT @Query

EXEC sp_executesql @Query
OPEN updatestats

DECLARE @tableSchema NVARCHAR(128)
DECLARE @tableName NVARCHAR(128)
DECLARE @Statement NVARCHAR(300)
DECLARE @current_log_record INT;

DECLARE @cmd_parameters NVARCHAR(1000);
DECLARE @SqlCmd NVarchar(500)
DECLARE @RCOUNT INT 
DECLARE @Starttime datetime	
DECLARE @Endtime  numeric(5)


SET @Starttime =GETDATE()
print @Starttime
FETCH NEXT FROM updatestats INTO @tableSchema, @tableName
--INSERT INTO [dba_admin].[dbo].[DatabaseStatisticsLog] (database_name,start_time)
--		VALUES (@dbname, GETDATE());
--		SET @current_log_record = CAST(@@IDENTITY AS INT);
WHILE (@@FETCH_STATUS = 0)
BEGIN
		
			
		SET @SqlCmd='SELECT @Output=COUNT(*) FROM '+@DBNAME+'.'+@tableSchema+'.'+@tableName+''
		print @sqlcmd
		SET @cmd_parameters = '@Output INT OUTPUT';
		EXEC SP_EXECUTESQL @sqlCmd, @cmd_parameters, @Output = @RCOUNT  OUTPUT; 
		PRINT  @RCOUNT
		IF @RCOUNT =0
		BEGIN
			print 'no rows'
			FETCH NEXT FROM updatestats INTO @tableSchema, @tableName
		END
		ELSE 
		BEGIN 
		
   
			PRINT N'UPDATING STATISTICS ' + '[' + @tableSchema + ']' + '.' + '[' + @tableName + ']'
			SET @Statement = 'UPDATE STATISTICS '  ++@DBNAME+'.'+ '[' + @tableSchema + ']' + '.' + '[' + @tableName + ']' + '  WITH FULLSCAN'
		--	PRINT @Statement
			EXEC sp_executesql @Statement
			Select @Endtime= DateDiff(ss, @Starttime , getdate()) /60 
			PRINT @Endtime
			

			 FETCH NEXT FROM updatestats INTO @tableSchema, @tableName
		END
		
--UPDATE [dba_admin].[dbo].[DatabaseStatisticsLog]	SET end_time = GETDATE()
--			WHERE log_record_no = @current_log_record;		
END

CLOSE updatestats
DEALLOCATE updatestats

GO
