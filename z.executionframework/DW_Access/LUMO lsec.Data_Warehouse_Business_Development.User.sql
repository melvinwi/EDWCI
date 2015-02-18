USE [DW_Access]
GO
CREATE USER [LUMO\lsec.Data_Warehouse_Business_Development]
GO
ALTER ROLE [Customer_FullAccess] ADD MEMBER [LUMO\lsec.Data_Warehouse_Business_Development]
GO
ALTER ROLE [Financial_FullAccess] ADD MEMBER [LUMO\lsec.Data_Warehouse_Business_Development]
GO
