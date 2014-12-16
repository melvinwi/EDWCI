USE [DW_Access]
GO
CREATE USER [VE\Daniel.Steinwall] FOR LOGIN [VE\Daniel.Steinwall] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [VE\Daniel.Steinwall]
GO
