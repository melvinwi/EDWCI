USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [complaints_temp].[Complaint](
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
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_Complaints_temp_Complaint] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
