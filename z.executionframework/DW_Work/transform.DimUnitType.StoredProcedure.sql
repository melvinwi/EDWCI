USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [transform].[DimUnitType]
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

	INSERT INTO temp.DimUnitType (
		DimUnitType.UnitTypeKey,
		DimUnitType.UnitTypeName,
		DimUnitType.MultiplicationFactorToBase)
	  SELECT
		CAST( utl_unit_of_measure.uom_id AS nvarchar(30)),
		CAST( utl_unit_of_measure.uom_desc AS nvarchar(20)),
		CASE LEFT( utl_unit_of_measure.uom_desc ,4) WHEN 'Kilo' THEN 1000 WHEN 'Thou' THEN 1000 WHEN 'Mill' THEN 1000000 WHEN 'Mega' THEN 1000000 ELSE 1 END
	  FROM DW_Staging.orion.utl_unit_of_measure WHERE utl_unit_of_measure.Meta_LatestUpdate_TaskExecutionInstanceId  > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;
GO
