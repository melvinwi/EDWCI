USE [DW_Access]
GO
CREATE USER [STAFF\prashod.racharla] FOR LOGIN [STAFF\prashod.racharla] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [Customer_FullAccess] ADD MEMBER [STAFF\prashod.racharla]
GO
ALTER ROLE [Financial_FullAccess] ADD MEMBER [STAFF\prashod.racharla]
GO
