USE [DW_Access]
GO
CREATE USER [LUMO\lSec.Data_Warehouse_Marketing]
GO
ALTER ROLE [Customer_FullAccess] ADD MEMBER [LUMO\lSec.Data_Warehouse_Marketing]
GO
ALTER ROLE [Financial_FullAccess] ADD MEMBER [LUMO\lSec.Data_Warehouse_Marketing]
GO
