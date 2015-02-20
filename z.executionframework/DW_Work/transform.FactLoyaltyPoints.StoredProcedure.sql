USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [transform].[FactLoyaltyPoints]
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

	INSERT INTO temp.FactLoyaltyPoints (
	 FactLoyaltyPoints.[CustomerId],
      FactLoyaltyPoints.[AwardedDateId],
      FactLoyaltyPoints.[ProgramName],
      FactLoyaltyPoints.[PointsType],
      FactLoyaltyPoints.[PointsAmount],
      FactLoyaltyPoints.[MemberNumber],
	 FactLoyaltyPoints.[LoyaltyPointsKey])
	  SELECT
		_DimCustomer.CustomerId,
		CONVERT(NCHAR(8), ISNULL( utl_air_points.insert_datetime , '9999-12-31'), 112),
		'Velocity',
		CAST(CASE utl_air_points.points_type WHEN 'ONEOFF' THEN 'Oneoff' WHEN 'BONUS' THEN 'Bonus' WHEN 'BASE' THEN 'Base' ELSE NULL END AS nchar(6)),
		ISNULL(utl_air_points.points_exported,0),
		utl_air_points.virgin_member_id,
		utl_air_points.air_points_id
	  FROM [DW_Staging].[orion].utl_air_points INNER JOIN [DW_Dimensional].[DW].DimCustomer AS _DimCustomer ON _DimCustomer.CustomerKey = utl_air_points.seq_party_id 
	  WHERE _DimCustomer.Meta_IsCurrent = 1 AND utl_air_points.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;



GO
USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [transform].[FactLoyaltyPoints]
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

	INSERT INTO temp.FactLoyaltyPoints (
	 FactLoyaltyPoints.[CustomerId],
      FactLoyaltyPoints.[AwardedDateId],
      FactLoyaltyPoints.[ProgramName],
      FactLoyaltyPoints.[PointsType],
      FactLoyaltyPoints.[PointsAmount],
      FactLoyaltyPoints.[MemberNumber],
	 FactLoyaltyPoints.[LoyaltyPointsKey])
	  SELECT
		_DimCustomer.CustomerId,
		CONVERT(NCHAR(8), ISNULL( utl_air_points.insert_datetime , '9999-12-31'), 112),
		'Velocity',
		CAST(CASE utl_air_points.points_type WHEN 'ONEOFF' THEN 'Oneoff' WHEN 'BONUS' THEN 'Bonus' WHEN 'BASE' THEN 'Base' ELSE NULL END AS nchar(6)),
		ISNULL(utl_air_points.points_exported,0),
		utl_air_points.virgin_member_id,
		utl_air_points.air_points_id
	  FROM [DW_Staging].[orion].utl_air_points INNER JOIN [DW_Dimensional].[DW].DimCustomer AS _DimCustomer ON _DimCustomer.CustomerKey = utl_air_points.seq_party_id 
	  WHERE _DimCustomer.Meta_IsCurrent = 1 AND utl_air_points.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;

GO
