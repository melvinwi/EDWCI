CREATE PROCEDURE lumo.TRANSFORM_FactMarketTransaction
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

	INSERT INTO lumo.FactMarketTransaction (
		FactMarketTransaction.AccountId,
		FactMarketTransaction.ServiceId,
		FactMarketTransaction.ChangeReasonId,
		FactMarketTransaction.TransactionDateId,
		FactMarketTransaction.TransactionTime,
		FactMarketTransaction.TransactionType,
		FactMarketTransaction.TransactionStatus,
		FactMarketTransaction.TransactionKey,
		FactMarketTransaction.ParticipantCode,
		FactMarketTransaction.NEMTransactionKey,
		FactMarketTransaction.NEMInitialTransactionKey,
		FactMarketTransaction.TransactionCounter)
	  SELECT
		ISNULL( _DimAccount.AccountId ,-1),
		ISNULL( _DimService.ServiceId ,-1),
		ISNULL( _DimChangeReason.ChangeReasonId ,-1),
		CONVERT(NCHAR(8), ISNULL( nem_transaction.trans_date , '9999-12-31'), 112),
		CAST(ISNULL( nem_transaction.trans_date , '9999-12-31') AS TIME),
		nem_transaction_type.trans_type_desc,
		nem_trans_status.trans_status_desc,
		nem_transaction.trans_id,
		nem_transaction.participant_code,
		nem_transaction.nem_trans_id,
		COALESCE(NULLIF( nem_transaction.nem_init_trans_id , ''), nem_transaction.nem_trans_id ),
		/* nem_transaction.trans_id */ 1
	  FROM /* Staging */ lumo.nem_transaction INNER JOIN /* Staging */ lumo.nem_transaction_type ON nem_transaction_type.trans_type_id = nem_transaction.trans_type_id INNER JOIN /* Staging */ lumo.nem_trans_status ON nem_trans_status.trans_status_id = nem_transaction.trans_status_id LEFT JOIN /* Staging */ lumo.nc_product_item ON nc_product_item.seq_product_item_id = nem_transaction.seq_product_item_id LEFT JOIN /* Staging */ lumo.nc_product ON nc_product.seq_product_id = nc_product_item.seq_product_id LEFT JOIN /* Dimensional */ lumo.DimAccount AS _DimAccount ON _DimAccount.AccountKey = nc_product.seq_party_id AND _DimAccount.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimService AS _DimService ON _DimService.ServiceKey = nem_transaction.site_id AND _DimService.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimChangeReason AS _DimChangeReason ON _DimChangeReason.ChangeReasonKey = nem_transaction.change_reason_id AND _DimChangeReason.Meta_IsCurrent = 1 WHERE nem_transaction.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR nem_transaction_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR nem_trans_status.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;