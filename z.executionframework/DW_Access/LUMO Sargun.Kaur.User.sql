USE [DW_Access]
GO
CREATE USER [LUMO\Sargun.Kaur] FOR LOGIN [LUMO\Sargun.Kaur] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [LUMO\Sargun.Kaur]
GO
