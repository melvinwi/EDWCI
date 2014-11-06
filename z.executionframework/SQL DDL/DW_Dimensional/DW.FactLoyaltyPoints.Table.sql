USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[FactLoyaltyPoints](
	[CustomerId] [int] NOT NULL,
	[AwardedDateId] [int] NOT NULL,
	[ProgramName] [nvarchar](20) NULL,
	[PointsType] [nchar](6) NULL,
	[PointsAmount] [int] NULL,
	[MemberNumber] [nvarchar](20) NULL,
	[LoyaltyPointsKey] [int] NOT NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NOT NULL
) ON [data]

GO
CREATE CLUSTERED COLUMNSTORE INDEX [ClusteredColumnStoreIndex-FactLoyaltyPoints] ON [DW].[FactLoyaltyPoints] WITH (DROP_EXISTING = OFF) ON [data]
GO
