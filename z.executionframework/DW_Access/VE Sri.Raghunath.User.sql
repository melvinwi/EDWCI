USE [DW_Access]
GO
CREATE USER [VE\Sri.Raghunath] FOR LOGIN [VE\Sri.Raghunath] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [DW_FullAccess] ADD MEMBER [VE\Sri.Raghunath]
GO
ALTER ROLE [db_datareader] ADD MEMBER [VE\Sri.Raghunath]
GO
