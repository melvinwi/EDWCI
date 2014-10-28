USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [orion_temp].[v_utl_pp_schedule_class_NetChanges] AS


WITH utl_pp_schedule_class_with_row_precedence
    AS (
    SELECT  sched_class_id
          , sched_class_code
          , sched_class_desc
          , active
          , insert_datetime
          , insert_user
          , insert_process
          , update_datetime
          , update_user
          , update_process
          , ROW_NUMBER() OVER(PARTITION BY  sched_class_id
                              ORDER BY    __$start_lsn DESC 
                                        , __$seqval DESC
                           ) AS Precedence
    FROM DW_Staging.orion_temp.utl_pp_schedule_class
    WHERE __$operation = 4    --1 = delete; 2 = insert; 3 = before update; 4 = after update
       )
    SELECT  sched_class_id
          , sched_class_code
          , sched_class_desc
          , active
          , insert_datetime
          , insert_user
          , insert_process
          , update_datetime
          , update_user
          , update_process
    FROM  utl_pp_schedule_class_with_row_precedence
    WHERE Precedence = 1


GO
