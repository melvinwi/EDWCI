USE [DW_Access]
GO
CREATE USER [LUMO\lsec.Data_Warehouse_Products_Sales]
GO
ALTER ROLE [Customer_FullAccess] ADD MEMBER [LUMO\lsec.Data_Warehouse_Products_Sales]
GO
ALTER ROLE [Financial_FullAccess] ADD MEMBER [LUMO\lsec.Data_Warehouse_Products_Sales]
GO
