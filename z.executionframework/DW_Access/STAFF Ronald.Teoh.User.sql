USE [DW_Access]
GO
CREATE USER [STAFF\Ronald.Teoh] FOR LOGIN [STAFF\Ronald.Teoh] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [Financial_FullAccess] ADD MEMBER [STAFF\Ronald.Teoh]
GO
