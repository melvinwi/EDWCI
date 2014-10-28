USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimCustomer](
	[CustomerKey] [int] NULL,
	[CustomerCode] [int] NULL,
	[Title] [nchar](3) NULL,
	[FirstName] [nvarchar](100) NULL,
	[MiddleInitial] [nchar](10) NULL,
	[LastName] [nvarchar](100) NULL,
	[PartyName] [nvarchar](100) NULL,
	[PostalAddressLine1] [nvarchar](100) NULL,
	[PostalSuburb] [nvarchar](50) NULL,
	[PostalPostcode] [nchar](4) NULL,
	[PostalState] [nchar](3) NULL,
	[PostalStateAsProvided] [nchar](3) NULL,
	[ResidentialAddressLine1] [nvarchar](100) NULL,
	[ResidentialSuburb] [nvarchar](50) NULL,
	[ResidentialPostcode] [nchar](4) NULL,
	[ResidentialState] [nchar](3) NULL,
	[ResidentialStateAsProvided] [nchar](3) NULL,
	[PrimaryPhone] [nvarchar](24) NULL,
	[PrimaryPhoneType] [nchar](8) NULL,
	[SecondaryPhone] [nvarchar](24) NULL,
	[SecondaryPhoneType] [nchar](8) NULL,
	[MobilePhone] [nchar](10) NULL,
	[Email] [nvarchar](100) NULL,
	[DateOfBirth] [date] NULL,
	[CustomerType] [nchar](11) NULL,
	[CustomerStatus] [nchar](8) NULL,
	[OmbudsmanComplaints] [nchar](3) NULL,
	[CreationDate] [date] NULL,
	[JoinDate] [date] NULL,
	[PrivacyPreferredStatus] [nvarchar](30) NULL
) ON [PRIMARY]

GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [CustomerKey]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [CustomerCode]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [Title]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [FirstName]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [MiddleInitial]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [LastName]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [PartyName]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [PostalAddressLine1]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [PostalSuburb]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [PostalPostcode]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [PostalState]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [PostalStateAsProvided]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [ResidentialAddressLine1]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [ResidentialSuburb]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [ResidentialPostcode]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [ResidentialState]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [ResidentialStateAsProvided]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [PrimaryPhone]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [PrimaryPhoneType]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [SecondaryPhone]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [SecondaryPhoneType]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [MobilePhone]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [Email]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [DateOfBirth]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [CustomerType]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [CustomerStatus]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [OmbudsmanComplaints]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [CreationDate]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [JoinDate]
GO
ALTER TABLE [temp].[DimCustomer] ADD  DEFAULT (NULL) FOR [PrivacyPreferredStatus]
GO
