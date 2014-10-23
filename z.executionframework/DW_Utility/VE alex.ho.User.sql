USE [DW_Utility]
GO
CREATE USER [VE\alex.ho] FOR LOGIN [VE\alex.ho] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [VE\alex.ho]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [VE\alex.ho]
GO
