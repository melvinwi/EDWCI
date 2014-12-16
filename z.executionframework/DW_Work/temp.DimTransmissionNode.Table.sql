USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimTransmissionNode](
	[TransmissionNodeKey] [int] NULL,
	[TransmissionNodeIdentity] [nvarchar](20) NULL,
	[TransmissionNodeName] [nvarchar](100) NULL,
	[TransmissionNodeState] [nchar](3) NULL,
	[TransmissionNodeNetwork] [nvarchar](100) NULL,
	[TransmissionNodeServiceType] [nvarchar](11) NULL,
	[TransmissionNodeLossFactor] [decimal](6, 4) NULL
) ON [data]

GO
