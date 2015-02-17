USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [transform].[DimFinancialAccount]
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

    INSERT INTO temp.DimFinancialAccount (
    DimFinancialAccount.FinancialAccountKey,
    DimFinancialAccount.FinancialAccountName,
    DimFinancialAccount.FinancialAccountType,
    DimFinancialAccount.Level1Name,
    DimFinancialAccount.Level2Name,
    DimFinancialAccount.Level3Name) 
    SELECT
    CAST ( ar_account.seq_account_id AS int) ,
    CAST ( ar_account.account_desc AS nvarchar (100)) ,
    CAST ( ar_account.dr_cr AS nchar (10)) ,
    CAST ( ar_account.account_desc AS nvarchar (100)) ,
    CAST ( ar_account_group.account_group_desc AS nvarchar (100)) ,

    /* ar_account.account_desc */

    N'Lumo Energy'
      FROM
           DW_Staging.orion.ar_account INNER JOIN DW_Staging.orion.ar_account_group
           ON ar_account_group.account_group_id = ar_account.account_group_id
      WHERE ar_account.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
         OR ar_account_group.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

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
CREATE PROCEDURE [transform].[DimFinancialAccount]
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

    INSERT INTO temp.DimFinancialAccount (
    DimFinancialAccount.FinancialAccountKey,
    DimFinancialAccount.FinancialAccountName,
    DimFinancialAccount.FinancialAccountType,
    DimFinancialAccount.Level1Name,
    DimFinancialAccount.Level2Name,
    DimFinancialAccount.Level3Name) 
    SELECT
    CAST ( ar_account.seq_account_id AS int) ,
    CAST ( ar_account.account_desc AS nvarchar (100)) ,
    CAST ( ar_account.dr_cr AS nchar (10)) ,
    CAST ( ar_account.account_desc AS nvarchar (100)) ,
    CAST ( ar_account_group.account_group_desc AS nvarchar (100)) ,

    /* ar_account.account_desc */

    N'Lumo Energy'
      FROM
           DW_Staging.orion.ar_account INNER JOIN DW_Staging.orion.ar_account_group
           ON ar_account_group.account_group_id = ar_account.account_group_id
      WHERE ar_account.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
         OR ar_account_group.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

    SELECT 0 AS ExtractRowCount,
           @@ROWCOUNT AS InsertRowCount,
           0 AS UpdateRowCount,
           0 AS DeleteRowCount,
           0 AS ErrorRowCount;

END;

GO
