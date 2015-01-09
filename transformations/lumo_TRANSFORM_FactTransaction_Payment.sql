CREATE PROCEDURE lumo.TRANSFORM_FactTransaction_Payment
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

	INSERT INTO lumo.FactTransaction (
		FactTransaction.AccountId,
		FactTransaction.ServiceId,
		FactTransaction.ProductId,
		FactTransaction.FinancialAccountId,
		FactTransaction.TransactionDateId,
		FactTransaction.VersionId,
		FactTransaction.UnitTypeId,
		FactTransaction.Units,
		FactTransaction.Value,
		FactTransaction.Currency,
		FactTransaction.Tax,
		FactTransaction.TransactionType,
		FactTransaction.TransactionDesc,
		FactTransaction.TransactionKey,
		FactTransaction.MeterRegisterId,
		FactTransaction.TransactionSubtype,
		FactTransaction.Reversal,
		FactTransaction.Reversed,
		FactTransaction.StartRead,
		FactTransaction.EndRead,
		FactTransaction.StartDateId,
		FactTransaction.EndDateId,
		FactTransaction.AccountingPeriod)
	  SELECT
		_DimAccount.AccountId,
		/* ar_receipt.seq_rcpt_id */ -1,
		/* ar_receipt.seq_rcpt_id */ -1,
		COALESCE( _DimFinancialAccount.FinancialAccountId , -1),
		CONVERT(NCHAR(8), COALESCE( ar_receipt.rcpt_date , '9999-12-31'), 112),
		COALESCE( _DimVersion.VersionId , -1),
		/* ar_receipt.seq_rcpt_id */ -1,
		/* ar_receipt.seq_rcpt_id */ 0,
		-1 * ar_receipt.rcpt_amount,
		/* ar_receipt.seq_rcpt_id */ N'AUD',
		/* ar_receipt.seq_rcpt_id */ 0,
		/* ar_receipt.seq_rcpt_id */ N'Payments',
		'Payment - ' + ar_receipt_batch_type.rcpt_batch_type_desc,
		'PAY' + CAST( ar_receipt.seq_rcpt_id AS NVARCHAR(11)),
		/* ar_receipt.seq_rcpt_id */ -1,
		CAST( ar_receipt_batch_type.rcpt_batch_type_desc AS nvarchar(30)),
		/* ar_receipt.seq_rcpt_id */ N'No ',
		/* ar_receipt.seq_rcpt_id */ N'No ',
		/* ar_receipt.seq_rcpt_id */ 0,
		/* ar_receipt.seq_rcpt_id */ 0,
		/* ar_receipt.seq_rcpt_id */ 99991231,
		/* ar_receipt.seq_rcpt_id */ 99991231,
		ar_receipt.seq_accounting_period_id
	  FROM /* Staging */ lumo.ar_receipt INNER JOIN /* Staging */ lumo.ar_receipt_batch ON ar_receipt_batch.seq_rcpt_batch_id = ar_receipt.seq_rcpt_batch_id INNER JOIN /* Staging */ lumo.ar_receipt_batch_type ON ar_receipt_batch_type.seq_rcpt_batch_type_id = ar_receipt_batch.seq_rcpt_batch_type_id INNER JOIN /* Dimensional */ lumo.DimAccount AS _DimAccount ON _DimAccount.AccountKey = ar_receipt.seq_party_id AND _DimAccount.Meta_IsCurrent = 1 INNER JOIN /* Staging */ lumo.nc_client ON nc_client.seq_party_id = ar_receipt.seq_party_id INNER JOIN /* Staging */ lumo.crm_element_hierarchy ON crm_element_hierarchy.element_id = nc_client.seq_party_id AND crm_element_hierarchy.element_struct_code = 'CLIENT' INNER JOIN /* Staging */ lumo.crm_party_type ON crm_party_type.seq_party_type_id = crm_element_hierarchy.seq_element_type_id AND crm_party_type.party_type <> 'SUBCLIENT'LEFT JOIN /* Dimensional */ lumo.DimFinancialAccount AS _DimFinancialAccount ON _DimFinancialAccount.FinancialAccountKey = 10 AND _DimFinancialAccount.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimVersion AS _DimVersion ON _DimVersion.VersionKey = N'Actual' WHERE ar_receipt.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID AND ar_receipt.seq_accounting_period_id IS NOT NULL;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;