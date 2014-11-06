USE [DW_Staging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [complaints].[CDC_states](
	[name] [nvarchar](256) NOT NULL,
	[state] [nvarchar](256) NOT NULL
) ON [PRIMARY]

GO
