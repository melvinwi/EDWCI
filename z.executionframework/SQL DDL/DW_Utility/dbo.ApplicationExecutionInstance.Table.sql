USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationExecutionInstance](
	[ApplicationExecutionInstanceID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationID] [int] NOT NULL,
	[ApplicationName] [nvarchar](50) NOT NULL,
	[RecoveryActionCode] [nchar](1) NOT NULL,
	[StartDateTime] [datetime2](2) NULL,
	[EndDateTime] [datetime2](2) NULL,
	[StatusCode] [nchar](1) NOT NULL,
	[ExecutionAborted] [bit] NOT NULL CONSTRAINT [DF_ApplicationExecutionInstance_ExecutionAborted]  DEFAULT ('0'),
	[SSISExecutionID] [bigint] NULL,
	[PackageExecutionID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_ApplicationExecutionInstance] PRIMARY KEY CLUSTERED 
(
	[ApplicationExecutionInstanceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
