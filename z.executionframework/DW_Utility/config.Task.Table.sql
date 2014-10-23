USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [config].[Task](
	[TaskID] [int] IDENTITY(1,1) NOT NULL,
	[TaskName] [nvarchar](255) NOT NULL,
	[ApplicationID] [int] NOT NULL CONSTRAINT [DF_Task_ApplicationID]  DEFAULT ((-1)),
	[PackageID] [int] NOT NULL CONSTRAINT [DF_Task_PackageID]  DEFAULT ((-1)),
	[ParallelChannel] [int] NOT NULL CONSTRAINT [DF_Task_ParallelChannel]  DEFAULT ((1)),
	[ExecutionOrder] [int] NOT NULL CONSTRAINT [DF_Task_ExecutionOrder]  DEFAULT ((99)),
	[PrecedentTaskIds] [nvarchar](1000) NULL,
	[ExecuteAsync] [bit] NOT NULL CONSTRAINT [DF_Task_ExecuteAsync]  DEFAULT ((0)),
	[FailureActionCode] [nchar](1) NOT NULL CONSTRAINT [DF_Task_FailureActionCode]  DEFAULT (N'A'),
	[RecoveryActionCode] [nchar](1) NOT NULL CONSTRAINT [DF_Task_RecoveryActionCode]  DEFAULT (N'R'),
	[LastRunDateTime] [datetime2](2) NULL,
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_Task_IsActive]  DEFAULT ((1)),
	[IsDisabled] [bit] NOT NULL CONSTRAINT [DF_Task_IsDisabled]  DEFAULT ('0'),
 CONSTRAINT [PK_Task] PRIMARY KEY CLUSTERED 
(
	[TaskID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
ALTER TABLE [config].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_Application] FOREIGN KEY([ApplicationID])
REFERENCES [config].[Application] ([ApplicationID])
GO
ALTER TABLE [config].[Task] CHECK CONSTRAINT [FK_Task_Application]
GO
ALTER TABLE [config].[Task]  WITH CHECK ADD  CONSTRAINT [FK_Task_Package] FOREIGN KEY([PackageID])
REFERENCES [config].[Package] ([PackageID])
GO
ALTER TABLE [config].[Task] CHECK CONSTRAINT [FK_Task_Package]
GO
