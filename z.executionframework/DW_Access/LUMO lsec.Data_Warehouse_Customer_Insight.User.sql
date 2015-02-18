USE [DW_Access]
GO
CREATE USER [LUMO\lsec.Data_Warehouse_Customer_Insight]
GO
ALTER ROLE [Customer_FullAccess] ADD MEMBER [LUMO\lsec.Data_Warehouse_Customer_Insight]
GO
ALTER ROLE [Financial_FullAccess] ADD MEMBER [LUMO\lsec.Data_Warehouse_Customer_Insight]
GO
