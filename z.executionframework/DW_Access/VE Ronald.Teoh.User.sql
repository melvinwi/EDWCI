USE [DW_Access]
GO
CREATE USER [VE\Ronald.Teoh] FOR LOGIN [VE\Ronald.Teoh] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [DW_FullAccess] ADD MEMBER [VE\Ronald.Teoh]
GO
