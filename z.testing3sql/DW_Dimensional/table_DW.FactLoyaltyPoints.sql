USE [DW_Dimensional]
GO

/****** Object:  Table [DW].[FactLoyaltyPoints]    Script Date: 2/09/2014 12:13:51 PM ******/
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
) ON [PRIMARY]

GO

