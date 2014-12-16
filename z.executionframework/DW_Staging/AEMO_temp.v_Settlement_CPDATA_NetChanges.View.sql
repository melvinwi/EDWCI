USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [AEMO_temp].[v_Settlement_CPDATA_NetChanges] AS

WITH utl_Settlement_CPDATA_with_row_precedence
    AS (
    SELECT  [SettlementDate]
          , [VersionNo]
          , [PeriodId]
          , [ParticipantId]
          , [TcpId]
          , [RegionId]
          , [IgEnergy]
          , [XgEnergy]
          , [InEnergy]
          , [XnEnergy]
          , [Ipower]
          , [Xpower]
          , [RRP]
          , [EEP]
          , [TLF]
          , [CPRRP]
          , [CPEEP]
          , [TA]
          , [EP]
          , [APC]
          , [ResC]
          , [ResP]
          , [MeterRunNo]
          , [HostDistributor]
          , [MDA]
          , [LastChanged]
          , [MeterData_Source]
          , ROW_NUMBER() OVER(PARTITION BY  SettlementDate
                                          , VersionNo
                                          , PeriodId
                                          , ParticipantId
                                          , TcpId
                                          , MDA
                              ORDER BY      Meta_InsertOrder DESC
                           ) AS Precedence
    FROM DW_Staging.AEMO_temp.Settlement_CPDATA
       )
    SELECT  [SettlementDate]
          , [VersionNo]
          , [PeriodId]
          , [ParticipantId]
          , [TcpId]
          , [RegionId]
          , [IgEnergy]
          , [XgEnergy]
          , [InEnergy]
          , [XnEnergy]
          , [Ipower]
          , [Xpower]
          , [RRP]
          , [EEP]
          , [TLF]
          , [CPRRP]
          , [CPEEP]
          , [TA]
          , [EP]
          , [APC]
          , [ResC]
          , [ResP]
          , [MeterRunNo]
          , [HostDistributor]
          , [MDA]
          , [LastChanged]
          , [MeterData_Source]
    FROM  utl_Settlement_CPDATA_with_row_precedence
    WHERE Precedence = 1






GO
