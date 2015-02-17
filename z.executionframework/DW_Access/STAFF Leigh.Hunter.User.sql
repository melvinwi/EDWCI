USE [DW_Access]
GO
CREATE USER [STAFF\Leigh.Hunter] FOR LOGIN [STAFF\Leigh.Hunter] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [STAFF\Leigh.Hunter]
GO
