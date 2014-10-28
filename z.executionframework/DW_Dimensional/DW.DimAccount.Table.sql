USE [DW_Dimensional]
GO
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
	[AccountCreationDate] [date] NULL DEFAULT (NULL),
	[AccountStatus] [nchar](10) NULL DEFAULT (NULL),
	[AccountClosedDate] [date] NULL DEFAULT (NULL),
	[CreditControlStatus] [nvarchar](50) NULL DEFAULT (NULL),
	[InvoiceDeliveryMethod] [nvarchar](30) NULL DEFAULT (NULL),
	[PaymentMethod] [nvarchar](20) NULL DEFAULT (NULL),
	[Meta_IsCurrent] [bit] NOT NULL,
	[Meta_EffectiveStartDate] [datetime2](0) NOT NULL,
	[Meta_EffectiveEndDate] [datetime2](0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
	[CreditControlCategory] [nvarchar](50) NULL,
	[ACN] [nvarchar](100) NULL,
	[ABN] [nvarchar](100) NULL,
 CONSTRAINT [PK_DW.DimAccount] PRIMARY KEY CLUSTERED 
(
	[AccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
CREATE NONCLUSTERED INDEX [_dta_index_DimAccount_9_630293305__K1] ON [DW].[DimAccount]
(
	[AccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
CREATE NONCLUSTERED INDEX [_dta_index_DimAccount_9_630293305__K1_K2] ON [DW].[DimAccount]
(
	[AccountId] ASC,
	[AccountKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
CREATE NONCLUSTERED INDEX [_dta_index_DimAccount_9_630293305__K1_K3_K2] ON [DW].[DimAccount]
(
	[AccountId] ASC,
	[AccountCode] ASC,
	[AccountKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
CREATE NONCLUSTERED INDEX [_dta_index_DimAccount_9_630293305__K17] ON [DW].[DimAccount]
(
	[Meta_IsCurrent] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
CREATE NONCLUSTERED INDEX [_dta_index_DimAccount_9_630293305__K17_K1_K2] ON [DW].[DimAccount]
(
	[Meta_IsCurrent] ASC,
	[AccountId] ASC,
	[AccountKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
CREATE NONCLUSTERED INDEX [_dta_index_DimAccount_9_630293305__K17_K1_K3] ON [DW].[DimAccount]
(
	[Meta_IsCurrent] ASC,
	[AccountId] ASC,
	[AccountCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
CREATE NONCLUSTERED INDEX [_dta_index_DimAccount_9_630293305__K17_K3] ON [DW].[DimAccount]
(
	[Meta_IsCurrent] ASC,
	[AccountCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
CREATE NONCLUSTERED INDEX [_dta_index_DimAccount_9_630293305__K2] ON [DW].[DimAccount]
(
	[AccountKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [index]
GO
