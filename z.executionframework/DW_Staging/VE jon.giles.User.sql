USE [DW_Staging]
GO
CREATE USER [VE\jon.giles] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [VE\jon.giles]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [VE\jon.giles]
GO