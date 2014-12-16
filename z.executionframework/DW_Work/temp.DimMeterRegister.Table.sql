USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimMeterRegister](
	[MeterRegisterKey] [int] NOT NULL,
	[MeterMarketSerialNumber] [nvarchar](50) NULL,
	[MeterSystemSerialNumber] [nvarchar](50) NULL,
	[MeterServiceType] [nvarchar](11) NULL,
	[RegisterBillingType] [nvarchar](100) NULL,
	[RegisterBillingTypeCode] [nchar](10) NULL,
	[RegisterClass] [nvarchar](40) NULL,
	[RegisterCreationDate] [date] NULL,
	[RegisterEstimatedDailyConsumption] [decimal](18, 6) NULL,
	[RegisterMarketIdentifier] [nchar](10) NULL,
	[RegisterSystemIdentifer] [nchar](10) NULL,
	[RegisterMultiplier] [decimal](18, 6) NULL,
	[RegisterNetworkTariffCode] [nvarchar](20) NULL,
	[RegisterReadDirection] [nchar](6) NULL,
	[RegisterStatus] [nchar](8) NULL,
	[RegisterVirtualStartDate] [date] NULL,
	[RegisterVirtualType] [nvarchar](20) NULL
) ON [data]

GO
