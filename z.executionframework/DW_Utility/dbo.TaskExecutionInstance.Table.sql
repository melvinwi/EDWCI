USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaskExecutionInstance](
	[TaskExecutionInstanceID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationExecutionInstanceID] [int] NOT NULL,
	[TaskID] [int] NOT NULL,
	[TaskName] [nvarchar](255) NOT NULL,
	[PrecedentTaskIds] [nvarchar](1000) NULL,
	[PackageName] [nvarchar](256) NOT NULL,
	[ProjectName] [nvarchar](520) NOT NULL,
	[FolderName] [nvarchar](256) NOT NULL,
	[PackagePath] [nvarchar](1035) NOT NULL,
	[FailureActionCode] [nchar](1) NOT NULL,
	[RecoveryActionCode] [nchar](1) NOT NULL,
	[ParallelChannel] [int] NOT NULL,
	[ExecutionOrder] [int] NOT NULL,
	[ExecuteAsync] [bit] NOT NULL,
	[StatusCode] [nchar](1) NOT NULL,
	[StatusUpdateDateTime] [datetime2](2) NOT NULL,
	[StartDateTime] [datetime2](2) NULL,
	[EndDateTime] [datetime2](2) NULL,
	[PackageExecutionID] [uniqueidentifier] NULL,
	[TaskPackageExecutionID] [uniqueidentifier] NULL,
	[TaskPackageID] [uniqueidentifier] NULL,
	[ExtractRowCount] [int] NULL,
	[InsertRowCount] [int] NULL,
	[UpdateRowCount] [int] NULL,
	[DeleteRowCount] [int] NULL,
	[ErrorRowCount] [int] NULL,
 CONSTRAINT [PK_TaskExecutionInstance] PRIMARY KEY CLUSTERED 
(
	[TaskExecutionInstanceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [IX_TaskID_TaskExecutionInstanceID] ON [dbo].[TaskExecutionInstance]
(
	[TaskID] ASC,
	[TaskExecutionInstanceID] ASC
)
INCLUDE ( 	[StatusCode]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [index]
GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaskExecutionInstance](
	[TaskExecutionInstanceID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationExecutionInstanceID] [int] NOT NULL,
	[TaskID] [int] NOT NULL,
	[TaskName] [nvarchar](255) NOT NULL,
	[PrecedentTaskIds] [nvarchar](1000) NULL,
	[PackageName] [nvarchar](256) NOT NULL,
	[ProjectName] [nvarchar](520) NOT NULL,
	[FolderName] [nvarchar](256) NOT NULL,
	[PackagePath] [nvarchar](1035) NOT NULL,
	[FailureActionCode] [nchar](1) NOT NULL,
	[RecoveryActionCode] [nchar](1) NOT NULL,
	[ParallelChannel] [int] NOT NULL,
	[ExecutionOrder] [int] NOT NULL,
	[ExecuteAsync] [bit] NOT NULL,
	[StatusCode] [nchar](1) NOT NULL,
	[StatusUpdateDateTime] [datetime2](2) NOT NULL,
	[StartDateTime] [datetime2](2) NULL,
	[EndDateTime] [datetime2](2) NULL,
	[PackageExecutionID] [uniqueidentifier] NULL,
	[TaskPackageExecutionID] [uniqueidentifier] NULL,
	[TaskPackageID] [uniqueidentifier] NULL,
	[ExtractRowCount] [int] NULL,
	[InsertRowCount] [int] NULL,
	[UpdateRowCount] [int] NULL,
	[DeleteRowCount] [int] NULL,
	[ErrorRowCount] [int] NULL,
 CONSTRAINT [PK_TaskExecutionInstance] PRIMARY KEY CLUSTERED 
(
	[TaskExecutionInstanceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [IX_TaskID_TaskExecutionInstanceID] ON [dbo].[TaskExecutionInstance]
(
	[TaskID] ASC,
	[TaskExecutionInstanceID] ASC
)
INCLUDE ( 	[StatusCode]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
