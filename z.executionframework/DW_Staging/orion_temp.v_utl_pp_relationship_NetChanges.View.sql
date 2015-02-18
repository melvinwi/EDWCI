USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [orion_temp].[v_utl_pp_relationship_NetChanges] AS

WITH utl_utl_pp_relationship_with_row_precedence
    AS (
    SELECT  price_plan_id
          , pp_simple_sched_id
          , allowed
          , active
          , insert_datetime
          , insert_user
          , insert_process
          , update_datetime
          , update_user
          , update_process
          , default_plan
          , ROW_NUMBER() OVER(PARTITION BY  price_plan_id
                                          , pp_simple_sched_id
                              ORDER BY  __$start_lsn  DESC 
                                      , __$seqval     DESC
                           ) AS Precedence
    FROM DW_Staging.orion_temp.utl_pp_relationship
    WHERE __$operation IN (2,4)    --1 = delete; 2 = insert; 3 = before update; 4 = after update
       )
    SELECT  price_plan_id
          , pp_simple_sched_id
          , allowed
          , active
          , insert_datetime
          , insert_user
          , insert_process
          , update_datetime
          , update_user
          , update_process
          , default_plan
    FROM  utl_utl_pp_relationship_with_row_precedence
    WHERE Precedence = 1




GO
USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [orion_temp].[v_utl_pp_relationship_NetChanges] AS

WITH utl_utl_pp_relationship_with_row_precedence
    AS (
    SELECT  price_plan_id
          , pp_simple_sched_id
          , allowed
          , active
          , insert_datetime
          , insert_user
          , insert_process
          , update_datetime
          , update_user
          , update_process
          , default_plan
          , ROW_NUMBER() OVER(PARTITION BY  price_plan_id
                                          , pp_simple_sched_id
                              ORDER BY  __$start_lsn  DESC 
                                      , __$seqval     DESC
                           ) AS Precedence
    FROM DW_Staging.orion_temp.utl_pp_relationship
    WHERE __$operation IN (2,4)    --1 = delete; 2 = insert; 3 = before update; 4 = after update
       )
    SELECT  price_plan_id
          , pp_simple_sched_id
          , allowed
          , active
          , insert_datetime
          , insert_user
          , insert_process
          , update_datetime
          , update_user
          , update_process
          , default_plan
    FROM  utl_utl_pp_relationship_with_row_precedence
    WHERE Precedence = 1

GO
