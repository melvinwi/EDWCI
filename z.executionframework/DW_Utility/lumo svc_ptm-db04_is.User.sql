USE [DW_Utility]
GO
CREATE USER [lumo\svc_ptm-db04_is] FOR LOGIN [lumo\svc_ptm-db04_is] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [lumo\svc_ptm-db04_is]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [lumo\svc_ptm-db04_is]
GO
