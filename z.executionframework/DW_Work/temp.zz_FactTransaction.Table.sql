USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[zz_FactTransaction](
	[AccountId] [int] NULL,
	[ServiceId] [int] NULL,
	[ProductId] [int] NULL,
	[FinancialAccountId] [int] NULL,
	[TransactionDateId] [int] NULL,
	[VersionId] [int] NULL,
	[UnitTypeId] [int] NULL,
	[Units] [decimal](18, 4) NULL,
	[Value] [money] NULL,
	[Currency] [nchar](3) NULL,
	[Tax] [money] NULL,
	[TransactionDesc] [nvarchar](100) NULL,
	[TransactionKey] [nvarchar](20) NULL
) ON [PRIMARY]

GO
