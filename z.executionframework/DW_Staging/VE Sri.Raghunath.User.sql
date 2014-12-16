USE [DW_Staging]
GO
CREATE USER [VE\Sri.Raghunath] FOR LOGIN [VE\Sri.Raghunath] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [VE\Sri.Raghunath]
GO
