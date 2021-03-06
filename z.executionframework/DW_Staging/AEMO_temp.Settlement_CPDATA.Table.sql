USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [AEMO_temp].[Settlement_CPDATA](
	[SettlementDate] [date] NULL,
	[VersionNo] [int] NULL,
	[PeriodId] [int] NULL,
	[ParticipantId] [varchar](10) NULL,
	[TcpId] [varchar](10) NULL,
	[RegionId] [varchar](10) NULL,
	[IgEnergy] [decimal](25, 15) NULL,
	[XgEnergy] [decimal](25, 15) NULL,
	[InEnergy] [decimal](25, 15) NULL,
	[XnEnergy] [decimal](25, 15) NULL,
	[Ipower] [decimal](25, 15) NULL,
	[Xpower] [decimal](25, 15) NULL,
	[RRP] [decimal](25, 15) NULL,
	[EEP] [decimal](25, 15) NULL,
	[TLF] [decimal](25, 15) NULL,
	[CPRRP] [decimal](25, 15) NULL,
	[CPEEP] [decimal](25, 15) NULL,
	[TA] [decimal](25, 15) NULL,
	[EP] [decimal](25, 15) NULL,
	[APC] [decimal](25, 15) NULL,
	[ResC] [decimal](25, 15) NULL,
	[ResP] [decimal](25, 15) NULL,
	[MeterRunNo] [int] NULL,
	[HostDistributor] [varchar](10) NULL,
	[MDA] [varchar](10) NULL,
	[LastChanged] [datetime2](0) NULL,
	[MeterData_Source] [date] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
	[Meta_InsertOrder] [int] IDENTITY(1,1) NOT NULL
) ON [data]

GO
SET ANSI_PADDING OFF
GO
USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [AEMO_temp].[Settlement_CPDATA](
	[SettlementDate] [date] NOT NULL,
	[VersionNo] [int] NOT NULL,
	[PeriodId] [int] NOT NULL,
	[ParticipantId] [varchar](10) NOT NULL,
	[TcpId] [varchar](10) NOT NULL,
	[RegionId] [varchar](10) NULL,
	[IgEnergy] [decimal](25, 15) NULL,
	[XgEnergy] [decimal](25, 15) NULL,
	[InEnergy] [decimal](25, 15) NULL,
	[XnEnergy] [decimal](25, 15) NULL,
	[Ipower] [decimal](25, 15) NULL,
	[Xpower] [decimal](25, 15) NULL,
	[RRP] [decimal](25, 15) NULL,
	[EEP] [decimal](25, 15) NULL,
	[TLF] [decimal](25, 15) NULL,
	[CPRRP] [decimal](25, 15) NULL,
	[CPEEP] [decimal](25, 15) NULL,
	[TA] [decimal](25, 15) NULL,
	[EP] [decimal](25, 15) NULL,
	[APC] [decimal](25, 15) NULL,
	[ResC] [decimal](25, 15) NULL,
	[ResP] [decimal](25, 15) NULL,
	[MeterRunNo] [int] NULL,
	[HostDistributor] [varchar](10) NULL,
	[MDA] [varchar](10) NOT NULL,
	[LastChanged] [datetime2](0) NULL,
	[MeterData_Source] [varchar](10) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
	[Meta_InsertOrder] [int] IDENTITY(1,1) NOT NULL
) ON [DATA]

GO
SET ANSI_PADDING OFF
GO
