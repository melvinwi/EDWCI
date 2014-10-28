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
	[ABN] [nvarchar](100) NULL
) ON [data]

GO
ALTER TABLE [temp].[DimAccount] ADD  DEFAULT (NULL) FOR [AccountKey]
GO
ALTER TABLE [temp].[DimAccount] ADD  DEFAULT (NULL) FOR [AccountCode]
GO
ALTER TABLE [temp].[DimAccount] ADD  DEFAULT (NULL) FOR [PostalAddressLine1]
GO
ALTER TABLE [temp].[DimAccount] ADD  DEFAULT (NULL) FOR [PostalSuburb]
GO
ALTER TABLE [temp].[DimAccount] ADD  DEFAULT (NULL) FOR [PostalPostcode]
GO
ALTER TABLE [temp].[DimAccount] ADD  DEFAULT (NULL) FOR [PostalState]
GO
ALTER TABLE [temp].[DimAccount] ADD  DEFAULT (NULL) FOR [PostalStateAsProvided]
GO
ALTER TABLE [temp].[DimAccount] ADD  DEFAULT (NULL) FOR [AccountStatus]
GO
ALTER TABLE [temp].[DimAccount] ADD  DEFAULT (NULL) FOR [AccountCreationDate]
GO
ALTER TABLE [temp].[DimAccount] ADD  DEFAULT (NULL) FOR [AccountClosedDate]
GO
ALTER TABLE [temp].[DimAccount] ADD  DEFAULT (NULL) FOR [CreditControlStatus]
GO
ALTER TABLE [temp].[DimAccount] ADD  DEFAULT (NULL) FOR [CreditControlCategory]
GO
ALTER TABLE [temp].[DimAccount] ADD  DEFAULT (NULL) FOR [InvoiceDeliveryMethod]
GO
ALTER TABLE [temp].[DimAccount] ADD  DEFAULT (NULL) FOR [PaymentMethod]
GO
ALTER TABLE [temp].[DimAccount] ADD  DEFAULT (NULL) FOR [MyAccountStatus]
GO
