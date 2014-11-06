USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DatabaseBackupIgnore](
	[database_name] [sysname] NOT NULL,
	[ignore_full] [char](1) NOT NULL,
	[ignore_diff] [char](1) NOT NULL,
	[ignore_log] [char](1) NOT NULL,
	[num_files] [int] NOT NULL CONSTRAINT [DF_DatabaseBackupIgnore_num_files]  DEFAULT ((1)),
	[modified_date] [datetime] NOT NULL CONSTRAINT [DF_DatabaseBackupIgnore_modified_date]  DEFAULT (getdate()),
	[modified_by] [sysname] NOT NULL CONSTRAINT [DF_DatabaseBackupIgnore_modified_by]  DEFAULT (suser_sname()),
 CONSTRAINT [PK_database_ignore_backup] PRIMARY KEY CLUSTERED 
(
	[database_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[DatabaseBackupIgnore]  WITH CHECK ADD  CONSTRAINT [CK_DatabaseBackupIgnore_diff] CHECK  (([ignore_diff]='Y' OR [ignore_diff]='N'))
GO
ALTER TABLE [dbo].[DatabaseBackupIgnore] CHECK CONSTRAINT [CK_DatabaseBackupIgnore_diff]
GO
ALTER TABLE [dbo].[DatabaseBackupIgnore]  WITH CHECK ADD  CONSTRAINT [CK_DatabaseBackupIgnore_full] CHECK  (([ignore_full]='Y' OR [ignore_full]='N'))
GO
ALTER TABLE [dbo].[DatabaseBackupIgnore] CHECK CONSTRAINT [CK_DatabaseBackupIgnore_full]
GO
ALTER TABLE [dbo].[DatabaseBackupIgnore]  WITH CHECK ADD  CONSTRAINT [CK_DatabaseBackupIgnore_log] CHECK  (([ignore_log]='Y' OR [ignore_log]='N'))
GO
ALTER TABLE [dbo].[DatabaseBackupIgnore] CHECK CONSTRAINT [CK_DatabaseBackupIgnore_log]
GO
