USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[DimService](
	[ServiceId] [int] IDENTITY(1,1) NOT NULL,
	[ServiceKey] [int] NULL DEFAULT (NULL),
	[MarketIdentifier] [nvarchar](30) NULL DEFAULT (NULL),
	[ServiceType] [nvarchar](11) NULL DEFAULT (NULL),
	[Meta_IsCurrent] [bit] NOT NULL,
	[Meta_EffectiveStartDate] [datetime2](0) NOT NULL,
	[Meta_EffectiveEndDate] [datetime2](0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
	[LossFactor] [decimal](6, 4) NULL,
	[EstimatedDailyConsumption] [decimal](18, 6) NULL,
	[MeteringType] [nchar](6) NULL,
	[ResidentialSuburb] [nvarchar](100) NULL,
	[ResidentialPostcode] [nchar](4) NULL,
	[ResidentialState] [nchar](3) NULL,
	[NextScheduledReadDate] [date] NULL,
	[FRMPDate] [date] NULL,
	[Threshold] [nvarchar](40) NULL,
	[TransmissionNodeId] [int] NULL,
	[FirstImportRegisterDate] [date] NULL,
	[SiteStatus] [nvarchar](30) NULL,
	[SiteStatusType] [nvarchar](20) NULL,
 CONSTRAINT [PK_DW.DimService] PRIMARY KEY CLUSTERED 
(
	[ServiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
CREATE NONCLUSTERED INDEX [_dta_index_DimService_9_1945773989__K1_K2] ON [DW].[DimService]
(
	[ServiceId] ASC,
	[ServiceKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [_dta_index_DimService_9_1945773989__K1_K4_10_11] ON [DW].[DimService]
(
	[ServiceId] ASC,
	[ServiceType] ASC
)
INCLUDE ( 	[LossFactor],
	[EstimatedDailyConsumption]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [_dta_index_DimService_9_1945773989__K1_K4_11] ON [DW].[DimService]
(
	[ServiceId] ASC,
	[ServiceType] ASC
)
INCLUDE ( 	[EstimatedDailyConsumption]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [_dta_index_DimService_9_1945773989__K15_K5_K2_K1_17] ON [DW].[DimService]
(
	[ResidentialState] ASC,
	[Meta_IsCurrent] ASC,
	[ServiceKey] ASC,
	[ServiceId] ASC
)
INCLUDE ( 	[FRMPDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [_dta_index_DimService_9_1945773989__K5_1_3_4] ON [DW].[DimService]
(
	[Meta_IsCurrent] ASC
)
INCLUDE ( 	[ServiceId],
	[MarketIdentifier],
	[ServiceType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
CREATE NONCLUSTERED INDEX [_dta_index_DimService_9_1945773989__K5_K2_K1] ON [DW].[DimService]
(
	[Meta_IsCurrent] ASC,
	[ServiceKey] ASC,
	[ServiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [IX_DW_DimService_ResidentialState] ON [DW].[DimService]
(
	[Meta_IsCurrent] ASC
)
INCLUDE ( 	[ServiceKey],
	[ResidentialState]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
