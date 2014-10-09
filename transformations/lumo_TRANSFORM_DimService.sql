CREATE PROCEDURE lumo.TRANSFORM_DimService
@TaskExecutionInstanceID INT
,@LatestSuccessfulTaskExecutionInstanceID INT
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

	;WITH meterDailyConsumption AS (SELECT utl_meter.site_id, SUM(utl_meter.est_daily_consumption) as est_daily_consumption, SUM(CASE WHEN utl_meter.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID THEN 1 ELSE 0 END) AS Meta_HasChanged FROM /* Staging */ lumo.utl_meter GROUP BY utl_meter.site_id)
	INSERT INTO lumo.DimService (
		DimService.ServiceKey,
		DimService.MarketIdentifier,
		DimService.ServiceType,
		DimService.LossFactor,
		DimService.EstimatedDailyConsumption,
		DimService.MeteringType,
		DimService.ResidentialSuburb,
		DimService.ResidentialPostcode,
		DimService.ResidentialState)
	  SELECT
		CAST( utl_site.site_id AS int),
		CAST( utl_site.site_identifier AS nvarchar(30)),
		CAST(CASE utl_site.seq_product_type_id WHEN '1' THEN 'Internet' WHEN '2' THEN 'Electricity' WHEN '3' THEN 'Gas' WHEN '7' THEN 'Telco' ELSE NULL END AS nvarchar(11)),
		COALESCE( utl_distrib_loss_factor_sched.dlf_factor ,1.0),
		COALESCE( _meterDailyConsumption.est_daily_consumption ,0.0),
		CAST(CASE utl_site.metering_type WHEN 'DEEMED' THEN 'Deemed' ELSE utl_site.metering_type END AS nchar(6)),
		CAST(UPPER( utl_site.addr_suburb ) AS nvarchar(100)),
		CAST( utl_site.addr_postcode AS nchar(4)),
		CAST( utl_site.addr_city AS nchar(3))
	  FROM lumo.utl_site LEFT JOIN lumo.utl_distrib_loss_factor_sched ON utl_distrib_loss_factor_sched.dlf_id = utl_site.dlf_id LEFT JOIN meterDailyConsumption AS _meterDailyConsumption on _meterDailyConsumption.site_id = utl_site.site_id WHERE utl_distrib_loss_factor_sched.start_date < GETDATE() AND ISNULL(utl_distrib_loss_factor_sched.end_date,'9999-12-31') > GETDATE() AND (utl_site.Meta_LatestUpdate_TaskExecutionInstanceId  > @LatestSuccessfulTaskExecutionInstanceID OR utl_distrib_loss_factor_sched.Meta_LatestUpdate_TaskExecutionInstanceId  > @LatestSuccessfulTaskExecutionInstanceID OR _meterDailyConsumption.Meta_HasChanged = 1);

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;