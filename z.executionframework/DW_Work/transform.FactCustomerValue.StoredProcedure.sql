USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [transform].[FactCustomerValue]
    @TaskExecutionInstanceID INT
  , @LatestSuccessfulTaskExecutionInstanceID INT
AS
BEGIN

--Get LatestSuccessfulTaskExecutionInstanceID
IF  @LatestSuccessfulTaskExecutionInstanceID IS NULL
  BEGIN
    EXEC  DW_Utility.config.GetLatestSuccessfulTaskExecutionInstanceID
          @TaskExecutionInstanceID = @TaskExecutionInstanceID
        , @LatestSuccessfulTaskExecutionInstanceID  = @LatestSuccessfulTaskExecutionInstanceID OUTPUT
  END
--/

	;WITH cte_factCustomerValue AS  ( SELECT      DimCustomer.CustomerCode
                                              , FactCustomerValue.ValueRating
                                              , row_number() OVER (PARTITION BY DimCustomer.CustomerCode ORDER BY FactCustomerValue.ValuationDateId DESC) AS recency 
                                    FROM        DW_Dimensional.DW.DimCustomer 
                                    INNER JOIN  DW_Dimensional.DW.FactCustomerValue 
                                                ON FactCustomerValue.CustomerId = DimCustomer.CustomerId
                                  )

  INSERT INTO temp.FactCustomerValue  ( CustomerId
                                      , ValuationDateId
                                      , ValueRating
                                      )
  SELECT      _DimCustomer.CustomerId
            , CONVERT(NCHAR(8), GETDATE(), 112)
            , _vRetentionValueOld.Rating

  FROM        DW_Access.[Views].vRetentionValueOld  AS _vRetentionValueOld 
  INNER JOIN  DW_Dimensional.DW.DimCustomer         AS _DimCustomer 
              ON  _DimCustomer.CustomerCode = _vRetentionValueOld.CustomerCode 
              AND _DimCustomer.Meta_IsCurrent = 1 
  LEFT JOIN   cte_factCustomerValue 
              ON  cte_factCustomerValue.CustomerCode = _DimCustomer.CustomerCode 
              AND cte_factCustomerValue.recency = 1 
  WHERE       _vRetentionValueOld.Rating <> ISNULL(cte_factCustomerValue.ValueRating, '')
;

SELECT  0 AS ExtractRowCount
      , @@ROWCOUNT AS InsertRowCount
      , 0 AS UpdateRowCount
      , 0 AS DeleteRowCount
      , 0 AS ErrorRowCount;

END;
GO
USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [transform].[FactCustomerValue]
    @TaskExecutionInstanceID INT
  , @LatestSuccessfulTaskExecutionInstanceID INT
AS
BEGIN

--Get LatestSuccessfulTaskExecutionInstanceID
IF  @LatestSuccessfulTaskExecutionInstanceID IS NULL
  BEGIN
    EXEC  DW_Utility.config.GetLatestSuccessfulTaskExecutionInstanceID
          @TaskExecutionInstanceID = @TaskExecutionInstanceID
        , @LatestSuccessfulTaskExecutionInstanceID  = @LatestSuccessfulTaskExecutionInstanceID OUTPUT
  END
--/

	;WITH cte_factCustomerValue AS  ( SELECT      DimCustomer.CustomerCode
                                              , FactCustomerValue.ValueRating
                                              , row_number() OVER (PARTITION BY DimCustomer.CustomerCode ORDER BY FactCustomerValue.ValuationDateId DESC) AS recency 
                                    FROM        DW_Dimensional.DW.DimCustomer 
                                    INNER JOIN  DW_Dimensional.DW.FactCustomerValue 
                                                ON FactCustomerValue.CustomerId = DimCustomer.CustomerId
                                  )

  INSERT INTO temp.FactCustomerValue  ( CustomerId
                                      , ValuationDateId
                                      , ValueRating
                                      )
  SELECT      _DimCustomer.CustomerId
            , CONVERT(NCHAR(8), GETDATE(), 112)
            , _vRetentionValueOld.Rating

  FROM        DW_Access.[Views].vRetentionValueOld  AS _vRetentionValueOld 
  INNER JOIN  DW_Dimensional.DW.DimCustomer         AS _DimCustomer 
              ON  _DimCustomer.CustomerCode = _vRetentionValueOld.CustomerCode 
              AND _DimCustomer.Meta_IsCurrent = 1 
  LEFT JOIN   cte_factCustomerValue 
              ON  cte_factCustomerValue.CustomerCode = _DimCustomer.CustomerCode 
              AND cte_factCustomerValue.recency = 1 
  WHERE       _vRetentionValueOld.Rating <> ISNULL(cte_factCustomerValue.ValueRating, '')
;

SELECT  0 AS ExtractRowCount
      , @@ROWCOUNT AS InsertRowCount
      , 0 AS UpdateRowCount
      , 0 AS DeleteRowCount
      , 0 AS ErrorRowCount;

END;

GO
