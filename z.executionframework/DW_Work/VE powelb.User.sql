USE [DW_Work]
GO
CREATE USER [VE\powelb] FOR LOGIN [VE\powelb] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [VE\powelb]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [VE\powelb]
GO
