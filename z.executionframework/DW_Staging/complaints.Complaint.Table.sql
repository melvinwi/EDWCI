USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [complaints].[Complaint](
	[Id] [int] NOT NULL,
	[DateCreated] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[AssignedTo] [nvarchar](100) NULL,
	[StatusId] [int] NULL,
	[ClientId] [nvarchar](100) NULL,
	[Department_Id] [int] NULL,
	[IsExternalParty] [bit] NULL,
	[ExternalPartyId] [int] NULL,
	[IsBreach] [bit] NULL,
	[IsOmbudsman] [bit] NULL,
	[OmbbudsmanReference] [nvarchar](100) NULL,
	[OmbudsmanCaseLevelState] [int] NULL,
	[PendingReasonId] [int] NULL,
	[ProductElectricity] [bit] NULL,
	[ProductGas] [bit] NULL,
	[ProductTelco] [bit] NULL,
	[isResidential] [bit] NULL,
	[altNumber] [nvarchar](100) NULL,
	[Category_Id] [int] NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_Complaint] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
CREATE NONCLUSTERED INDEX [IX_complaints_Complaint_Meta_LatestUpdateId] ON [complaints].[Complaint]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [complaints].[Complaint](
	[Id] [int] NOT NULL,
	[DateCreated] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[CreatedBy] [nvarchar](100) NULL,
	[AssignedTo] [nvarchar](100) NULL,
	[StatusId] [int] NULL,
	[ClientId] [nvarchar](100) NULL,
	[Department_Id] [int] NULL,
	[IsExternalParty] [bit] NULL,
	[ExternalPartyId] [int] NULL,
	[IsBreach] [bit] NULL,
	[IsOmbudsman] [bit] NULL,
	[OmbbudsmanReference] [nvarchar](100) NULL,
	[OmbudsmanCaseLevelState] [int] NULL,
	[PendingReasonId] [int] NULL,
	[ProductElectricity] [bit] NULL,
	[ProductGas] [bit] NULL,
	[ProductTelco] [bit] NULL,
	[isResidential] [bit] NULL,
	[altNumber] [nvarchar](100) NULL,
	[Category_Id] [int] NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_Complaint] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
CREATE NONCLUSTERED INDEX [IX_complaints_Complaint_Meta_LatestUpdateId] ON [complaints].[Complaint]
(
	[Meta_LatestUpdate_TaskExecutionInstanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [INDEX]
GO
