USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [config].[Application](
	[ApplicationID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationName] [nvarchar](50) NOT NULL,
	[RecoveryActionCode] [nchar](1) NOT NULL,
	[AllowParallelExecution] [bit] NOT NULL,
	[ParallelChannels] [int] NOT NULL,
	[IsDisabled] [bit] NOT NULL CONSTRAINT [DF_Application_IsDisabled]  DEFAULT ('0'),
 CONSTRAINT [PK_Application] PRIMARY KEY CLUSTERED 
(
	[ApplicationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
