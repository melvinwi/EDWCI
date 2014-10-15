CREATE PROCEDURE lumo.TRANSFORM_FactCustomerValue
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

	;WITH factCustomerValue AS (SELECT DimCustomer.CustomerCode, FactCustomerValue.ValueRating, row_number() OVER (PARTITION BY DimCustomer.CustomerCode ORDER BY FactCustomerValue.ValuationDateId DESC) AS recency FROM /* Dimensional */ lumo.DimCustomer INNER JOIN /* Dimensional */ lumo.FactCustomerValue ON FactCustomerValue.CustomerId = DimCustomer.CustomerId)
	INSERT INTO lumo.FactCustomerValue (
		FactCustomerValue.CustomerId,
		FactCustomerValue.ValuationDateId,
		FactCustomerValue.ValueRating)
	  SELECT
		_DimCustomer.CustomerId,
		/* _DimCustomer.CustomerId */ CONVERT(NCHAR(8), GETDATE(), 112),
		_vRetentionValueOld.Rating
	  FROM /* Access */ lumo.vRetentionValueOld AS _vRetentionValueOld INNER JOIN /* Dimensional */ lumo.DimCustomer AS _DimCustomer ON _DimCustomer.CustomerCode = _vRetentionValueOld.CustomerCode AND _DimCustomer.Meta_IsCurrent = 1 LEFT JOIN factCustomerValue ON factCustomerValue.CustomerCode = _DimCustomer.CustomerCode AND factCustomerValue.recency = 1 WHERE _vRetentionValueOld.Rating <> COALESCE(factCustomerValue.ValueRating, '');

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;