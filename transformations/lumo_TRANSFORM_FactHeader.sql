CREATE PROCEDURE lumo.TRANSFORM_FactHeader
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

	INSERT INTO lumo.FactHeader (
		FactHeader.AccountId,
		FactHeader.IssueDateId,
		FactHeader.DueDateId,
		FactHeader.HeaderType,
		FactHeader.PaidOnTime,
		FactHeader.HeaderKey)
	  SELECT
		_DimAccount.AccountId,
		CONVERT(NCHAR(8), COALESCE( inv_invoice_header.invoice_date , '9999-12-31'), 112),
		CONVERT(NCHAR(8), COALESCE( ar_invoice.invoice_due_date , '9999-12-31'), 112),
		/* inv_invoice_header.invoice_reference */ 'Invoice',
		CASE ar_invoice.paid_promptly WHEN 'Y' THEN 'Yes' ELSE 'No' END,
		inv_invoice_header.invoice_reference
	  FROM /* Staging */ lumo.inv_invoice_header INNER JOIN /* Staging */ lumo.ar_invoice ON ar_invoice.seq_ar_invoice_id = inv_invoice_header.seq_invoice_header_id INNER JOIN /* Staging */ lumo.nc_client ON nc_client.seq_party_id = ar_invoice.seq_party_id INNER JOIN /* Staging */ lumo.crm_element_hierarchy ON crm_element_hierarchy.element_id = nc_client.seq_party_id AND crm_element_hierarchy.element_struct_code = 'CLIENT' INNER JOIN /* Staging */ lumo.crm_party_type ON crm_party_type.seq_party_type_id = crm_element_hierarchy.seq_element_type_id AND crm_party_type.party_type <> 'SUBCLIENT' INNER JOIN /* Dimensional */ lumo.DimAccount AS _DimAccount ON _DimAccount.AccountKey = nc_client.seq_party_id AND _DimAccount.Meta_IsCurrent = 1 WHERE inv_invoice_header.seq_invoice_run_id <> 0 AND (inv_invoice_header.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR ar_invoice.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID);

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;