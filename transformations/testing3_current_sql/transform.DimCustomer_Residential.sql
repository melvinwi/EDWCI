USE [DW_Work]
GO

/****** Object:  StoredProcedure [transform].[DimCustomer_Residential]    Script Date: 27/08/2014 12:56:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [transform].[DimCustomer_Residential]
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
    WITH customerStatus
        AS (SELECT nc_client.seq_party_id,
                   MAX (CASE
                        WHEN utl_account_status.accnt_status_class_id = 2 THEN 1
                            ELSE 0
                        END) AS CustomerStatus,
                   MAX (CASE
                        WHEN nc_client.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
                          OR nc_product.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
                          OR nc_product_item.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID THEN 1
                            ELSE 0
                        END) AS Meta_HasChanged
              FROM
                   [DW_Staging].[orion].nc_client LEFT OUTER JOIN [DW_Staging].[orion].nc_product
                   ON nc_product.seq_party_id = nc_client.seq_party_id
                                  LEFT OUTER JOIN [DW_Staging].[orion].nc_product_item
                   ON nc_product_item.seq_product_id = nc_product.seq_product_id
                                  LEFT OUTER JOIN [DW_Staging].[orion].utl_account_status
                   ON utl_account_status.accnt_status_id = nc_product_item.accnt_status_id
              GROUP BY nc_client.seq_party_id) , ombudsmanComplaints
        AS (SELECT Complaint.ClientId,
                   Complaint.IsOmbudsman,
                   MAX (CASE
                        WHEN Complaint.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID THEN 1
                            ELSE 0
                        END) AS Meta_HasChanged
              FROM [DW_Staging].[complaints].Complaint
              WHERE Complaint.IsOmbudsman = 1
                AND Complaint.DateCreated > DATEADD (YEAR, -1, GETDATE ()) 
              GROUP BY Complaint.ClientId,
                       Complaint.IsOmbudsman) 
        INSERT INTO temp.DimCustomer (
        DimCustomer.CustomerCode,
        DimCustomer.CustomerKey,
        DimCustomer.Title,
        DimCustomer.Firstname,
        DimCustomer.MiddleInitial,
        DimCustomer.LastName,
        DimCustomer.PartyName,
        DimCustomer.PostalAddressLine1,
        DimCustomer.PostalSuburb,
        DimCustomer.PostalPostcode,
        DimCustomer.PostalState,
        DimCustomer.ResidentialAddressLine1,
        DimCustomer.ResidentialSuburb,
        DimCustomer.ResidentialPostcode,
        DimCustomer.ResidentialState,
        DimCustomer.PrimaryPhone,
        DimCustomer.PrimaryPhoneType,
        DimCustomer.SecondaryPhone,
        DimCustomer.SecondaryPhoneType,
        DimCustomer.MobilePhone,
        DimCustomer.Email,
        DimCustomer.DateOfBirth,
        DimCustomer.CustomerType,
        DimCustomer.CustomerStatus,
        DimCustomer.OmbudsmanComplaints) 
        SELECT
        CASE
        WHEN ISNUMERIC (crm_party.party_code) = 1 THEN CAST ( crm_party.party_code AS int) 
        END,
        CAST ( nc_client.seq_party_id AS int) ,
        CAST ( crm_party.title AS nchar (3)) ,
        CAST ( crm_party.first_name AS nvarchar (100)) ,
        CAST ( crm_party.initials AS nchar (10)) ,
        CAST ( crm_party.last_name AS nvarchar (100)) ,
        CAST ( crm_party.party_name AS nvarchar (100)) ,
        CAST ( crm_party.postal_addr_1 AS nvarchar (100)) ,
        CAST ( crm_party.postal_addr_2 AS nvarchar (50)) ,
        CAST ( crm_party.postal_post_code AS nchar (4)) ,
        CAST ( crm_party.postal_addr_3 AS nchar (3)) ,
        CAST ( crm_party.street_addr_1 AS nvarchar (100)) ,
        CAST ( crm_party.street_addr_2 AS nvarchar (50)) ,
        CAST ( crm_party.street_post_code AS nchar (4)) ,
        CAST ( crm_party.street_addr_3 AS nchar (3)) ,
        CAST (CONCAT ( crm_party.std_code, crm_party.phone_no) AS nvarchar (24)) ,
        CAST (CASE crm_party.primary_phone_type_id
              WHEN '1' THEN 'Landline'
              WHEN '2' THEN 'Mobile'
                  ELSE NULL
              END AS nchar (8)) ,
        CAST (CONCAT ( crm_party.secondary_std_code, crm_party.secondary_phone_no) AS nvarchar (24)) ,
        CAST (CASE crm_party.secondary_phone_type_id
              WHEN '1' THEN 'Landline'
              WHEN '2' THEN 'Mobile'
                  ELSE NULL
              END AS nchar (8)) ,
        CAST (CASE
              WHEN LEFT ( crm_party.std_code , 2) = '04' THEN CONCAT (crm_party.std_code, crm_party.phone_no) 
              WHEN LEFT (crm_party.secondary_std_code, 2) = '04' THEN CONCAT (crm_party.secondary_std_code, crm_party.secondary_phone_no) 
                  ELSE NULL
              END AS nchar (10)) ,
        CAST ( crm_party.email_address AS nvarchar (100)) ,
        crm_party.date_of_birth,
        CAST (CASE crm_element_hierarchy.seq_element_type_id
              WHEN '9' THEN 'Residential'
              WHEN '8' THEN 'Business'
                  ELSE NULL
              END AS nchar (11)) ,
        CAST (CASE _customerStatus.CustomerStatus
              WHEN 1 THEN 'Active'
                  ELSE 'Inactive'
              END AS nchar (8)) ,
        CAST (CASE _ombudsmanComplaints.IsOmbudsman
              WHEN 1 THEN 'Yes'
                  ELSE 'No'
              END AS nchar (3)) 
          FROM
               [DW_Staging].[orion].nc_client INNER JOIN [DW_Staging].[orion].crm_party
               ON nc_client.seq_party_id = crm_party.seq_party_id
                              INNER JOIN [DW_Staging].[orion].crm_element_hierarchy
               ON crm_element_hierarchy.element_id = crm_party.seq_party_id
                              INNER JOIN customerStatus AS _customerStatus
               ON _customerStatus.seq_party_id = nc_client.seq_party_id
                              LEFT OUTER JOIN ombudsmanComplaints AS _ombudsmanComplaints
               ON _ombudsmanComplaints.ClientId = crm_party.party_code
          WHERE crm_element_hierarchy.seq_element_type_id = '9'
            AND (crm_party.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
              OR nc_client.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
              OR crm_element_hierarchy.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
              OR _customerStatus.Meta_HasChanged = 1
              OR _ombudsmanComplaints.Meta_HasChanged = 1);

    SELECT 0 AS ExtractRowCount,
           @@ROWCOUNT AS InsertRowCount,
           0 AS UpdateRowCount,
           0 AS DeleteRowCount,
           0 AS ErrorRowCount;

END;

GO


