CREATE PROCEDURE lumo.TRANSFORM_DimContractDetails
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

	INSERT INTO lumo.DimContractDetails (
		DimContractDetails.ContractDetailsKey,
		DimContractDetails.ContractStatus,
		DimContractDetails.ContractDetailedStatus)
	  SELECT
		CAST( nc_product_item.seq_product_item_id AS int),
		CAST(CASE utl_account_status.accnt_status_class_id WHEN 2 THEN N'Open' WHEN 3 THEN N'Pending' WHEN 4 THEN N'Error' ELSE N'Closed' END AS nchar(10)),
		CAST( utl_account_status.accnt_status_desc AS nvarchar(50))
	  FROM /* Staging */ lumo.nc_product_item LEFT JOIN /* Staging */ lumo.utl_account_status ON utl_account_status.accnt_status_id = nc_product_item.accnt_status_id WHERE nc_product_item.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR utl_account_status.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;