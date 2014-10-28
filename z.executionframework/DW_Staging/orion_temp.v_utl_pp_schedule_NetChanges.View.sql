USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [orion_temp].[v_utl_pp_schedule_NetChanges] AS


WITH utl_pp_schedule_with_row_precedence
    AS (
    SELECT  sched_id
          , price_plan_id
          , sched_type_id
          , meter_type_id
          , capacity_id
          , band_header_id
          , active
          , insert_datetime
          , insert_user
          , insert_process
          , update_datetime
          , update_user
          , update_process
          , contractable
          , summ_all_in_class
          , invoice_desc
          , seq_account_id
          , ROW_NUMBER() OVER(PARTITION BY  sched_id
                              ORDER BY    __$start_lsn DESC 
                                        , __$seqval DESC
                           ) AS Precedence
    FROM DW_Staging.orion_temp.utl_pp_schedule
    WHERE __$operation = 4    --1 = delete; 2 = insert; 3 = before update; 4 = after update
       )
    SELECT  sched_id
          , price_plan_id
          , sched_type_id
          , meter_type_id
          , capacity_id
          , band_header_id
          , active
          , insert_datetime
          , insert_user
          , insert_process
          , update_datetime
          , update_user
          , update_process
          , contractable
          , summ_all_in_class
          , invoice_desc
          , seq_account_id
    FROM  utl_pp_schedule_with_row_precedence
    WHERE Precedence = 1



GO
