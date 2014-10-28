USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [orion_temp].[v_utl_pp_schedule_type_NetChanges] AS


WITH utl_pp_schedule_type_with_row_precedence
    AS (
    SELECT  sched_type_id
          , sched_class_id
          , seq_product_type_id
          , sched_type_code
          , sched_type_desc
          , active
          , insert_datetime
          , insert_user
          , insert_process
          , update_datetime
          , update_user
          , update_process
          , default_option
          , trans_type_id
          , seq_account_id
          , use_simple_schedule
          , minimum_charge_freq
          , ROW_NUMBER() OVER ( PARTITION BY  sched_type_id
                                ORDER BY   __$start_lsn DESC 
                                         , __$seqval DESC
                              ) AS Precedence
    FROM  DW_Staging.orion_temp.utl_pp_schedule_type
    WHERE __$operation = 4    --1 = delete; 2 = insert; 3 = before update; 4 = after update
       )
    SELECT  sched_type_id
          , sched_class_id
          , seq_product_type_id
          , sched_type_code
          , sched_type_desc
          , active
          , insert_datetime
          , insert_user
          , insert_process
          , update_datetime
          , update_user
          , update_process
          , default_option
          , trans_type_id
          , seq_account_id
          , use_simple_schedule
          , minimum_charge_freq
    FROM  utl_pp_schedule_type_with_row_precedence
    WHERE Precedence = 1

GO
