USE [DW_Dimensional]
GO
CREATE USER [VE\Jaya.Mukherjee] FOR LOGIN [VE\Jaya.Mukherjee] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [VE\Jaya.Mukherjee]
GO
