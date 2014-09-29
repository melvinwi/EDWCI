CREATE PROCEDURE lumo.TRANSFORM_FactAgedTrialBalance
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

	INSERT INTO lumo.FactAgedTrialBalance (
		FactAgedTrialBalance.AccountId,
		FactAgedTrialBalance.ATBDateId,
		FactAgedTrialBalance.CurrentPeriod,
		FactAgedTrialBalance.Days1To30,
		FactAgedTrialBalance.Days31To60,
		FactAgedTrialBalance.Days61To90,
		FactAgedTrialBalance.Days90Plus)
	  SELECT
		_DimAccount.AccountId,
		CONVERT(NCHAR(8), ISNULL( ar_aged_debtor_balance.update_datetime , '9999-12-31'), 112),
		COALESCE( ar_aged_debtor_balance.current_period , 0.00),
		COALESCE( ar_aged_debtor_balance.days_30 , 0.00),
		COALESCE( ar_aged_debtor_balance.days_60 , 0.00),
		COALESCE( ar_aged_debtor_balance.days_90 , 0.00),
		COALESCE( ar_aged_debtor_balance.days_90_plus , 0.00)
	  FROM /* Staging */ lumo.ar_aged_debtor_balance INNER JOIN /* Dimensional */ lumo.DimAccount as _DimAccount ON _DimAccount.AccountKey = ar_aged_debtor_balance.seq_party_id AND _DimAccount.Meta_IsCurrent = 1;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;