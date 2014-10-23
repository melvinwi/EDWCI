USE [DW_Utility]
GO
CREATE USER [VE\Sargun.kaur] FOR LOGIN [VE\Sargun.kaur] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [VE\Sargun.kaur]
GO
