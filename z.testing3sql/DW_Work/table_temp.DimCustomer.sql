USE [DW_Work]
GO

/****** Object:  Table [temp].[DimCustomer]    Script Date: 2/09/2014 12:10:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [temp].[DimCustomer](
	[CustomerKey] [int] NULL DEFAULT (NULL),
	[CustomerCode] [int] NULL DEFAULT (NULL),
	[Title] [nchar](3) NULL DEFAULT (NULL),
	[FirstName] [nvarchar](100) NULL DEFAULT (NULL),
	[MiddleInitial] [nchar](10) NULL DEFAULT (NULL),
	[LastName] [nvarchar](100) NULL DEFAULT (NULL),
	[PartyName] [nvarchar](100) NULL DEFAULT (NULL),
	[PostalAddressLine1] [nvarchar](100) NULL DEFAULT (NULL),
	[PostalSuburb] [nvarchar](50) NULL DEFAULT (NULL),
	[PostalPostcode] [nchar](4) NULL DEFAULT (NULL),
	[PostalState] [nchar](3) NULL DEFAULT (NULL),
	[PostalStateAsProvided] [nchar](3) NULL DEFAULT (NULL),
	[ResidentialAddressLine1] [nvarchar](100) NULL DEFAULT (NULL),
	[ResidentialSuburb] [nvarchar](50) NULL DEFAULT (NULL),
	[ResidentialPostcode] [nchar](4) NULL DEFAULT (NULL),
	[ResidentialState] [nchar](3) NULL DEFAULT (NULL),
	[ResidentialStateAsProvided] [nchar](3) NULL DEFAULT (NULL),
	[PrimaryPhone] [nvarchar](24) NULL DEFAULT (NULL),
	[PrimaryPhoneType] [nchar](8) NULL DEFAULT (NULL),
	[SecondaryPhone] [nvarchar](24) NULL DEFAULT (NULL),
	[SecondaryPhoneType] [nchar](8) NULL DEFAULT (NULL),
	[MobilePhone] [nchar](10) NULL DEFAULT (NULL),
	[Email] [nvarchar](100) NULL DEFAULT (NULL),
	[DateOfBirth] [date] NULL DEFAULT (NULL),
	[CustomerType] [nchar](11) NULL DEFAULT (NULL),
	[CustomerStatus] [nchar](8) NULL DEFAULT (NULL),
	[OmbudsmanComplaints] [nchar](3) NULL DEFAULT (NULL),
	[CreationDate] [date] NULL DEFAULT (NULL),
	[JoinDate] [date] NULL DEFAULT (NULL),
	[PrivacyPreferredStatus] [nvarchar](30) NULL DEFAULT (NULL)
) ON [PRIMARY]

GO

