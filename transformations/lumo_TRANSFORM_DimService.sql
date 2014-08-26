CREATE PROCEDURE lumo.TRANSFORM_DimService
@TaskExecutionInstanceID INT NULL
,@LatestSuccessfulTaskExecutionInstanceID INT NULL
AS
BEGIN

--Get LatestSuccessfulTaskExecutionInstanceID
IF  @LatestSuccessfulTaskExecutionInstanceID IS NULL
BEGIN
EXEC DW_Utility.config.GetLatestSuccessfulTaskExecutionInstanceID
@TaskExecutionInstanceID = @TaskExecutionInstanceID
, @LatestSuccessfulTaskExecutionInstanceID  = @LatestSuccessfulTaskExecutionInstanceID OUTPUT
END
--/

	INSERT INTO lumo.DimService (
		DimService.ServiceKey,
		DimService.MarketIdentifier,
		DimService.ServiceType)
	  SELECT
		CAST( utl_site.site_id AS int),
		CAST( utl_site.site_identifier AS nvarchar(30)),
		CAST(CASE utl_site.seq_product_type_id WHEN '1' THEN 'Internet' WHEN '2' THEN 'Electricity' WHEN '3' THEN 'Gas' WHEN '7' THEN 'Telco' ELSE NULL END AS nvarchar(11))
	  FROM lumo.utl_site WHERE utl_site.Meta_LatestUpdate_TaskExecutionInstanceId  >= @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;