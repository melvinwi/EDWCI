USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [csv].[value_code](
	[price_plan_code] [nvarchar](20) NULL DEFAULT (NULL),
	[variation_from_market] [decimal](3, 2) NULL DEFAULT (NULL),
	[Meta_Insert_TaskExecutionInstanceId] [int] NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data]

GO
