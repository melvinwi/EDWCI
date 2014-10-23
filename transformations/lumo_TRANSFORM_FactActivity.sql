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

	;WITH crmActivityNotes AS (SELECT crm_activity_notes.seq_activity_id, crm_activity_notes.notes, crm_activity_notes.Meta_LatestUpdate_TaskExecutionInstanceId, ROW_NUMBER() OVER (PARTITION BY crm_activity_notes.seq_activity_id ORDER BY insert_datetime) as precedence FROM /* Staging */ lumo.crm_activity_notes), crmElementHierarchy AS (SELECT crm_element_hierarchy.element_id, crm_element_hierarchy.element_struct_code, crm_element_hierarchy.parent_id, crm_element_hierarchy.Meta_LatestUpdate_TaskExecutionInstanceId, row_number() OVER (PARTITION BY crm_element_hierarchy.element_id ORDER BY crm_element_hierarchy.start_date1 DESC) AS recency FROM /* Staging */ lumo.crm_element_hierarchy), marketing AS (SELECT DimActivityType.ActivityTypeKey, MAX(FactMarketingCampaignActivity.Meta_LatestUpdate_TaskExecutionInstanceId) AS Meta_LatestUpdate_TaskExecutionInstanceId FROM /* Dimensional */ lumo.DimActivityType INNER JOIN /* Dimensional */ lumo.FactMarketingCampaignActivity ON FactMarketingCampaignActivity.ActivityTypeId = DimActivityType.ActivityTypeId GROUP BY DimActivityType.ActivityTypeKey), complaint AS (SELECT crm_activity_type.seq_act_type_id, crm_activity_category.Meta_LatestUpdate_TaskExecutionInstanceId FROM /* Staging */ lumo.crm_activity_type INNER JOIN /* Staging */ lumo.crm_activity_category ON crm_activity_category.seq_act_category_id = crm_activity_type.seq_act_category_id AND crm_activity_category.act_cat_code IN ('COMPLAINT_A', 'COMPLAINT_C', 'COMPL_CN') AND crm_activity_type.act_type_code <> 'COMPL_MS'), enquiry AS (SELECT crm_activity_source.seq_act_source_id, crm_activity_source.Meta_LatestUpdate_TaskExecutionInstanceId FROM /* Staging */ lumo.crm_activity_source WHERE crm_activity_source.act_source_code IN ('EMAIL IN', 'FAX IN', 'LETTER IN', 'LIVECHAT', 'PHONE IN')), retention AS (SELECT crm_activity_type.seq_act_type_id FROM /* Staging */ lumo.crm_activity_type WHERE crm_activity_type.seq_act_type_id IN (1010, 1057, 2122, 1286, 1647, 1648, 1904, 2127, 1913, 2647, 2648, 1043, 1287, 1758, 1759, 1760, 1761, 1762, 1763, 1902, 2128, 2123, 1903, 2130))
	INSERT INTO lumo.FactActivity (
		FactActivity.CustomerId,
		FactActivity.RepresentativeId,
		FactActivity.OrganisationId,
		FactActivity.ActivityTypeId,
		FactActivity.ActivityDateId,
		FactActivity.ActivityTime,
		FactActivity.ActivityCommunicationMethod,
		FactActivity.ActivityCategory,
		FactActivity.ActivityNotes,
		FactActivity.ActivityKey)
	  SELECT
		_DimCustomer.CustomerId,
		COALESCE( _DimRepresentative.RepresentativeId , -1),
		COALESCE( _DimOrganisation.OrganisationId , -1),
		_DimActivityType.ActivityTypeId,
		CONVERT(NCHAR(8), crm_activity.activity_date , 112),
		CAST( crm_activity.activity_date AS TIME),
		NULLIF( crm_activity_source.act_source_desc , ''),
		CASE WHEN _marketing.ActivityTypeKey IS NOT NULL THEN 'Marketing' WHEN _complaint.seq_act_type_id IS NOT NULL THEN 'Complaint' WHEN _enquiry.seq_act_source_id IS NOT NULL THEN 'Enquiry' WHEN _retention.seq_act_type_id IS NOT NULL THEN 'Retention' END,
		COALESCE(NULLIF( _crmActivityNotes.notes , ''), NULLIF(crm_activity_type.default_note, '')),
		crm_activity.seq_activity_id
	  FROM /* Staging */ lumo.crm_activity INNER JOIN /* Staging */ lumo.crm_activity_type ON crm_activity_type.seq_act_type_id = crm_activity.seq_act_type_id LEFT JOIN crmActivityNotes AS _crmActivityNotes ON _crmActivityNotes.seq_activity_id = crm_activity.seq_activity_id AND _crmActivityNotes.precedence = 1 LEFT JOIN /* Staging */ lumo.crm_activity_source ON crm_activity_source.seq_act_source_id = crm_activity.seq_act_source_id LEFT JOIN crmElementHierarchy AS _crmElementHierarchy ON _crmElementHierarchy.element_id = crm_activity.seq_assignee_id AND _crmElementHierarchy.recency = 1 INNER JOIN /* Dimensional */ lumo.DimCustomer AS _DimCustomer ON _DimCustomer.CustomerKey = crm_activity.seq_party_id AND _DimCustomer.Meta_IsCurrent = 1 INNER JOIN /* Dimensional */ lumo.DimActivityType AS _DimActivityType ON _DimActivityType.ActivityTypeKey = crm_activity_type.seq_act_type_id AND _DimActivityType.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimRepresentative AS _DimRepresentative ON _DimRepresentative.RepresentativeKey = CASE WHEN _crmElementHierarchy.element_struct_code IN ('SALES', 'STAFF') THEN _crmElementHierarchy.element_id END AND _DimRepresentative.Meta_IsCurrent = 1 LEFT JOIN /* Dimensional */ lumo.DimOrganisation AS _DimOrganisation ON _DimOrganisation.OrganisationKey = CASE WHEN _crmElementHierarchy.element_struct_code IN ('CLIENT', 'SALES', 'STAFF') THEN _crmElementHierarchy.parent_id WHEN _crmElementHierarchy.element_struct_code IN ('COMPANY', 'DEPARTMENT', 'GROUP', 'SALESDEPT', 'SALESGRP') THEN _crmElementHierarchy.element_id END AND _DimOrganisation.Meta_IsCurrent = 1 LEFT JOIN marketing AS _marketing ON _marketing.ActivityTypeKey = crm_activity.seq_act_type_id LEFT JOIN complaint AS _complaint ON _complaint.seq_act_type_id = crm_activity.seq_act_type_id LEFT JOIN enquiry AS _enquiry ON _enquiry.seq_act_source_id = crm_activity.seq_act_source_id LEFT JOIN retention AS _retention ON _retention.seq_act_type_id = crm_activity.seq_act_type_id WHERE (_marketing.ActivityTypeKey IS NOT NULL OR _complaint.seq_act_type_id IS NOT NULL OR _enquiry.seq_act_source_id IS NOT NULL OR _retention.seq_act_type_id IS NOT NULL) AND (crm_activity.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR crm_activity_type.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _crmActivityNotes.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR crm_activity_source.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _crmElementHierarchy.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _marketing.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _complaint.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR _enquiry.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID);

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;