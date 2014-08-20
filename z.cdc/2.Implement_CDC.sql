Use Orion_VE;
exec sp_cdc_enable_db

select is_cdc_enabled,* from sys.databases
Go
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name   = N'ar_aged_debtor_balance',
@role_name     = N'orion_ve_cdc_access',
@filegroup_name = N'FG_CDC',
@supports_net_changes = 1
GO
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name   = N'crm_element_hierarchy',
@role_name     = N'orion_ve_cdc_access',
@filegroup_name = N'FG_CDC'
GO
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name   = N'crm_party',
@role_name     = N'orion_ve_cdc_access',
@filegroup_name = N'FG_CDC',
@supports_net_changes = 1
GO
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name   = N'crm_party_flag',
@role_name     = N'orion_ve_cdc_access',
@filegroup_name = N'FG_CDC',
@supports_net_changes = 1
GO
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name   = N'nc_client',
@role_name     = N'orion_ve_cdc_access',
@filegroup_name = N'FG_CDC',
@supports_net_changes = 1
GO
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name   = N'nc_product',
@role_name     = N'orion_ve_cdc_access',
@filegroup_name = N'FG_CDC',
@supports_net_changes = 1
GO
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name   = N'nc_product_item',
@role_name     = N'orion_ve_cdc_access',
@filegroup_name = N'FG_CDC',
@supports_net_changes = 1
GO
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name   = N'utl_meter',
@role_name     = N'orion_ve_cdc_access',
@filegroup_name = N'FG_CDC',
@supports_net_changes = 1
GO
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name   = N'utl_meter_header',
@role_name     = N'orion_ve_cdc_access',
@filegroup_name = N'FG_CDC',
@supports_net_changes = 1
GO
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name   = N'utl_site',
@role_name     = N'orion_ve_cdc_access',
@filegroup_name = N'FG_CDC',
@supports_net_changes = 1
GO
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name   = N'utl_account_status',
@role_name     = N'orion_ve_cdc_access',
@filegroup_name = N'FG_CDC',
@supports_net_changes = 1
GO
