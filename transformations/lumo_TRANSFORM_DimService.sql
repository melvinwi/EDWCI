CREATE PROCEDURE lumo.TRANSFORM_DimService AS
BEGIN
	INSERT INTO lumo.DimService (
		DimService.ServiceKey,
		DimService.MarketIdentifier,
		DimService.ServiceType)
	  SELECT
		CAST( utl_site.site_id AS int),
		CAST( utl_site.site_identifier AS nvarchar(30)),
		CAST(CASE utl_site.seq_product_type_id WHEN '1' THEN 'Internet' WHEN '2' THEN 'Electricity' WHEN '3' THEN 'Gas' WHEN '7' THEN 'Telco' ELSE NULL END AS nvarchar(11))
	  FROM lumo.utl_site WHERE utl_site.Meta_ChangeFlag = 1;
SELECT @@ROWCOUNT AS InsertRowCount;
END;