USE [DW_Work]
GO

/****** Object:  StoredProcedure [transform].[DimProduct_TCO]    Script Date: 2/09/2014 12:12:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [transform].[DimProduct_TCO]
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
    CAST ( utl_total_customer_offering.tco_id AS nvarchar (30)) ,
    CAST ( utl_total_customer_offering.tco_desc AS nvarchar (100)) ,
    CAST ( utl_total_customer_offering.tco_desc AS nvarchar (100)) ,
    'TCO'
      FROM DW_Staging.orion.utl_total_customer_offering
      WHERE utl_total_customer_offering.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
        AND utl_total_customer_offering.tco_id != 1;

    SELECT 0 AS ExtractRowCount,
           @@ROWCOUNT AS InsertRowCount,
           0 AS UpdateRowCount,
           0 AS DeleteRowCount,
           0 AS ErrorRowCount;

END;

GO

