USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [transform].[DimOrganisation]
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

	;WITH crmElementHierarchy AS (SELECT crm_element_hierarchy.element_id, crm_element_hierarchy.element_struct_code, crm_element_hierarchy.parent_id, crm_element_hierarchy.parent_element_struct_code, crm_element_hierarchy.Meta_LatestUpdate_TaskExecutionInstanceId, row_number() OVER (PARTITION BY crm_element_hierarchy.element_id ORDER BY crm_element_hierarchy.start_date1 DESC) AS recency FROM DW_Staging.orion.crm_element_hierarchy), latestCrmElementHierarchy AS (SELECT crmElementHierarchy.element_id, crmElementHierarchy.element_struct_code, crmElementHierarchy.parent_id, crmElementHierarchy.parent_element_struct_code, crmElementHierarchy.Meta_LatestUpdate_TaskExecutionInstanceId, crm_party.party_name FROM DW_Staging.orion.crm_party INNER JOIN crmElementHierarchy ON crmElementHierarchy.element_id = crm_party.seq_party_id AND crmElementHierarchy.recency = 1), parentCrmElementHierarchy AS (SELECT crm_element_hierarchy.element_id, crm_element_hierarchy.element_struct_code, crm_element_hierarchy.parent_id, crm_element_hierarchy.parent_element_struct_code, row_number() OVER (PARTITION BY crm_element_hierarchy.element_id ORDER BY crm_element_hierarchy.start_date1 DESC) AS recency FROM DW_Staging.orion.crm_element_hierarchy WHERE crm_element_hierarchy.element_struct_code IN ('DEPARTMENT', 'COMPANY', 'GROUP', 'SALESGRP')), latestParentCrmElementHierarchy AS (SELECT parentCrmElementHierarchy.element_id, parentCrmElementHierarchy.element_struct_code, parentCrmElementHierarchy.parent_id, parentCrmElementHierarchy.parent_element_struct_code, crm_party.party_name FROM DW_Staging.orion.crm_party INNER JOIN parentCrmElementHierarchy ON parentCrmElementHierarchy.element_id = crm_party.seq_party_id AND parentCrmElementHierarchy.recency = 1)
	INSERT INTO temp.DimOrganisation (
		DimOrganisation.OrganisationKey,
		DimOrganisation.OrganisationName,
		DimOrganisation.Level1Name,
		DimOrganisation.Level2Name,
		DimOrganisation.Level3Name,
		DimOrganisation.Level4Name)
	  SELECT
		_organisation.element_id,
		_organisation.party_name,
		CASE _organisation.element_struct_code WHEN 'SALESDEPT' THEN _organisation.party_name END,
		CASE _organisation.element_struct_code WHEN 'SALESDEPT' THEN parent.party_name ELSE _organisation.party_name END,
		CASE _organisation.element_struct_code WHEN 'SALESDEPT' THEN grandparent.party_name ELSE parent.party_name END,
		CASE _organisation.element_struct_code WHEN 'SALESDEPT' THEN greatgrandparent.party_name ELSE grandparent.party_name END
	  FROM latestCrmElementHierarchy _organisation LEFT JOIN latestParentCrmElementHierarchy parent ON parent.element_id = _organisation.parent_id AND parent.element_struct_code = _organisation.parent_element_struct_code LEFT JOIN latestParentCrmElementHierarchy grandparent ON grandparent.element_id = parent.parent_id AND grandparent.element_struct_code = parent.parent_element_struct_code LEFT JOIN latestParentCrmElementHierarchy greatgrandparent ON greatgrandparent.element_id = grandparent.parent_id AND greatgrandparent.element_struct_code = grandparent.parent_element_struct_code WHERE _organisation.element_struct_code IN ('DEPARTMENT', 'SALESDEPT', 'SALESGRP') AND Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

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
CREATE PROCEDURE [transform].[DimOrganisation]
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

	;WITH crmElementHierarchy AS (SELECT crm_element_hierarchy.element_id, crm_element_hierarchy.element_struct_code, crm_element_hierarchy.parent_id, crm_element_hierarchy.parent_element_struct_code, crm_element_hierarchy.Meta_LatestUpdate_TaskExecutionInstanceId, row_number() OVER (PARTITION BY crm_element_hierarchy.element_id ORDER BY crm_element_hierarchy.start_date1 DESC) AS recency FROM DW_Staging.orion.crm_element_hierarchy), latestCrmElementHierarchy AS (SELECT crmElementHierarchy.element_id, crmElementHierarchy.element_struct_code, crmElementHierarchy.parent_id, crmElementHierarchy.parent_element_struct_code, crmElementHierarchy.Meta_LatestUpdate_TaskExecutionInstanceId, crm_party.party_name FROM DW_Staging.orion.crm_party INNER JOIN crmElementHierarchy ON crmElementHierarchy.element_id = crm_party.seq_party_id AND crmElementHierarchy.recency = 1), parentCrmElementHierarchy AS (SELECT crm_element_hierarchy.element_id, crm_element_hierarchy.element_struct_code, crm_element_hierarchy.parent_id, crm_element_hierarchy.parent_element_struct_code, row_number() OVER (PARTITION BY crm_element_hierarchy.element_id ORDER BY crm_element_hierarchy.start_date1 DESC) AS recency FROM DW_Staging.orion.crm_element_hierarchy WHERE crm_element_hierarchy.element_struct_code IN ('DEPARTMENT', 'COMPANY', 'GROUP', 'SALESGRP')), latestParentCrmElementHierarchy AS (SELECT parentCrmElementHierarchy.element_id, parentCrmElementHierarchy.element_struct_code, parentCrmElementHierarchy.parent_id, parentCrmElementHierarchy.parent_element_struct_code, crm_party.party_name FROM DW_Staging.orion.crm_party INNER JOIN parentCrmElementHierarchy ON parentCrmElementHierarchy.element_id = crm_party.seq_party_id AND parentCrmElementHierarchy.recency = 1)
	INSERT INTO temp.DimOrganisation (
		DimOrganisation.OrganisationKey,
		DimOrganisation.OrganisationName,
		DimOrganisation.Level1Name,
		DimOrganisation.Level2Name,
		DimOrganisation.Level3Name,
		DimOrganisation.Level4Name)
	  SELECT
		_organisation.element_id,
		_organisation.party_name,
		CASE _organisation.element_struct_code WHEN 'SALESDEPT' THEN _organisation.party_name END,
		CASE _organisation.element_struct_code WHEN 'SALESDEPT' THEN parent.party_name ELSE _organisation.party_name END,
		CASE _organisation.element_struct_code WHEN 'SALESDEPT' THEN grandparent.party_name ELSE parent.party_name END,
		CASE _organisation.element_struct_code WHEN 'SALESDEPT' THEN greatgrandparent.party_name ELSE grandparent.party_name END
	  FROM latestCrmElementHierarchy _organisation LEFT JOIN latestParentCrmElementHierarchy parent ON parent.element_id = _organisation.parent_id AND parent.element_struct_code = _organisation.parent_element_struct_code LEFT JOIN latestParentCrmElementHierarchy grandparent ON grandparent.element_id = parent.parent_id AND grandparent.element_struct_code = parent.parent_element_struct_code LEFT JOIN latestParentCrmElementHierarchy greatgrandparent ON greatgrandparent.element_id = grandparent.parent_id AND greatgrandparent.element_struct_code = grandparent.parent_element_struct_code WHERE _organisation.element_struct_code IN ('DEPARTMENT', 'SALESDEPT', 'SALESGRP') AND Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID;

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;

GO
