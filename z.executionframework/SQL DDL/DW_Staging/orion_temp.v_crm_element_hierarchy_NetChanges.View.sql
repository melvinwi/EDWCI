USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [orion_temp].[v_crm_element_hierarchy_NetChanges] AS


WITH crm_element_hierarchy_with_row_precedence
    AS (
    SELECT element_id
         , element_struct_code
         , parent_id
         , parent_element_struct_code
         , seq_element_type_id
         , active
         , insert_datetime
         , insert_user
         , insert_process
         , update_datetime
         , update_user
         , update_process
         , [start_date]
         , end_date
         , start_date1
         , end_date1
         , department_head
         , ROW_NUMBER() OVER( PARTITION BY  element_id
                                          , parent_id
                                          , insert_datetime 
                              ORDER BY      __$start_lsn DESC 
                                          , __$seqval DESC
                           ) AS Precedence
    FROM DW_Staging.orion_temp.crm_element_hierarchy
    WHERE __$operation = 4    --1 = delete; 2 = insert; 3 = before update; 4 = after update
       )
    SELECT element_id
         , element_struct_code
         , parent_id
         , parent_element_struct_code
         , seq_element_type_id
         , active
         , insert_datetime
         , insert_user
         , insert_process
         , update_datetime
         , update_user
         , update_process
         , [start_date]
         , end_date
         , start_date1
         , end_date1
         , department_head
    FROM  crm_element_hierarchy_with_row_precedence
    WHERE Precedence = 1


GO
