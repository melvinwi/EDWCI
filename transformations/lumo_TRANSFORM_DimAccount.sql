CREATE PROCEDURE lumo.TRANSFORM_DimAccount AS
BEGIN
	DELETE FROM lumo.DimAccount;
	WITH accountStatus AS (SELECT nc_client.seq_party_id, MAX (CASE WHEN utl_account_status.accnt_status_class_id = '2' THEN 1 ELSE 0 END) AS StatusOpen, MAX (CASE WHEN utl_account_status.accnt_status_class_id = '3' THEN 1 ELSE 0 END) AS StatusPending, MAX (CASE WHEN utl_account_status.accnt_status_class_id = '4' THEN 1 ELSE 0 END) AS StatusError, MAX (CASE WHEN nc_client.Meta_ChangeFlag = 1 OR nc_product.Meta_ChangeFlag = 1 OR nc_product_item.Meta_ChangeFlag = 1 THEN 1 ELSE 0 END) AS Meta_ChangeFlag FROM lumo.nc_client LEFT OUTER JOIN lumo.nc_product ON nc_product.seq_party_id = nc_client.seq_party_id LEFT OUTER JOIN lumo.nc_product_item ON nc_product_item.seq_product_id = nc_product.seq_product_id LEFT OUTER JOIN lumo.utl_account_status ON utl_account_status.accnt_status_id = nc_product_item.accnt_status_id GROUP BY nc_client.seq_party_id)
	INSERT INTO lumo.DimAccount (
		DimAccount.AccountCode,
		DimAccount.AccountKey,
		DimAccount.PostalAddressLine1,
		DimAccount.PostalSuburb,
		DimAccount.PostalPostcode,
		DimAccount.PostalState,
		DimAccount.MyAccountStatus,
		DimAccount.CreationDate,
		DimAccount.AccountStatus)
	  SELECT
		CASE WHEN ISNUMERIC (crm_party.party_code) = 1 THEN CAST( crm_party.party_code AS int) END,
		CAST( nc_client.seq_party_id AS int),
		CAST( crm_party.postal_addr_1 AS nvarchar(100)),
		CAST( crm_party.postal_addr_2 AS nvarchar(50)),
		CAST( crm_party.postal_post_code AS nchar(4)),
		CAST( crm_party.postal_addr_3 AS nchar(3)),
		CAST(CASE nc_client.cz_registered WHEN 'Y' THEN 'Registered' ELSE 'Not Registered' END AS nvarchar(14)),
		nc_client.insert_datetime,
		CAST (CASE WHEN _accountStatus.StatusOpen = 1 THEN 'Open' WHEN _accountStatus.StatusPending = 1 THEN 'Pending' WHEN _accountStatus.StatusError = 1 THEN 'Error' ELSE 'Closed' END AS nchar (10))
	  FROM lumo.nc_client INNER JOIN lumo.crm_party ON nc_client.seq_party_id = crm_party.seq_party_id INNER JOIN accountStatus AS _accountStatus ON _accountStatus.seq_party_id = nc_client.seq_party_id WHERE crm_party.Meta_ChangeFlag = 1 OR nc_client.Meta_ChangeFlag = 1 OR _accountStatus.Meta_ChangeFlag = 1;
SELECT @@ROWCOUNT AS InsertRowCount;
END;