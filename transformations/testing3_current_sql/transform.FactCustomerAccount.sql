USE [DW_Work]
GO

/****** Object:  StoredProcedure [transform].[FactCustomerAccount]    Script Date: 27/08/2014 12:57:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [transform].[FactCustomerAccount]
                @TaskExecutionInstanceID                  INT
              , @LatestSuccessfulTaskExecutionInstanceID  INT
AS

  /*
  Schema            :   transform
  Object            :   FactCustomerAccount
  Author            :   Matt Duncombe
  Created Date      :   20.08.2014
  Description       :   Expire active records in FactCustomerAccount that relate to expired records in DimCustomer or DimAccount, 
                        and add new records to FactCustomerAccount that relate to any unrepresented relationships
                        (FactCustomerAccount relationships are determined exclusively by the data in DimCustomer and DimAccount.)

  Change  History   : 
  Author  Date          Description of Change
  JG      26.08.2014    Added this header
                        Added default RowCount outputs and parameters
  <YOUR ROW HERE>     
  
  Usage:
        EXEC  transform.FactCustomerAccount
                @TaskExecutionInstanceID = 0
              , @LatestSuccessfulTaskExecutionInstanceID = -1

  --to do:  consider whether EffectiveEndDate in FactCustomerAccount should be based on EffectiveEndDate in DimCustomer / DimAccount, rather than GETDATE()
            consider whether FactCustomerAccount records may be set to expire in advance (e.g. end date of a contract), 
             - if so, the SQL {FactCustomerAccount.EffectiveEndDate = '99991231'} would need to be amended
  */

BEGIN

  DECLARE @UpdateRowCount INT = 0;

  --Get LatestSuccessfulTaskExecutionInstanceID
  IF  @LatestSuccessfulTaskExecutionInstanceID  IS NULL
    BEGIN
      EXEC  DW_Utility.config.GetLatestSuccessfulTaskExecutionInstanceID
                @TaskExecutionInstanceID                  = @TaskExecutionInstanceID
              , @LatestSuccessfulTaskExecutionInstanceID  = @LatestSuccessfulTaskExecutionInstanceID OUTPUT
    END
  --/

  --For rows in FactCustomerAccount with an end date of 99991231,
    --if the CustomerId is not set to Meta_IsCurrent in DimCustomer,
    --or if the AccountId is not set to Meta_IsCurrent in DimAccount,
    --set the end date to today
  UPDATE          [DW_Dimensional].[DW].FactCustomerAccount
  
  SET             EffectiveEndDate = CONVERT(NCHAR(8), GETDATE (), 112)
                , Meta_LatestUpdate_TaskExecutionInstanceId = @TaskExecutionInstanceId

  FROM            [DW_Dimensional].[DW].FactCustomerAccount 
  LEFT OUTER JOIN [DW_Dimensional].[DW].DimCustomer
            ON    FactCustomerAccount.CustomerId = DimCustomer.CustomerId
  LEFT OUTER JOIN [DW_Dimensional].[DW].DimAccount
            ON    FactCustomerAccount.AccountId = DimAccount.AccountId

  WHERE           FactCustomerAccount.EffectiveEndDate = '99991231'
            AND   (   ISNULL(DimCustomer.Meta_IsCurrent , 0)  = 0
                  OR  ISNULL(DimAccount.Meta_IsCurrent  , 0)  = 0
                  )
            AND   (   DimCustomer.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
                  OR  DimAccount.Meta_LatestUpdate_TaskExecutionInstanceId  > @LatestSuccessfulTaskExecutionInstanceID
                  )
            ;

  SET   @UpdateRowCount = @@ROWCOUNT;
  --/

  --For each current row in DimAccount that relates to a current rows in DimCustomer, 
    --but not to a record in FactCustomerAccount with an end date of 99991231,
    --then insert a new record (looking up the customer Id from DimCustomer and the account Id from DimAccount)
  INSERT INTO     [DW_Dimensional].[DW].FactCustomerAccount 
                ( CustomerId
                , AccountId
                , EffectiveStartDate
                , EffectiveEndDate
                , AccountRelationshipCounter
					      , Meta_Insert_TaskExecutionInstanceId
					      , Meta_LatestUpdate_TaskExecutionInstanceId
                ) 
  SELECT          DimCustomer.CustomerId
                , DimAccount.AccountId
                , CONVERT(NCHAR(8), GETDATE (), 112)
                , '99991231'
                , 1
                , @TaskExecutionInstanceId
                , @TaskExecutionInstanceId

  FROM            DW_Dimensional.DW.DimAccount 
  INNER JOIN      DW_Dimensional.DW.DimCustomer
            ON    DimCustomer.CustomerCode = DimAccount.AccountCode
  LEFT OUTER JOIN DW_Dimensional.DW.FactCustomerAccount
            ON    FactCustomerAccount.AccountId = DimAccount.AccountId
  
  WHERE           DimCustomer.Meta_IsCurrent  = 1
            AND   DimAccount.Meta_IsCurrent   = 1
            AND   (   DimCustomer.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
                  OR  DimAccount.Meta_LatestUpdate_TaskExecutionInstanceId  > @LatestSuccessfulTaskExecutionInstanceID
                  )
  
  GROUP BY        DimCustomer.CustomerId
                , DimAccount.AccountId
  HAVING          MAX(ISNULL(FactCustomerAccount.EffectiveEndDate,1)) <> '99991231';
  --/

  --Default RowCount output
  SELECT          0               AS  ExtractRowCount
                , @@ROWCOUNT      AS  InsertRowCount
                , @UpdateRowCount AS  UpdateRowCount
                , 0               AS  DeleteRowCount
                , 0               AS  ErrorRowCount
                ;
  --/
END;

GO


