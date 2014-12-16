USE [DW_Access]
GO
CREATE USER [VE\Sargun.kaur] FOR LOGIN [VE\Sargun.kaur] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [DW_FullAccess] ADD MEMBER [VE\Sargun.kaur]
GO
ALTER ROLE [db_datareader] ADD MEMBER [VE\Sargun.kaur]
GO
