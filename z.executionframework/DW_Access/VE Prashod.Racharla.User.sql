USE [DW_Access]
GO
CREATE USER [VE\Prashod.Racharla] FOR LOGIN [VE\Prashod.Racharla] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [Customer_FullAccess] ADD MEMBER [VE\Prashod.Racharla]
GO
ALTER ROLE [Financial_FullAccess] ADD MEMBER [VE\Prashod.Racharla]
GO
ALTER ROLE [DW_FullAccess] ADD MEMBER [VE\Prashod.Racharla]
GO
