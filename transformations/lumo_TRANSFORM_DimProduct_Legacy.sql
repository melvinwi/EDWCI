CREATE PROCEDURE lumo.TRANSFORM_DimProduct_Legacy
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
		DimProduct.ProductDesc,
		DimProduct.ProductType)
	  SELECT
		_Product.ProductKey,
		_Product.ProductName,
		_Product.ProductDesc,
		_Product.ProductType
	  FROM lumo.Product AS _Product;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;