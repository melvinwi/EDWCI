USE [DW_Utility]
GO
/****** Object:  Table [config].[FrameworkCodes]    Script Date: 16/10/2014 7:18:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [config].[FrameworkCodes](
	[CodeType] [nvarchar](50) NOT NULL,
	[FrameworkCode] [nchar](1) NOT NULL,
	[CodeDescription] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_FrameworkCodes] PRIMARY KEY CLUSTERED 
(
	[FrameworkCode] ASC,
	[CodeType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
