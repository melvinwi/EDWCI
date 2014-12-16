USE [DW_Work]
GO
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
	[AccountStatus] [nchar](10) NULL,
	[AccountCreationDate] [date] NULL,
	[AccountClosedDate] [date] NULL,
	[CreditControlStatus] [nvarchar](50) NULL,
	[CreditControlCategory] [nvarchar](50) NULL,
	[InvoiceDeliveryMethod] [nvarchar](30) NULL,
	[PaymentMethod] [nvarchar](20) NULL,
	[MyAccountStatus] [nvarchar](14) NULL,
	[ACN] [nvarchar](100) NULL,
	[ABN] [nvarchar](100) NULL,
	[AccountType] [nchar](11) NULL,
	[BillCycleCode] [nchar](10) NULL
) ON [data]

GO
