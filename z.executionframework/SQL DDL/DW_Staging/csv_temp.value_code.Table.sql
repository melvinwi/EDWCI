USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [csv_temp].[value_code](
	[price_plan_code] [nvarchar](20) NULL,
	[variation_from_market] [decimal](3, 2) NULL,
	[Meta_LatestUpdate_TaskExecutionInstanceId] [int] NULL
) ON [data]

GO
ALTER TABLE [csv_temp].[value_code] ADD  DEFAULT (NULL) FOR [price_plan_code]
GO
ALTER TABLE [csv_temp].[value_code] ADD  DEFAULT (NULL) FOR [variation_from_market]
GO
