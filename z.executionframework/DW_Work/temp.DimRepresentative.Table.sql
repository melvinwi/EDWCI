USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimRepresentative](
	[RepresentativeKey] [int] NULL,
	[RepresentativeFirstName] [nvarchar](100) NULL,
	[RepresentativeMiddleInitial] [nchar](10) NULL,
	[RepresentativeLastName] [nvarchar](100) NULL,
	[RepresentativePartyName] [nvarchar](100) NULL
) ON [data]

GO
ALTER TABLE [temp].[DimRepresentative] ADD  DEFAULT (NULL) FOR [RepresentativeKey]
GO
ALTER TABLE [temp].[DimRepresentative] ADD  DEFAULT (NULL) FOR [RepresentativeFirstName]
GO
ALTER TABLE [temp].[DimRepresentative] ADD  DEFAULT (NULL) FOR [RepresentativeMiddleInitial]
GO
ALTER TABLE [temp].[DimRepresentative] ADD  DEFAULT (NULL) FOR [RepresentativeLastName]
GO
ALTER TABLE [temp].[DimRepresentative] ADD  DEFAULT (NULL) FOR [RepresentativePartyName]
GO
