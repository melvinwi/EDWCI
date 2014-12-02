CREATE PROCEDURE lumo.TRANSFORM_DimTransmissionNode
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

	INSERT INTO lumo.DimTransmissionNode (
		DimTransmissionNode.TransmissionNodeKey,
		DimTransmissionNode.TransmissionNodeIdentity,
		DimTransmissionNode.TransmissionNodeName,
		DimTransmissionNode.TransmissionNodeState,
		DimTransmissionNode.TransmissionNodeNetwork,
		DimTransmissionNode.TransmissionNodeServiceType,
		DimTransmissionNode.TransmissionNodeLossFactor)
	  SELECT
		CAST( utl_network_node.network_node_id AS int),
		CAST( utl_network_node.network_node_code AS nvarchar(20)),
		CAST( utl_network_node.network_node_desc AS nvarchar(100)),
		CAST( utl_network_region.region_code AS nchar(3)),
		CAST( utl_network.network_desc AS nvarchar(100)),
		CAST(CASE utl_network.seq_product_type_id WHEN '1' THEN 'Internet' WHEN '2' THEN 'Electricity' WHEN '3' THEN 'Gas' WHEN '7' THEN 'Telco' ELSE NULL END AS nvarchar(11)),
		COALESCE ( utl_network_node.loss_factor , 1.0 )
	  FROM lumo.utl_network_node INNER JOIN lumo.utl_network ON utl_network.network_id = utl_network_node.network_id LEFT JOIN lumo.utl_network_region ON utl_network_node.region_id = utl_network_region.region_id WHERE (utl_network_node.Meta_LatestUpdate_TaskExecutionInstanceId  > @LatestSuccessfulTaskExecutionInstanceID OR utl_network.Meta_LatestUpdate_TaskExecutionInstanceId  > @LatestSuccessfulTaskExecutionInstanceID OR utl_network_region.Meta_LatestUpdate_TaskExecutionInstanceId  > @LatestSuccessfulTaskExecutionInstanceID);

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;