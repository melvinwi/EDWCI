USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[DimMeterRegister](
	[MeterRegisterId] [int] IDENTITY(1,1) NOT NULL,
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
	[RegisterVirtualType] [nvarchar](20) NULL,
	[Meta_IsCurrent] [bit] NOT NULL,
	[Meta_EffectiveStartDate] [datetime2](0) NOT NULL,
	[Meta_EffectiveEndDate] [datetime2](0) NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL,
 CONSTRAINT [PK_DW.DimMeterRegister] PRIMARY KEY CLUSTERED 
(
	[MeterRegisterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [data]
) ON [data]

GO
