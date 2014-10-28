USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SystemParameters](
	[parameter_name] [varchar](100) NOT NULL,
	[parameter_value] [varchar](100) NOT NULL,
	[modified_date] [datetime] NOT NULL CONSTRAINT [DF_SystemParameters_modified_date]  DEFAULT (getdate()),
	[modified_by] [varchar](50) NOT NULL CONSTRAINT [DF_SystemParameters_modified_by]  DEFAULT (suser_sname()),
	[parameter_description] [varchar](150) NULL,
 CONSTRAINT [PK_system_parameters] PRIMARY KEY CLUSTERED 
(
	[parameter_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
