USE [DW_Dimensional]
GO
CREATE USER [VE\Ronald.Teoh] FOR LOGIN [VE\Ronald.Teoh] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [VE\Ronald.Teoh]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [VE\Ronald.Teoh]
GO
