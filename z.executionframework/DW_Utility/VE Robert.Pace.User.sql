USE [DW_Utility]
GO
CREATE USER [VE\Robert.Pace] FOR LOGIN [VE\Robert.Pace] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [VE\Robert.Pace]
GO
