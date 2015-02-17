USE [DW_Dimensional]
GO
CREATE USER [STAFF\Jaya.Mukherjee] FOR LOGIN [STAFF\Jaya.Mukherjee] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [STAFF\Jaya.Mukherjee]
GO
