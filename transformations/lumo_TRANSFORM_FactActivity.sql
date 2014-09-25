CREATE PROCEDURE lumo.TRANSFORM_FactActivity
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

	;WITH crmElementHierarchy AS (SELECT crm_element_hierarchy.element_id, crm_element_hierarchy.element_struct_code, crm_element_hierarchy.parent_id, crm_element_hierarchy.Meta_LatestUpdate_TaskExecutionInstanceId, row_number() OVER (PARTITION BY crm_element_hierarchy.element_id ORDER BY crm_element_hierarchy.start_date1 DESC) AS recency FROM /* Staging */ lumo.crm_element_hierarchy)
	INSERT INTO lumo.FactActivity (
		FactActivity.CustomerId,
		FactActivity.RepresentativeId,
		FactActivity.OrganisationId,
		FactActivity.ActivityTypeId,
		FactActivity.ActivityDateId,
		FactActivity.ActivityTime,
		FactActivity.ActivityNotes,
		FactActivity.ActivityKey)
	  SELECT
		_DimCustomer.CustomerId,
		COALESCE( _DimRepresentative.RepresentativeId , -1),
		COALESCE( _DimOrganisation.Organisationid , -1),
		_DimActivityType.ActivityTypeId,
		CONVERT(NCHAR(8), crm_activity.activity_date , 112),
		CAST( crm_activity.activity_date AS TIME(2)),
		crm_activity_type.default_note,
		crm_activity.seq_activity_id
	  FROM /* Staging */ lumo.crm_activity INNER JOIN /* Staging */ lumo.crm_activity_type ON crm_activity_type.seq_act_type_id = crm_activity.seq_act_type_id LEFT JOIN crmElementHierarchy AS _crmElementHierarchy ON _crmElementHierarchy.element_id = crm_activity.seq_assignee_id AND _crmElementHierarchy.recency = 1 INNER JOIN /* Dimensional */ lumo.DimCustomer AS _DimCustomer ON _DimCustomer.CustomerKey = crm_activity.seq_party_id AND _DimCustomer.Meta_IsCurrent = 1 INNER JOIN /* Dimensional */ lumo.DimActivityType AS _DimActivityType ON _DimActivityType.ActivityTypeCode = crm_activity_type.act_type_code AND _DimActivityType.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimRepresentative AS _DimRepresentative ON _DimRepresentative.RepresentativeKey = CASE WHEN _crmElementHierarchy.element_struct_code IN ('SALES', 'STAFF') THEN _crmElementHierarchy.element_id END AND _DimRepresentative.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimOrganisation AS _DimOrganisation ON _DimOrganisation.OrganisationKey = CASE WHEN _crmElementHierarchy.element_struct_code IN ('CLIENT', 'SALES', 'STAFF') THEN _crmElementHierarchy.parent_id WHEN _crmElementHierarchy.element_struct_code IN ('COMPANY', 'DEPARTMENT', 'GROUP', 'SALESDEPT', 'SALESGRP') THEN _crmElementHierarchy.element_id END AND _DimOrganisation.Meta_IsCurrent = 1 WHERE crm_activity.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR crm_activity_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _crmElementHierarchy.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;