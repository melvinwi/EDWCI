USE [DW_Access]
GO
CREATE USER [VE\Frank.Pursche] FOR LOGIN [VE\Frank.Pursche] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [DW_FullAccess] ADD MEMBER [VE\Frank.Pursche]
GO
