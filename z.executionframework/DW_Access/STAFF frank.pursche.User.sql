USE [DW_Access]
GO
CREATE USER [STAFF\frank.pursche] FOR LOGIN [STAFF\frank.pursche] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [Financial_FullAccess] ADD MEMBER [STAFF\frank.pursche]
GO
