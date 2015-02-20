USE [DW_Staging]
GO
CREATE USER [LUMO\Melvin.Widodo] FOR LOGIN [LUMO\Melvin.Widodo] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [LUMO\Melvin.Widodo]
GO
