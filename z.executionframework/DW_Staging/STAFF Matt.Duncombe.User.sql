USE [DW_Staging]
GO
CREATE USER [STAFF\Matt.Duncombe] FOR LOGIN [STAFF\Matt.Duncombe] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [STAFF\Matt.Duncombe]
GO
