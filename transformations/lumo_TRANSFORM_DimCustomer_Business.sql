CREATE PROCEDURE lumo.TRANSFORM_DimCustomer_Business AS
BEGIN
	DELETE FROM lumo.DimCustomer;
	WITH contacts AS (SELECT crm_element_hierarchy.element_id, crm_element_hierarchy.parent_id, crm_party.title, crm_party.first_name, crm_party.initials, crm_party.last_name, crm_party.date_of_birth, ROW_NUMBER () OVER (PARTITION BY crm_element_hierarchy.parent_id ORDER BY crm_element_hierarchy.element_id ASC) AS RC FROM lumo.crm_element_hierarchy INNER JOIN lumo.crm_party ON crm_party.seq_party_id = crm_element_hierarchy.element_id INNER JOIN lumo.crm_party_flag ON crm_party_flag.seq_party_id = crm_party.seq_party_id WHERE crm_element_hierarchy.active = 'Y' AND crm_element_hierarchy.element_struct_code = 'CONTACT' AND crm_party_flag.seq_party_flag_type_id = '1') , customerStatus AS (SELECT nc_client.seq_party_id, MAX (CASE WHEN utl_account_status.accnt_status_class_id = 2 THEN 1 ELSE 0 END) AS CustomerStatus, MAX (CASE WHEN nc_client.Meta_ChangeFlag = 1 OR nc_product.Meta_ChangeFlag = 1 OR nc_product_item.Meta_ChangeFlag = 1 THEN 1 ELSE 0 END) AS Meta_ChangeFlag FROM lumo.nc_client LEFT OUTER JOIN lumo.nc_product ON nc_product.seq_party_id = nc_client.seq_party_id LEFT OUTER JOIN lumo.nc_product_item ON nc_product_item.seq_product_id = nc_product.seq_product_id LEFT OUTER JOIN lumo.utl_account_status ON utl_account_status.accnt_status_id = nc_product_item.accnt_status_id GROUP BY nc_client.seq_party_id)
	INSERT INTO lumo.DimCustomer (
		DimCustomer.CustomerCode,
		DimCustomer.CustomerKey,
		DimCustomer.Title,
		DimCustomer.Firstname,
		DimCustomer.MiddleInitial,
		DimCustomer.LastName,
		DimCustomer.PartyName,
		DimCustomer.PostalAddressLine1,
		DimCustomer.PostalSuburb,
		DimCustomer.PostalPostcode,
		DimCustomer.PostalState,
		DimCustomer.ResidentialAddressLine1,
		DimCustomer.ResidentialSuburb,
		DimCustomer.ResidentialPostcode,
		DimCustomer.ResidentialState,
		DimCustomer.PrimaryPhone,
		DimCustomer.PrimaryPhoneType,
		DimCustomer.SecondaryPhone,
		DimCustomer.SecondaryPhoneType,
		DimCustomer.MobilePhone,
		DimCustomer.Email,
		DimCustomer.DateOfBirth,
		DimCustomer.CustomerType,
		DimCustomer.CustomerStatus)
	  SELECT
		CASE WHEN ISNUMERIC (crm_party.party_code) = 1 THEN CAST ( crm_party.party_code AS int) END,
		CAST( nc_client.seq_party_id AS int),
		CAST( _contacts.title AS nchar(3)),
		CAST( _contacts.first_name AS nvarchar(100)),
		CAST( _contacts.initials AS nchar(10)),
		CAST( _contacts.last_name AS nvarchar(100)),
		CAST( crm_party.party_name AS nvarchar(100)),
		CAST( crm_party.postal_addr_1 AS nvarchar(100)),
		CAST( crm_party.postal_addr_2 AS nvarchar(50)),
		CAST( crm_party.postal_post_code AS nchar(4)),
		CAST( crm_party.postal_addr_3 AS nchar(3)),
		CAST( crm_party.street_addr_1 AS nvarchar(100)),
		CAST( crm_party.street_addr_2 AS nvarchar(50)),
		CAST( crm_party.street_post_code AS nchar(4)),
		CAST( crm_party.street_addr_3 AS nchar(3)),
		CAST(CONCAT( crm_party.std_code, crm_party.phone_no ) AS nvarchar(24)),
		CAST(CASE crm_party.primary_phone_type_id WHEN '1' THEN 'Landline' WHEN '2' THEN 'Mobile' ELSE NULL END AS nchar(8)),
		CAST(CONCAT( crm_party.secondary_std_code , crm_party.secondary_phone_no) AS nvarchar(24)),
		CAST(CASE crm_party.secondary_phone_type_id WHEN '1' THEN 'Landline' WHEN '2' THEN 'Mobile' ELSE NULL END AS nchar(8)),
		CAST(CASE WHEN LEFT( crm_party.std_code ,2) = '04' THEN CONCAT(crm_party.std_code, crm_party.phone_no) WHEN LEFT(crm_party.secondary_std_code,2) = '04' THEN CONCAT(crm_party.secondary_std_code, crm_party.secondary_phone_no) ELSE NULL END AS nchar(10)),
		CAST( crm_party.email_address AS nvarchar(100)),
		_contacts.date_of_birth,
		CAST(CASE crm_element_hierarchy.seq_element_type_id WHEN '9' THEN 'Residential' WHEN '8' THEN 'Business' ELSE NULL END AS nchar(11)),
		CAST(CASE _customerStatus.CustomerStatus WHEN 1 THEN 'Active' ELSE 'Inactive' END AS nchar(8))
	  FROM lumo.nc_client INNER JOIN lumo.crm_party ON nc_client.seq_party_id = crm_party.seq_party_id INNER JOIN lumo.crm_element_hierarchy ON crm_element_hierarchy.element_id = crm_party.seq_party_id INNER JOIN contacts AS _contacts ON _contacts.parent_id = nc_client.seq_party_id INNER JOIN customerStatus AS _customerStatus ON _customerStatus.seq_party_id = nc_client.seq_party_id WHERE crm_element_hierarchy.seq_element_type_id = '8'AND _contacts.RC = '1'AND (crm_party.Meta_ChangeFlag = 1 OR nc_client.Meta_ChangeFlag = 1 OR crm_element_hierarchy.Meta_ChangeFlag = 1 OR _customerStatus.Meta_ChangeFlag = 1);
SELECT @@ROWCOUNT AS InsertRowCount;
END;