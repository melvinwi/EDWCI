USE [dba_admin]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[VolumeSpaceLoad](
	[volume_name] [varchar](90) NOT NULL,
	[capacity_bytes] [varchar](90) NOT NULL,
	[freespace_bytes] [varchar](90) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
