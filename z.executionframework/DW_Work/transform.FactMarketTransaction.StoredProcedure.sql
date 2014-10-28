USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [transform].[FactMarketTransaction]
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
    IF OBJECT_ID(N'tempdb..#FactMarketTransaction') IS NOT NULL 
		BEGIN 
			DROP TABLE #FactMarketTransaction 
		END

       CREATE TABLE #FactMarketTransaction
        ( [AccountId] [int] NULL,
	[ServiceId] [int] NULL,
	[ChangeReasonId] [int] NULL,
	[TransactionDateId] [int] NULL,
	[TransactionType] [nvarchar](100) NULL,
	[TransactionStatus] [nvarchar](100) NULL,
	[TransactionKey] [int] NULL,
	[ParticipantCode] [nvarchar](20) NULL,
	[NEMTransactionKey] [nvarchar](100) NULL,
	[NEMInitialTransactionKey] [nvarchar](100) NULL,
	[TransactionCounter] [tinyint] NULL
	      ) ;
    --/




    INSERT INTO #FactMarketTransaction (
    AccountId,
    ServiceId,
    ChangeReasonId,
    TransactionDateId,
    TransactionType,
    TransactionStatus,
    TransactionKey,
    ParticipantCode,
    NEMTransactionKey,
    NEMInitialTransactionKey,
    TransactionCounter) 
    SELECT
    ISNULL ( _DimAccount.AccountId , -1) ,
    ISNULL ( _DimService.ServiceId , -1) ,
    ISNULL ( _DimChangeReason.ChangeReasonId , -1) ,
    CONVERT (nchar (8) , ISNULL ( nem_transaction.trans_date , '9999-12-31') , 112) ,
    nem_transaction_type.trans_type_desc,
    nem_trans_status.trans_status_desc,
    nem_transaction.trans_id,
    nem_transaction.participant_code,
    nem_transaction.nem_trans_id,
    COALESCE(NULLIF( nem_transaction.nem_init_trans_id , ''), nem_transaction.nem_trans_id ),

    /* nem_transaction.trans_id */

    1
      FROM
           DW_Staging.orion.nem_transaction INNER JOIN DW_Staging.orion.nem_transaction_type
           ON nem_transaction_type.trans_type_id = nem_transaction.trans_type_id
                                            INNER JOIN DW_Staging.orion.nem_trans_status
           ON nem_trans_status.trans_status_id = nem_transaction.trans_status_id
                                            LEFT JOIN DW_Staging.orion.nc_product_item
           ON nc_product_item.seq_product_item_id = nem_transaction.seq_product_item_id
                                            LEFT JOIN DW_Staging.orion.nc_product
           ON nc_product.seq_product_id = nc_product_item.seq_product_id
                                            LEFT JOIN DW_Dimensional.DW.DimAccount AS _DimAccount
           ON _DimAccount.AccountKey = nc_product.seq_party_id
          AND _DimAccount.Meta_IsCurrent = 1
                                            LEFT JOIN DW_Dimensional.DW.DimService AS _DimService
           ON _DimService.ServiceKey = nem_transaction.site_id
          AND _DimService.Meta_IsCurrent = 1
                                            LEFT JOIN DW_Dimensional.DW.DimChangeReason AS _DimChangeReason
           ON _DimChangeReason.ChangeReasonKey = CASE WHEN nem_transaction.trans_type_id = 41 AND nem_transaction.xml_text LIKE '%<MoveInFlag>false%' THEN 72 ELSE nem_transaction.change_reason_id END
          AND _DimChangeReason.Meta_IsCurrent = 1
      WHERE nem_transaction.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
         OR nem_transaction_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
         OR nem_trans_status.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;




INSERT INTO temp.FactMarketTransaction (
    FactMarketTransaction.AccountId,
    FactMarketTransaction.ServiceId,
    FactMarketTransaction.ChangeReasonId,
    FactMarketTransaction.TransactionDateId,
    FactMarketTransaction.TransactionType,
    FactMarketTransaction.TransactionStatus,
    FactMarketTransaction.TransactionKey,
    FactMarketTransaction.ParticipantCode,
    FactMarketTransaction.NEMTransactionKey,
    FactMarketTransaction.NEMInitialTransactionKey,
    FactMarketTransaction.TransactionCounter) 
    SELECT  
    AccountId,
    ServiceId,
    ChangeReasonId,
    TransactionDateId,
    TransactionType,
    TransactionStatus,
    TransactionKey,
    ParticipantCode,
    NEMTransactionKey,
    NEMInitialTransactionKey,
    TransactionCounter
FROM    #FactMarketTransaction;




    SELECT 0 AS ExtractRowCount,
           @@ROWCOUNT AS InsertRowCount,
           0 AS UpdateRowCount,
           0 AS DeleteRowCount,
           0 AS ErrorRowCount;

END;


GO
