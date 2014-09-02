USE [DW_Work]
GO

/****** Object:  Table [temp].[FactLoyaltyPoints]    Script Date: 2/09/2014 12:11:11 PM ******/
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

