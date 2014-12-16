USE [DW_Dimensional]
GO
CREATE USER [LUMO\Sally.Agombar] FOR LOGIN [LUMO\Sally.Agombar] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [LUMO\Sally.Agombar]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [LUMO\Sally.Agombar]
GO
