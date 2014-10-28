USE [DW_Staging]
GO
CREATE USER [lumo\svc_ptm-db04_ag] FOR LOGIN [lumo\svc_ptm-db04_ag] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [lumo\svc_ptm-db04_ag]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [lumo\svc_ptm-db04_ag]
GO
ALTER ROLE [db_datareader] ADD MEMBER [lumo\svc_ptm-db04_ag]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [lumo\svc_ptm-db04_ag]
GO
