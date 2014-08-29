CREATE PROCEDURE lumo.TRANSFORM_DimProduct
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

	INSERT INTO lumo.DimProduct (
		DimProduct.ProductKey,
		DimProduct.ProductName,
		DimProduct.ProductDesc)
	  SELECT
		Product.ProductKey,
		Product.ProductName,
		Product.ProductDesc
	  FROM lumo.Product WHERE Product.Meta_LatestUpdate_TaskExecutionInstanceId  > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;