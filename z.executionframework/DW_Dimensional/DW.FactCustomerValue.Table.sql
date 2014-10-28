USE [DW_Dimensional]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DW].[FactCustomerValue](
	[CustomerId] [int] NOT NULL,
	[ValuationDateId] [int] NOT NULL,
	[ValueRating] [nvarchar](8) NOT NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NOT NULL
) ON [PRIMARY]

GO
