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

	INSERT INTO lumo.DimActivityType (
		DimActivityType.ActivityTypeKey,
		DimActivityType.ActivityTypeCode,
		DimActivityType.ActivityTypeDesc,
		DimActivityType.ActivityCategory)
	  SELECT
		CAST('SAT'+''+CAST( nc_involvement_type.seq_involve_type_id AS NVARCHAR(20))AS nvarchar(20)),
		CAST( nc_involvement_type.seq_involve_type_id AS nvarchar(20)),
		CAST( nc_involvement_type.involve_type_desc AS nvarchar(100)),
		CAST(ISNULL( tbl_3_131_EN.name ,'Undefined')AS nvarchar(100))
	  FROM lumo.nc_involvement_type LEFT JOIN lumo.tbl_3_132_EN ON nc_involvement_type.seq_involve_type_id = tbl_3_132_EN.uda_132_2922 LEFT JOIN lumo.tbl_3_131_EN ON tbl_3_132_EN.uda_132_2923 = tbl_3_131_EN.Code WHERE tbl_3_132_EN.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR tbl_3_131_EN.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR nc_involvement_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;