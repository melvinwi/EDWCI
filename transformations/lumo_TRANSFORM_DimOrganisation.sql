CREATE PROCEDURE lumo.TRANSFORM_DimOrganisation
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

	;WITH _Level4 AS  (  SELECT Party.seq_party_id OrgId, Party.party_code OrgCode, Party.party_name OrgName, hrc.element_struct_code StructureName, hrc.parent_id ParentId, hrc.parent_element_struct_code ParentStructureName  , MAX(CASE WHEN party.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR hrc.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID THEN 1 ELSE 0 END) AS Meta_HasChanged   FROM lumo.Crm_party party    INNER JOIN lumo.Crm_element_hierarchy hrc ON hrc.element_id = seq_party_id   WHERE element_struct_code = 'GROUP'  GROUP BY Party.seq_party_id, Party.party_code, Party.party_name, hrc.element_struct_code, hrc.parent_id, hrc.parent_element_struct_code ) , _Level3 AS  (  SELECT Party.seq_party_id OrgId, Party.party_code OrgCode, Party.party_name OrgName, hrc.element_struct_code StructureName, hrc.parent_id ParentId, hrc.parent_element_struct_code ParentStructureName  , MAX(CASE WHEN party.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR hrc.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID THEN 1 ELSE 0 END) AS Meta_HasChanged   FROM lumo.Crm_party party    INNER JOIN lumo.Crm_element_hierarchy hrc ON hrc.element_id = seq_party_id   WHERE element_struct_code = 'COMPANY'  GROUP BY Party.seq_party_id, Party.party_code, Party.party_name, hrc.element_struct_code, hrc.parent_id, hrc.parent_element_struct_code ) , _Level2 AS  (  SELECT Party.seq_party_id OrgId, Party.party_code OrgCode, Party.party_name OrgName, hrc.element_struct_code StructureName, hrc.parent_id ParentId, hrc.parent_element_struct_code ParentStructureName  , MAX(CASE WHEN party.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR hrc.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID THEN 1 ELSE 0 END) AS Meta_HasChanged   FROM lumo.Crm_party party    INNER JOIN lumo.Crm_element_hierarchy hrc ON hrc.element_id = seq_party_id   WHERE element_struct_code = 'SALESGRP' OR element_struct_code = 'DEPARTMENT'  GROUP BY Party.seq_party_id, Party.party_code, Party.party_name, hrc.element_struct_code, hrc.parent_id, hrc.parent_element_struct_code ) , _Level1 AS  (  SELECT Party.seq_party_id OrgId, Party.party_code OrgCode, Party.party_name OrgName, hrc.element_struct_code StructureName, hrc.parent_id ParentId, hrc.parent_element_struct_code ParentStructureName  , MAX(CASE WHEN party.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID OR hrc.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID THEN 1 ELSE 0 END) AS Meta_HasChanged   FROM lumo.Crm_party party    INNER JOIN lumo.Crm_element_hierarchy hrc ON hrc.element_id = seq_party_id   WHERE element_struct_code = 'SALESDEPT'  GROUP BY Party.seq_party_id, Party.party_code, Party.party_name, hrc.element_struct_code, hrc.parent_id, hrc.parent_element_struct_code  )
	INSERT INTO lumo.DimOrganisation (
		DimOrganisation.OrganisationCode,
		DimOrganisation.OrganisationKey,
		DimOrganisation.OrganisationName,
		DimOrganisation.Level1Name,
		DimOrganisation.Level2Name,
		DimOrganisation.Level3Name,
		DimOrganisation.Level4Name)
	  SELECT
		CAST(ISNULL( _Level1.OrgCode, ISNULL(_Level2.OrgCode, _Level3.OrgCode) ) AS nchar(10)),
		CAST(ISNULL( _Level1.OrgId, ISNULL(_Level2.OrgId, _Level3.OrgId) ) AS int),
		CAST(ISNULL( _Level1.OrgName, ISNULL(_Level2.OrgName, _Level3.OrgName) ) AS nvarchar(100)),
		CAST( _Level1.OrgName AS nvarchar(100)),
		CAST( _Level2.OrgName AS nvarchar(100)),
		CAST( _Level3.OrgName AS nvarchar(100)),
		CAST( _Level4.OrgName AS nvarchar(100))
	  FROM _Level4  LEFT JOIN _Level3 ON _Level3.ParentId = _Level4.OrgId  LEFT JOIN _Level2 ON _Level2.ParentId = _Level3.OrgId  LEFT JOIN _Level1 ON _Level1.ParentId = _Level2.OrgId WHERE (_Level1.Meta_HasChanged = 1 OR _Level2.Meta_HasChanged = 1 OR _Level3.Meta_HasChanged = 1 OR _Level4.Meta_HasChanged = 1);

SELECT 0 AS ExtractRowCount,
@@ROWCOUNT AS InsertRowCount,
0 AS UpdateRowCount,
0 AS DeleteRowCount,
0 AS ErrorRowCount;

END;