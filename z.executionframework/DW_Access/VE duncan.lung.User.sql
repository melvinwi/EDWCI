USE [DW_Access]
GO
CREATE USER [VE\duncan.lung] FOR LOGIN [VE\duncan.lung] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [DW_FullAccess] ADD MEMBER [VE\duncan.lung]
GO
ALTER ROLE [db_datareader] ADD MEMBER [VE\duncan.lung]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [VE\duncan.lung]
GO
