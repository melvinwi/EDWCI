USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [transform].[TestContractDate]
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



    --Drop and create temporary table
    IF OBJECT_ID(N'tempdb..#ContractDate') IS NOT NULL 
		BEGIN 
			DROP TABLE #ContractDate
		END
		
    CREATE TABLE #ContractDate
        ( AccountKey           INT             NULL
	      , ContractDateId   INT             NULL
	      ) ;





INSERT INTO #ContractDate (
       AccountKey,
       ContractDateId)
SELECT DimAccount.AccountKey,
        MAX(s1.ContractStartDateId)

          FROM        DW_Dimensional.DW.FactContract s1 
          INNER JOIN  DW_Dimensional.DW.DimAccount
                      ON DimAccount.AccountId = s1.AccountId
          INNER JOIN  DW_Dimensional.DW.FactContract t1
                      ON s1.ContractStartDateId <= t1.ContractTerminatedDateId
                      AND NOT EXISTS (  SELECT 1
                                        FROM
                                             DW_Dimensional.DW.FactContract t2 INNER JOIN DW_Dimensional.DW.DimAccount
                                             ON DimAccount.AccountId = t2.AccountId
                                        WHERE t1.ContractTerminatedDateId >= t2.ContractStartDateId
                                          AND t1.ContractTerminatedDateId < t2.ContractTerminatedDateId
                                          AND DimAccount.AccountKey = s1.AccountId
                                      ) 
          WHERE NOT EXISTS (  SELECT 1
                                FROM
                                     DW_Dimensional.DW.FactContract s2 INNER JOIN DW_Dimensional.DW.DimAccount
                                     ON DimAccount.AccountId = s2.AccountId
                                WHERE s1.ContractStartDateId > s2.ContractStartDateId
                                  AND s1.ContractStartDateId <= s2.ContractTerminatedDateId
                                  AND DimAccount.AccountKey = s1.AccountId
                            ) 
          GROUP BY DimAccount.AccountKey;


INSERT INTO temp.ContractDate (
       ContractDate.AccountKey,
       ContractDate.ContractDateId)
	  SELECT  AccountKey			  
			    , ContractDateId
	  FROM    #ContractDate;

    SELECT 0 AS ExtractRowCount,
           @@ROWCOUNT AS InsertRowCount,
           0 AS UpdateRowCount,
           0 AS DeleteRowCount,
           0 AS ErrorRowCount;

END;


GO
