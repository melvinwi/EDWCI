USE [DW_Access]
GO
CREATE USER [VE\hoalex] FOR LOGIN [VE\hoalex] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [VE\hoalex]
GO
