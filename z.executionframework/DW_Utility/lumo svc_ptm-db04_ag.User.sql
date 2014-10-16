USE [DW_Utility]
GO
/****** Object:  User [lumo\svc_ptm-db04_ag]    Script Date: 16/10/2014 7:18:29 PM ******/
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
