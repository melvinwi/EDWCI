USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_RecordDatabaseLogFileSpace] 
AS

-- Lumo Energy | Database Administration
-- Load database log file size and used space
--
-- 2012-10-11 Darren.Pilkington Initial Release
-- 2013-02-21 Darren.Pilkington split from [usp_RecordDatabaseDataFileSpace]
--

SET NOCOUNT ON;

DECLARE @DATABASE_NAME SYSNAME;
DECLARE @CMD VARCHAR(MAX);

DECLARE database_list_cursor CURSOR LOCAL FORWARD_ONLY STATIC READ_ONLY FOR
SELECT name
FROM sys.databases
WHERE state = 0
ORDER BY name;

OPEN database_list_cursor
FETCH NEXT FROM database_list_cursor INTO @DATABASE_NAME

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @CMD = 'USE ['+@database_name+'];
		INSERT INTO [dba_admin].[dbo].[FileSpace]
		(database_name,physical_name,logical_name,type_desc,filegroup,size_kb,used_kb,snapshot_size_kb)
		SELECT '''+@DATABASE_NAME+''' as database_name,
		sdf.physical_name,
		sdf.name,
		sdf.type_desc,
		sds.name,
		sdf.size*8,
		FILEPROPERTY(sdf.name,''SpaceUsed'')*8,
		divfs.size_on_disk_bytes/1024
		FROM ['+@database_name+'].sys.database_files sdf
		LEFT JOIN ['+@database_name+'].sys.data_spaces sds ON sdf.data_space_id = sds.data_space_id
		LEFT JOIN sys.dm_io_virtual_file_stats(DB_ID(),null) divfs ON sdf.file_id = divfs.file_id
		WHERE sdf.type_desc = ''LOG'';'

		EXEC (@CMD);
		FETCH NEXT FROM database_list_cursor INTO @DATABASE_NAME
END

CLOSE database_list_cursor;
DEALLOCATE database_list_cursor;



GO
