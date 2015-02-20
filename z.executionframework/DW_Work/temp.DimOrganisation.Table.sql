USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimOrganisation](
	[OrganisationKey] [int] NULL,
	[OrganisationName] [nvarchar](100) NULL,
	[Level1Name] [nvarchar](100) NULL,
	[Level2Name] [nvarchar](100) NULL,
	[Level3Name] [nvarchar](100) NULL,
	[Level4Name] [nvarchar](100) NULL
) ON [data]

GO
ALTER TABLE [temp].[DimOrganisation] ADD  DEFAULT (NULL) FOR [OrganisationKey]
GO
ALTER TABLE [temp].[DimOrganisation] ADD  DEFAULT (NULL) FOR [OrganisationName]
GO
ALTER TABLE [temp].[DimOrganisation] ADD  DEFAULT (NULL) FOR [Level1Name]
GO
ALTER TABLE [temp].[DimOrganisation] ADD  DEFAULT (NULL) FOR [Level2Name]
GO
ALTER TABLE [temp].[DimOrganisation] ADD  DEFAULT (NULL) FOR [Level3Name]
GO
ALTER TABLE [temp].[DimOrganisation] ADD  DEFAULT (NULL) FOR [Level4Name]
GO
USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimOrganisation](
	[OrganisationKey] [int] NULL,
	[OrganisationName] [nvarchar](100) NULL,
	[Level1Name] [nvarchar](100) NULL,
	[Level2Name] [nvarchar](100) NULL,
	[Level3Name] [nvarchar](100) NULL,
	[Level4Name] [nvarchar](100) NULL
) ON [DATA]

GO
ALTER TABLE [temp].[DimOrganisation] ADD  DEFAULT (NULL) FOR [OrganisationKey]
GO
ALTER TABLE [temp].[DimOrganisation] ADD  DEFAULT (NULL) FOR [OrganisationName]
GO
ALTER TABLE [temp].[DimOrganisation] ADD  DEFAULT (NULL) FOR [Level1Name]
GO
ALTER TABLE [temp].[DimOrganisation] ADD  DEFAULT (NULL) FOR [Level2Name]
GO
ALTER TABLE [temp].[DimOrganisation] ADD  DEFAULT (NULL) FOR [Level3Name]
GO
ALTER TABLE [temp].[DimOrganisation] ADD  DEFAULT (NULL) FOR [Level4Name]
GO
