USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[DimTransmissionNode](
	[TransmissionNodeId] [int] IDENTITY(1,1) NOT NULL,
	[TransmissionNodeKey] [int] NULL,
	[TransmissionNodeIdentity] [nvarchar](20) NULL,
	[TransmissionNodeName] [nvarchar](100) NULL,
	[TransmissionNodeState] [nchar](3) NULL,
	[TransmissionNodeNetwork] [nvarchar](100) NULL,
	[TransmissionNodeServiceType] [nvarchar](11) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
	[TransmissionNodeLossFactor] [decimal](6, 4) NULL,
 CONSTRAINT [PK_DW.DimTransmissionNode] PRIMARY KEY CLUSTERED 
(
	[TransmissionNodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [DATA]
) ON [DATA]

GO
