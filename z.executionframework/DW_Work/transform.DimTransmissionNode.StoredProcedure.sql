USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [transform].[DimTransmissionNode]
@TaskExecutionInstanceID int
,
@LatestSuccessfulTaskExecutionInstanceID int
AS
BEGIN

    --Get LatestSuccessfulTaskExecutionInstanceID
    IF  @LatestSuccessfulTaskExecutionInstanceID IS NULL
        BEGIN
            EXEC DW_Utility.config.GetLatestSuccessfulTaskExecutionInstanceID
            @TaskExecutionInstanceID = @TaskExecutionInstanceID
            , @LatestSuccessfulTaskExecutionInstanceID = @LatestSuccessfulTaskExecutionInstanceID OUTPUT;
        END;
    --/

    INSERT INTO temp.DimTransmissionNode (
    DimTransmissionNode.TransmissionNodeKey,
    DimTransmissionNode.TransmissionNodeIdentity,
    DimTransmissionNode.TransmissionNodeName,
    DimTransmissionNode.TransmissionNodeState,
    DimTransmissionNode.TransmissionNodeNetwork,
    DimTransmissionNode.TransmissionNodeServiceType,
    DimTransmissionNode.TransmissionNodeLossFactor) 
    SELECT
    CAST ( utl_network_node.network_node_id AS int) ,
    CAST ( utl_network_node.network_node_code AS nvarchar (20)) ,
    CAST ( utl_network_node.network_node_desc AS nvarchar (100)) ,
    CAST ( utl_network_region.region_code AS nchar (3)) ,
    CAST ( utl_network.network_desc AS nvarchar (100)) ,
    CAST (CASE utl_network.seq_product_type_id
          WHEN '1' THEN 'Internet'
          WHEN '2' THEN 'Electricity'
          WHEN '3' THEN 'Gas'
          WHEN '7' THEN 'Telco'
              ELSE NULL
          END AS nvarchar (11)),
	COALESCE ( utl_network_node.loss_factor , 1.0) 
      FROM
           DW_Staging.orion.utl_network_node INNER JOIN DW_Staging.orion.utl_network
           ON utl_network.network_id = utl_network_node.network_id
                                             LEFT JOIN DW_Staging.orion.utl_network_region
           ON utl_network_node.region_id = utl_network_region.region_id
      WHERE utl_network_node.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
        OR utl_network.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
        OR utl_network_region.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

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
CREATE PROCEDURE [transform].[DimTransmissionNode]
@TaskExecutionInstanceID int
,
@LatestSuccessfulTaskExecutionInstanceID int
AS
BEGIN

    --Get LatestSuccessfulTaskExecutionInstanceID
    IF  @LatestSuccessfulTaskExecutionInstanceID IS NULL
        BEGIN
            EXEC DW_Utility.config.GetLatestSuccessfulTaskExecutionInstanceID
            @TaskExecutionInstanceID = @TaskExecutionInstanceID
            , @LatestSuccessfulTaskExecutionInstanceID = @LatestSuccessfulTaskExecutionInstanceID OUTPUT;
        END;
    --/

    INSERT INTO temp.DimTransmissionNode (
    DimTransmissionNode.TransmissionNodeKey,
    DimTransmissionNode.TransmissionNodeIdentity,
    DimTransmissionNode.TransmissionNodeName,
    DimTransmissionNode.TransmissionNodeState,
    DimTransmissionNode.TransmissionNodeNetwork,
    DimTransmissionNode.TransmissionNodeServiceType,
    DimTransmissionNode.TransmissionNodeLossFactor) 
    SELECT
    CAST ( utl_network_node.network_node_id AS int) ,
    CAST ( utl_network_node.network_node_code AS nvarchar (20)) ,
    CAST ( utl_network_node.network_node_desc AS nvarchar (100)) ,
    CAST ( utl_network_region.region_code AS nchar (3)) ,
    CAST ( utl_network.network_desc AS nvarchar (100)) ,
    CAST (CASE utl_network.seq_product_type_id
          WHEN '1' THEN 'Internet'
          WHEN '2' THEN 'Electricity'
          WHEN '3' THEN 'Gas'
          WHEN '7' THEN 'Telco'
              ELSE NULL
          END AS nvarchar (11)),
	COALESCE ( utl_network_node_sched.loss_factor , 1.0) 
      FROM
           DW_Staging.orion.utl_network_node INNER JOIN DW_Staging.orion.utl_network
           ON utl_network.network_id = utl_network_node.network_id
                                             LEFT JOIN DW_Staging.orion.utl_network_region
           ON utl_network_node.region_id = utl_network_region.region_id
								    LEFT JOIN DW_Staging.orion.utl_network_node_sched
	     ON utl_network_node_sched.network_node_id = utl_network_node.network_node_id
      WHERE ISNULL (utl_network_node_sched.start_date, '1900-01-01') < GETDATE () 
            AND ISNULL (utl_network_node_sched.end_date, '9999-12-31') > GETDATE () 
		  AND (utl_network_node.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
        OR utl_network.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
        OR utl_network_region.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
	   OR utl_network_node_sched.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID);

    SELECT 0 AS ExtractRowCount,
           @@ROWCOUNT AS InsertRowCount,
           0 AS UpdateRowCount,
           0 AS DeleteRowCount,
           0 AS ErrorRowCount;

END;

GO
