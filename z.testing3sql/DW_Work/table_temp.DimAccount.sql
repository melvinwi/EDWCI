USE [DW_Work]
GO

/****** Object:  Table [temp].[DimAccount]    Script Date: 2/09/2014 12:10:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [temp].[DimAccount](
	[AccountKey] [int] NULL,
	[AccountCode] [int] NULL,
	[PostalAddressLine1] [nvarchar](100) NULL,
	[PostalSuburb] [nvarchar](50) NULL,
	[PostalPostcode] [nchar](4) NULL,
	[PostalState] [nchar](3) NULL,
	[PostalStateAsProvided] [nchar](3) NULL,
	[MyAccountStatus] [nvarchar](14) NULL,
	[CreationDate] [date] NULL,
	[AccountStatus] [nchar](10) NULL,
	[AccountClosedDate] [date] NULL,
	[AccountBillStartDate] [date] NULL,
	[CreditControlStatus] [nvarchar](50) NULL,
	[InvoiceDeliveryMethod] [nvarchar](30) NULL,
	[PaymentMethod] [nvarchar](20) NULL
) ON [PRIMARY]

GO

