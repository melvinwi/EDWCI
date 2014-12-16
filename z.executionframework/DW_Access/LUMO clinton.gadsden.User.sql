USE [DW_Access]
GO
CREATE USER [LUMO\clinton.gadsden] FOR LOGIN [LUMO\clinton.gadsden] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [DW_FullAccess] ADD MEMBER [LUMO\clinton.gadsden]
GO
