USE [DW_Work]
GO
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
    DimProduct.ProductType,
    DimProduct.FixedTariffAdjustPercentage,
    DimProduct.VariableTariffAdjustPercentage) 
    SELECT
    _Product.ProductKey,
    _Product.ProductName,
    _Product.ProductDesc,
    _Product.ProductType,
    1.00,
    1.00
      FROM lookup.Product AS _Product;

    SELECT 0 AS ExtractRowCount,
           @@ROWCOUNT AS InsertRowCount,
           0 AS UpdateRowCount,
           0 AS DeleteRowCount,
           0 AS ErrorRowCount;

END;

GO
USE [DW_Work]
GO
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
    DimProduct.ProductType,
    DimProduct.FixedTariffAdjustPercentage,
    DimProduct.VariableTariffAdjustPercentage) 
    SELECT
    _Product.ProductKey,
    _Product.ProductName,
    _Product.ProductDesc,
    _Product.ProductType,
    1.00,
    1.00
      FROM lookup.Product AS _Product;

    SELECT 0 AS ExtractRowCount,
           @@ROWCOUNT AS InsertRowCount,
           0 AS UpdateRowCount,
           0 AS DeleteRowCount,
           0 AS ErrorRowCount;

END;

GO
