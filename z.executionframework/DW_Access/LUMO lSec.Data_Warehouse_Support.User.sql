USE [DW_Access]
GO
CREATE USER [LUMO\lSec.Data_Warehouse_Support]
GO
ALTER ROLE [db_datareader] ADD MEMBER [LUMO\lSec.Data_Warehouse_Support]
GO
