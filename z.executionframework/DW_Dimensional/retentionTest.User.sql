USE [DW_Dimensional]
GO
CREATE USER [retentionTest] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [retentionTest]
GO
