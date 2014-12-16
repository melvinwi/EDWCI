USE [DW_Dimensional]
GO
CREATE USER [LUMO\clinton.gadsden] FOR LOGIN [LUMO\clinton.gadsden] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [LUMO\clinton.gadsden]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [LUMO\clinton.gadsden]
GO
