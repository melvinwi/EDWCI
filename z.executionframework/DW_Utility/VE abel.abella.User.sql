USE [DW_Utility]
GO
CREATE USER [VE\abel.abella] FOR LOGIN [VE\abel.abella] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [VE\abel.abella]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [VE\abel.abella]
GO
