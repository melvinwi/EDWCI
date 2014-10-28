USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[FactActivity](
	[CustomerId] [int] NULL,
	[RepresentativeId] [int] NULL,
	[OrganisationId] [int] NULL,
	[ActivityTypeId] [int] NULL,
	[ActivityDateId] [int] NULL,
	[ActivityTime] [time](7) NULL,
	[ActivityCommunicationMethod] [nvarchar](30) NULL,
	[ActivityCategory] [nvarchar](20) NULL,
	[ActivityNotes] [nvarchar](max) NULL,
	[ActivityKey] [int] NULL
) ON [data] TEXTIMAGE_ON [data]

GO
