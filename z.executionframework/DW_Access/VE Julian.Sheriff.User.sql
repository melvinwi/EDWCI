USE [DW_Access]
GO
CREATE USER [VE\Julian.Sheriff] FOR LOGIN [VE\Julian.Sheriff] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [Customer_FullAccess] ADD MEMBER [VE\Julian.Sheriff]
GO
ALTER ROLE [Financial_FullAccess] ADD MEMBER [VE\Julian.Sheriff]
GO
ALTER ROLE [DW_FullAccess] ADD MEMBER [VE\Julian.Sheriff]
GO
