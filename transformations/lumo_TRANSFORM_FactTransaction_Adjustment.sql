CREATE PROCEDURE lumo.TRANSFORM_FactTransaction_Adjustment
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

	;WITH maxRate AS (SELECT ar_adjust.seq_ar_adjust_id, MAX(nc_tax_rate_history.tax_rate_history_id) AS tax_rate_history_id, MAX(nc_tax_rate_history.Meta_LatestUpdate_TaskExecutionInstanceId) AS Meta_LatestUpdate_TaskExecutionInstanceId FROM /* Staging */ lumo.ar_adjust CROSS JOIN /* Staging */ lumo.nc_tax_rate_history WHERE ar_adjust.posted_date BETWEEN nc_tax_rate_history.start_date AND COALESCE(nc_tax_rate_history.end_date, '9999-12-31') GROUP BY ar_adjust.seq_ar_adjust_id, ar_adjust.posted_date), taxRate AS (SELECT maxRate.seq_ar_adjust_id, maxRate.Meta_LatestUpdate_TaskExecutionInstanceId, nc_tax_rate_history.tax_rate FROM maxRate INNER JOIN /* Staging */ lumo.nc_tax_rate_history ON nc_tax_rate_history.tax_rate_history_id = maxRate.tax_rate_history_id)
	INSERT INTO lumo.FactTransaction (
		FactTransaction.AccountId,
		FactTransaction.ServiceId,
		FactTransaction.Productid,
		FactTransaction.FinancialAccountId,
		FactTransaction.TransactionDateId,
		FactTransaction.VersionId,
		FactTransaction.UnitTypeId,
		FactTransaction.Units,
		FactTransaction.Value,
		FactTransaction.Currency,
		FactTransaction.Tax,
		FactTransaction.TransactionDesc,
		FactTransaction.TransactionKey)
	  SELECT
		_DimAccount.AccountId,
		/* ar_adjust.seq_ar_adjust_id */ -1,
		/* ar_adjust.seq_ar_adjust_id */ -1,
		COALESCE( _DimFinancialAccount.FinancialAccountId , -1),
		CONVERT(NCHAR(8), COALESCE( ar_adjust.adj_date , '9999-12-31'), 112),
		COALESCE( _DimVersion.VersionId , -1),
		/* ar_adjust.seq_ar_adjust_id */ -1,
		/* ar_adjust.seq_ar_adjust_id */ 0,
		ar_adjust_reason.cust_tran_multiplier * CASE WHEN COALESCE(ar_adjust_reason.gst_inclusive, 'N') = 'Y' THEN ar_adjust.adj_amount / (1 + COALESCE(_taxRate.tax_rate, 0)) ELSE ar_adjust.adj_amount END,
		/* ar_adjust.seq_ar_adjust_id */ 'AUD',
		ar_adjust_reason.cust_tran_multiplier * CASE WHEN COALESCE(ar_adjust_reason.gst_inclusive, 'N') = 'Y' THEN ar_adjust.adj_amount * COALESCE(_taxRate.tax_rate, 0) / (1 + COALESCE(_taxRate.tax_rate, 0)) ELSE 0 END,
		ar_adjust_reason.adj_statement_desc,
		/* ar_adjust.seq_ar_adjust_id */ 'ADJ' + CAST(ar_adjust.seq_ar_adjust_id AS NVARCHAR(11))
	  FROM /* Staging */ lumo.ar_adjust INNER JOIN /* Staging */ lumo.ar_adjust_reason ON ar_adjust_reason.seq_adj_reason_id = ar_adjust.seq_adj_reason_id INNER JOIN /* Staging */ lumo.nc_client ON nc_client.seq_party_id = ar_adjust.seq_party_id INNER JOIN /* Staging */ lumo.crm_element_hierarchy ON crm_element_hierarchy.element_id = nc_client.seq_party_id AND crm_element_hierarchy.element_struct_code = 'CLIENT' INNER JOIN /* Staging */ lumo.crm_party_type ON crm_party_type.seq_party_type_id = crm_element_hierarchy.seq_element_type_id AND crm_party_type.party_type <> 'SUBCLIENT' LEFT JOIN taxRate AS _taxRate ON _taxRate.seq_ar_adjust_id = ar_adjust.seq_ar_adjust_id INNER JOIN /* Dimensional */ lumo.DimAccount AS _DimAccount ON _DimAccount.AccountKey = nc_client.seq_party_id AND _DimAccount.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimFinancialAccount AS _DimFinancialAccount ON _DimFinancialAccount.FinancialAccountKey = ar_adjust_reason.seq_account_id AND _DimFinancialAccount.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimVersion AS _DimVersion ON _DimVersion.VersionKey = 'Actual' WHERE ar_adjust.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR ar_adjust_reason.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _taxRate.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;