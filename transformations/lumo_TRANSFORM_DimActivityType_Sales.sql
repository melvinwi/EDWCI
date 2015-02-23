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
		CAST('SAT'+''+CAST( tbl_3_132_EN.[uda_132_2922] AS NVARCHAR(20))AS nvarchar(20)),
		CAST( tbl_3_132_EN.[uda_132_2922] AS nvarchar(20)),
		CAST( nc_involvement_type.involve_type_desc AS nvarchar(100)),
		CAST( tbl_3_131_EN.name AS nvarchar(100))
	  FROM lumo.tbl_3_132_EN INNER JOIN lumo.nc_involvement_type ON tbl_3_132_EN.uda_132_2922 = nc_involvement_type.seq_involve_type_id LEFT JOIN lumo.tbl_3_131_EN ON tbl_3_132_EN.uda_132_2923 = tbl_3_131_EN.Code WHERE tbl_3_132_EN.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR tbl_3_131_EN.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR nc_involvement_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;