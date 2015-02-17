USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [transform].[FactCustomerAccount]
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
    
        INSERT INTO temp.FactCustomerAccount (
        FactCustomerAccount.CustomerId,
	   FactCustomerAccount.AccountId,
	   FactCustomerAccount.AccountRelationshipCounter) 
        SELECT
	   _DimCustomer.CustomerId,
        _DimAccount.AccountId,
        1 FROM DW_Dimensional.DW.DimAccount AS _DimAccount
          INNER JOIN DW_Dimensional.DW.DimCustomer AS _DimCustomer
               ON _DimAccount.AccountKey = _DimCustomer.CustomerKey
          WHERE _DimCustomer.Meta_IsCurrent = 1
            AND _DimAccount.Meta_IsCurrent = 1
            AND (_DimCustomer.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
              OR _DimAccount.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID);

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

CREATE PROCEDURE [transform].[FactCustomerAccount]
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
    
        INSERT INTO temp.FactCustomerAccount (
        FactCustomerAccount.CustomerId,
	   FactCustomerAccount.AccountId,
	   FactCustomerAccount.AccountRelationshipCounter) 
        SELECT
	   _DimCustomer.CustomerId,
        _DimAccount.AccountId,
        1 FROM DW_Dimensional.DW.DimAccount AS _DimAccount
          INNER JOIN DW_Dimensional.DW.DimCustomer AS _DimCustomer
               ON _DimAccount.AccountKey = _DimCustomer.CustomerKey
          WHERE _DimCustomer.Meta_IsCurrent = 1
            AND _DimAccount.Meta_IsCurrent = 1
            AND (_DimCustomer.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
              OR _DimAccount.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID);

    SELECT 0 AS ExtractRowCount,
           @@ROWCOUNT AS InsertRowCount,
           0 AS UpdateRowCount,
           0 AS DeleteRowCount,
           0 AS ErrorRowCount;

END;

GO
