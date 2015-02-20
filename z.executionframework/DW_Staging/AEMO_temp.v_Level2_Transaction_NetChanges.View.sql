USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [AEMO_temp].[v_Level2_Transaction_NetChanges] AS


WITH utl_Level2_Transaction_with_row_precedence
    AS (
    SELECT  transactionID
          , transactionDate
          , initiatingTransactionID
          , ReportName
          , SettlementCase
          , FromDate
          , ToDate
          , LastSequenceNumber
          , TransmissionNodeIdentifier
          , LR
          , MDP
          , ROW_NUMBER() OVER(PARTITION BY  transactionID
                              ORDER BY      Meta_InsertOrder DESC
                           ) AS Precedence
    FROM DW_Staging.AEMO_temp.Level2_Transaction
       )
    SELECT  transactionID
          , transactionDate
          , initiatingTransactionID
          , ReportName
          , SettlementCase
          , FromDate
          , ToDate
          , LastSequenceNumber
          , TransmissionNodeIdentifier
          , LR
          , MDP
    FROM  utl_Level2_Transaction_with_row_precedence
    WHERE Precedence = 1





GO
USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [AEMO_temp].[v_Level2_Transaction_NetChanges] AS


WITH utl_Level2_Transaction_with_row_precedence
    AS (
    SELECT  transactionID
          , transactionDate
          , initiatingTransactionID
          , ReportName
          , SettlementCase
          , FromDate
          , ToDate
          , LastSequenceNumber
          , TransmissionNodeIdentifier
          , LR
          , MDP
          , ROW_NUMBER() OVER(PARTITION BY  transactionID
                              ORDER BY      Meta_InsertOrder DESC
                           ) AS Precedence
    FROM DW_Staging.AEMO_temp.Level2_Transaction
       )
    SELECT  transactionID
          , transactionDate
          , initiatingTransactionID
          , ReportName
          , SettlementCase
          , FromDate
          , ToDate
          , LastSequenceNumber
          , TransmissionNodeIdentifier
          , LR
          , MDP
    FROM  utl_Level2_Transaction_with_row_precedence
    WHERE Precedence = 1

GO
