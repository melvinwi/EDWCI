USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[FactLoyaltyPoints](
	[CustomerId] [int] NULL,
	[AwardedDateId] [int] NULL,
	[ProgramName] [nvarchar](20) NULL,
	[PointsType] [nchar](6) NULL,
	[PointsAmount] [int] NULL,
	[MemberNumber] [nvarchar](20) NULL,
	[LoyaltyPointsKey] [int] NULL
) ON [PRIMARY]

GO
