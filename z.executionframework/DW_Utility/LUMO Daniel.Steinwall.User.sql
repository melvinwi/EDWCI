USE [DW_Utility]
GO
CREATE USER [LUMO\Daniel.Steinwall] FOR LOGIN [LUMO\Daniel.Steinwall] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [LUMO\Daniel.Steinwall]
GO
