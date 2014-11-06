USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[FactHeader](
	[AccountId] [int] NULL,
	[IssueDateId] [int] NULL,
	[DueDateId] [int] NULL,
	[HeaderType] [nchar](7) NULL,
	[PaidOnTime] [nchar](3) NULL,
	[HeaderKey] [nvarchar](20) NULL
) ON [PRIMARY]

GO
