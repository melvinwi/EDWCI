USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Views].[RetentionDiallerList](
	[Name] [nvarchar](100) NOT NULL,
	[ADDRESS] [nvarchar](100) NOT NULL,
	[SUBURB] [nvarchar](50) NOT NULL,
	[POSTCODE] [nchar](4) NOT NULL,
	[ZONE] [nchar](3) NOT NULL,
	[Ph_Home_01] [nvarchar](24) NULL,
	[Ph_Home_02] [nvarchar](24) NULL,
	[Ph_Mobile_01] [nvarchar](24) NULL,
	[Ph_Mobile_02] [nvarchar](24) NULL,
	[Ph_Work_01] [nvarchar](24) NOT NULL,
	[Ph_Work_02] [nvarchar](24) NOT NULL,
	[Ph_Other_01] [nvarchar](24) NOT NULL,
	[Ph_Other_02] [nvarchar](24) NOT NULL,
	[TITLE] [nchar](4) NOT NULL,
	[PARTYCODE] [nvarchar](10) NOT NULL,
	[DOB] [nvarchar](30) NULL,
	[ACCTSEXCL] [nvarchar](10) NULL,
	[RETAINEDON] [nvarchar](10) NULL,
	[Mobile] [nvarchar](1) NOT NULL,
	[CONTACTS_10] [nvarchar](10) NULL,
	[CONTACTS_CR] [nvarchar](10) NULL,
	[CRRAISED] [nvarchar](10) NULL,
	[CRLOST] [nvarchar](10) NULL,
	[CRRETAIN] [nvarchar](10) NULL,
	[COMPETITOR] [nvarchar](20) NOT NULL,
	[SKILLNAME] [nvarchar](1) NOT NULL,
	[PROPENSITYSCORE] [int] NOT NULL,
	[UserField1] [nvarchar](10) NULL,
	[UserField2] [nvarchar](10) NULL,
	[ImportDate] [nvarchar](30) NULL,
	[Remarks] [nvarchar](1) NOT NULL,
	[UserField3] [nvarchar](100) NOT NULL,
	[LASTDISPOSITION] [nvarchar](1) NOT NULL,
	[LASTDISPDATE] [nvarchar](1) NOT NULL,
	[LASTDISPTIME] [nvarchar](1) NOT NULL,
	[ID5THCNCTDISP] [nvarchar](1) NOT NULL,
	[ID5THCNCTDISPDATE] [nvarchar](1) NOT NULL,
	[ID5THCNCTDISPTIME] [nvarchar](1) NOT NULL,
	[ID4THCNCTDISP] [nvarchar](1) NOT NULL,
	[ID3RDCNCTDISP] [nvarchar](1) NOT NULL,
	[ID2NDCNCTDISP] [nvarchar](1) NOT NULL,
	[ID1STCNCTDISP] [nvarchar](1) NOT NULL,
	[PREVIEW] [nvarchar](1) NOT NULL,
	[PREVIOUSCONTACT] [nvarchar](1) NOT NULL,
	[JOB] [nvarchar](1) NOT NULL,
	[Privacy] [nvarchar](30) NOT NULL,
	[Meta_Insert_TaskExecutionInstanceId] [int] NOT NULL
) ON [data]

GO
