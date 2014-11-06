USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[DatabaseCheckControl](
	[database_name] [sysname] NOT NULL,
	[check_type] [char](1) NOT NULL,
	[modified_date] [datetime] NOT NULL CONSTRAINT [DF_DatabaseCheckControl_modified_date]  DEFAULT (getdate()),
	[modified_by] [varchar](50) NOT NULL CONSTRAINT [DF_DatabaseCheckControl_modified_by]  DEFAULT (suser_sname()),
 CONSTRAINT [PK_DatabaseCheckControl] PRIMARY KEY CLUSTERED 
(
	[database_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
