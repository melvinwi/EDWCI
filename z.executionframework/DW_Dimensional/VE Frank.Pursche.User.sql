USE [DW_Dimensional]
GO
CREATE USER [VE\Frank.Pursche] FOR LOGIN [VE\Frank.Pursche] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [VE\Frank.Pursche]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [VE\Frank.Pursche]
GO
