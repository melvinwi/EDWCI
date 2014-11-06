USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DatabaseStatisticsIgnore](
	[database_name] [sysname] NOT NULL,
	[ignore_statistics] [char](1) NOT NULL,
	[modified_date] [datetime] NOT NULL CONSTRAINT [DF_DatabaseStatisticsIgnore_modified_date]  DEFAULT (getdate()),
	[modified_by] [sysname] NOT NULL CONSTRAINT [DF_DatabaseStatisticsIgnore_modified_by]  DEFAULT (suser_sname()),
 CONSTRAINT [PK_database_statistics_ignore] PRIMARY KEY CLUSTERED 
(
	[database_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[DatabaseStatisticsIgnore]  WITH CHECK ADD  CONSTRAINT [CK_DatabaseStatisticsIgnore_diff] CHECK  (([ignore_statistics]='Y' OR [ignore_statistics]='N'))
GO
ALTER TABLE [dbo].[DatabaseStatisticsIgnore] CHECK CONSTRAINT [CK_DatabaseStatisticsIgnore_diff]
GO
