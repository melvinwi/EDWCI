USE [DW_Work]
GO

/****** Object:  StoredProcedure [transform].[DimProduct_Legacy]    Script Date: 2/09/2014 12:11:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [transform].[DimProduct_Legacy]
@TaskExecutionInstanceID int
,
@LatestSuccessfulTaskExecutionInstanceID int
AS
BEGIN

    --Get LatestSuccessfulTaskExecutionInstanceID
    IF  @LatestSuccessfulTaskExecutionInstanceID IS NULL
        BEGIN
            EXEC DW_Utility.config.GetLatestSuccessfulTaskExecutionInstanceID
            @TaskExecutionInstanceID = @TaskExecutionInstanceID
            , @LatestSuccessfulTaskExecutionInstanceID = @LatestSuccessfulTaskExecutionInstanceID OUTPUT;
        END;
    --/

    INSERT INTO temp.DimProduct (
    DimProduct.ProductKey,
    DimProduct.ProductName,
    DimProduct.ProductDesc,
    DimProduct.ProductType) 
    SELECT
    Product.ProductKey,
    Product.ProductName,
    Product.ProductDesc,
    Product.ProductType
      FROM DW_Staging.staticload.Product
      WHERE Product.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

    SELECT 0 AS ExtractRowCount,
           @@ROWCOUNT AS InsertRowCount,
           0 AS UpdateRowCount,
           0 AS DeleteRowCount,
           0 AS ErrorRowCount;

END;

GO

