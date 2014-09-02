USE [DW_Dimensional]
GO

/****** Object:  Table [DW].[DimAccount]    Script Date: 2/09/2014 12:13:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [DW].[DimAccount](
	[AccountId] [int] IDENTITY(1,1) NOT NULL,
	[AccountKey] [int] NULL DEFAULT (NULL),
	[AccountCode] [int] NULL DEFAULT (NULL),
	[PostalAddressLine1] [nvarchar](100) NULL DEFAULT (NULL),
	[PostalSuburb] [nvarchar](50) NULL DEFAULT (NULL),
	[PostalPostcode] [nchar](4) NULL DEFAULT (NULL),
	[PostalState] [nchar](3) NULL DEFAULT (NULL),
	[PostalStateAsProvided] [nchar](3) NULL DEFAULT (NULL),
	[MyAccountStatus] [nvarchar](14) NULL DEFAULT (NULL),
	[CreationDate] [date] NULL DEFAULT (NULL),
	[AccountStatus] [nchar](10) NULL DEFAULT (NULL),
	[AccountClosedDate] [date] NULL DEFAULT (NULL),
	[AccountBillStartDate] [date] NULL DEFAULT (NULL),
	[CreditControlStatus] [nvarchar](50) NULL DEFAULT (NULL),
	[InvoiceDeliveryMethod] [nvarchar](30) NULL DEFAULT (NULL),
	[PaymentMethod] [nvarchar](20) NULL DEFAULT (NULL),
	[Meta_IsCurrent] [bit] NOT NULL,
	[Meta_EffectiveStartDate] [datetime2](0) NOT NULL,
	[Meta_EffectiveEndDate] [datetime2](0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_DW.DimAccount] PRIMARY KEY CLUSTERED 
(
	[AccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

