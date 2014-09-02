USE [DW_Dimensional]
GO

/****** Object:  Table [DW].[DimCustomer]    Script Date: 2/09/2014 12:13:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DW].[DimCustomer](
	[CustomerId] [int] IDENTITY(1,1) NOT NULL,
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
	[PrivacyPreferredStatus] [nvarchar](30) NULL DEFAULT (NULL),
	[Meta_IsCurrent] [bit] NOT NULL,
	[Meta_EffectiveStartDate] [datetime2](0) NOT NULL,
	[Meta_EffectiveEndDate] [datetime2](0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_DW.DimCustomer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

