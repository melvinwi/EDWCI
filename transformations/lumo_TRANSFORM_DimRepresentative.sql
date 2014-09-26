CREATE PROCEDURE lumo.TRANSFORM_DimRepresentative
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

	;WITH crmElementHierarchy AS (SELECT crm_element_hierarchy.element_id, crm_element_hierarchy.element_struct_code, crm_element_hierarchy.parent_id, crm_element_hierarchy.parent_element_struct_code, crm_element_hierarchy.Meta_LatestUpdate_TaskExecutionInstanceId, row_number() OVER (PARTITION BY crm_element_hierarchy.element_id ORDER BY crm_element_hierarchy.start_date1 DESC) AS recency FROM /* Staging */ lumo.crm_element_hierarchy WHERE crm_element_hierarchy.element_struct_code IN ('SALES', 'STAFF'))
	INSERT INTO lumo.DimRepresentative (
		DimRepresentative.RepresentativeKey,
		DimRepresentative.RepresentativeFirstName,
		DimRepresentative.RepresentativeMiddleInitial,
		DimRepresentative.RepresentativeLastName,
		DimRepresentative.RepresentativePartyName)
	  SELECT
		_representative.element_id,
		crm_party.first_name,
		crm_party.initials,
		crm_party.last_name,
		crm_party.party_name
	  FROM crmElementHierarchy _representative INNER JOIN /* Staging */ lumo.crm_party ON crm_party.seq_party_id = _representative.element_id WHERE _representative.recency = 1 AND _representative.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;