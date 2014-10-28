USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[VolumeSpace](
	[volume_name] [varchar](90) NOT NULL,
	[capacity_bytes] [bigint] NOT NULL,
	[freespace_bytes] [bigint] NOT NULL,
	[collection_time] [datetime] NOT NULL CONSTRAINT [DF_VolumeSpace_collection_time]  DEFAULT (getdate())
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
