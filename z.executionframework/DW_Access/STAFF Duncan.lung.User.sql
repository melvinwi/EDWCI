USE [DW_Access]
GO
CREATE USER [STAFF\Duncan.lung] FOR LOGIN [STAFF\Duncan.lung] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [STAFF\Duncan.lung]
GO
