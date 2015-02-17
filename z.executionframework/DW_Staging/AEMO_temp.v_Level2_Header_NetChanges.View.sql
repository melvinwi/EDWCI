USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [AEMO_temp].[v_Level2_Header_NetChanges] AS

WITH utl_Level2_Header_with_row_precedence
    AS (
    SELECT  MessageID
          , [From]
          , [To]
          , MessageDate
          , TransactionGroup
          , [Priority]
          , SecurityContext
          , Market
          , ROW_NUMBER() OVER(PARTITION BY  MessageID
                              ORDER BY      Meta_InsertOrder DESC
                           ) AS Precedence
    FROM DW_Staging.AEMO_temp.Level2_Header
       )
    SELECT  MessageID
          , [From]
          , [To]
          , MessageDate
          , TransactionGroup
          , [Priority]
          , SecurityContext
          , Market
    FROM  utl_Level2_Header_with_row_precedence
    WHERE Precedence = 1





GO
USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [AEMO_temp].[v_Level2_Header_NetChanges] AS

WITH utl_Level2_Header_with_row_precedence
    AS (
    SELECT  MessageID
          , [From]
          , [To]
          , MessageDate
          , TransactionGroup
          , [Priority]
          , SecurityContext
          , Market
          , ROW_NUMBER() OVER(PARTITION BY  MessageID
                              ORDER BY      Meta_InsertOrder DESC
                           ) AS Precedence
    FROM DW_Staging.AEMO_temp.Level2_Header
       )
    SELECT  MessageID
          , [From]
          , [To]
          , MessageDate
          , TransactionGroup
          , [Priority]
          , SecurityContext
          , Market
    FROM  utl_Level2_Header_with_row_precedence
    WHERE Precedence = 1

GO
