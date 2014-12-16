USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [AEMO_temp].[v_Level2_CSVData_NetChanges] AS


WITH utl_Level2_CSVData_with_row_precedence
    AS (
    SELECT  MessageID
          , transactionID
          , SettlementCase
          , TNI
          , LR
          , MDP
          , SettlementDate
          , NMI
          , DataType
          , MSATS_Est
          , Total_Energy
          , SeqNo
          , ROW_NUMBER() OVER(PARTITION BY  SettlementCase
                                          , SettlementDate
                                          , NMI
                                          , SeqNo
                              ORDER BY      Meta_InsertOrder DESC
                           ) AS Precedence
    FROM DW_Staging.AEMO_temp.Level2_CSVData
       )
    SELECT  MessageID
          , transactionID
          , SettlementCase
          , TNI
          , LR
          , MDP
          , SettlementDate
          , NMI
          , DataType
          , MSATS_Est
          , Total_Energy
          , SeqNo
    FROM  utl_Level2_CSVData_with_row_precedence
    WHERE Precedence = 1





GO
