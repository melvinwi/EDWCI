CREATE PROCEDURE lumo.TRANSFORM_DimActivityType_Sales
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

	;WITH _nit AS ( SELECT _nit.seq_involve_type_id ,_nit.involve_type_desc ,_nit.Meta_LatestUpdate_TaskExecutionInstanceId FROM lumo.[nc_involvement_type] _nit ) , _categories AS ( SELECT _categories.Code ,_categories.name ,_categories.Meta_LatestUpdate_TaskExecutionInstanceId  FROM lumo.[tbl_3_131_EN] _categories )
	INSERT INTO lumo.DimActivityType (
		DimActivityType.ActivityTypeKey,
		DimActivityType.ActivityTypeCode,
		DimActivityType.ActivityTypeDesc,
		DimActivityType.ActivityCategory)
	  SELECT
		CAST('SAT'+''+CAST( _reference_daily_sales_and_cancellations_entity.[uda_132_2922] AS NVARCHAR(20))AS nvarchar(20)),
		CAST( _reference_daily_sales_and_cancellations_entity.[uda_132_2922] AS nvarchar(20)),
		CAST( _nit.involve_type_desc AS nvarchar(100)),
		CAST( _categories.name AS nvarchar(100))
	  FROM  lumo.[tbl_3_132_EN] _reference_daily_sales_and_cancellations_entity INNER JOIN _nit                   ON _reference_daily_sales_and_cancellations_entity.[uda_132_2922] = _nit.seq_involve_type_id LEFT JOIN _categories                  ON _reference_daily_sales_and_cancellations_entity.[uda_132_2923] = _categories.Code  WHERE  _reference_daily_sales_and_cancellations_entity.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID  OR   _categories.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR   _nit.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;