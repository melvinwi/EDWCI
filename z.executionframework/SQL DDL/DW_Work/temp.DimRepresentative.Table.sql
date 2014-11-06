USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimRepresentative](
	[RepresentativeKey] [int] NULL DEFAULT (NULL),
	[RepresentativeFirstName] [nvarchar](100) NULL DEFAULT (NULL),
	[RepresentativeMiddleInitial] [nchar](10) NULL DEFAULT (NULL),
	[RepresentativeLastName] [nvarchar](100) NULL DEFAULT (NULL),
	[RepresentativePartyName] [nvarchar](100) NULL DEFAULT (NULL)
) ON [data]

GO
