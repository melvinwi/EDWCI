USE [DW_Access]
GO
CREATE USER [VE\Tom.Hurst] FOR LOGIN [VE\Tom.Hurst] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [Customer_FullAccess] ADD MEMBER [VE\Tom.Hurst]
GO
ALTER ROLE [Financial_FullAccess] ADD MEMBER [VE\Tom.Hurst]
GO
ALTER ROLE [DW_FullAccess] ADD MEMBER [VE\Tom.Hurst]
GO
