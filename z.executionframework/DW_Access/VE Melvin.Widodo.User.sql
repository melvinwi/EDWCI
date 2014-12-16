USE [DW_Access]
GO
CREATE USER [VE\Melvin.Widodo] FOR LOGIN [VE\Melvin.Widodo] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [VE\Melvin.Widodo]
GO
