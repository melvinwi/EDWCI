USE [DW_Utility]
GO
/****** Object:  Table [config].[Package]    Script Date: 16/10/2014 7:18:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [config].[Package](
	[PackageID] [int] IDENTITY(1,1) NOT NULL,
	[PackagePath] [nvarchar](1035) NOT NULL,
	[PackageName] [nvarchar](256) NOT NULL,
	[ProjectName] [nvarchar](520) NOT NULL,
	[FolderName] [nvarchar](256) NOT NULL,
	[IsDisabled] [bit] NOT NULL CONSTRAINT [DF_Package_IsDisabled]  DEFAULT ('0'),
 CONSTRAINT [PK_Package] PRIMARY KEY CLUSTERED 
(
	[PackageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [ucPackageName_ProjectName_FolderName] UNIQUE NONCLUSTERED 
(
	[PackageName] ASC,
	[ProjectName] ASC,
	[FolderName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [ucPackagePath_ProjectName_FolderName] UNIQUE NONCLUSTERED 
(
	[PackagePath] ASC,
	[ProjectName] ASC,
	[FolderName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
