USE [DW_Access]
GO
CREATE USER [LUMO\Sally.Agombar] FOR LOGIN [LUMO\Sally.Agombar] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [DW_FullAccess] ADD MEMBER [LUMO\Sally.Agombar]
GO
