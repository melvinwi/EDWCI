USE [DW_Access]
GO

/****** Object:  View [Views].[vCustomerHistorical]    Script Date: 2/09/2014 12:15:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [Views].[vCustomerHistorical]
AS SELECT  [CustomerCode]
      ,ISNULL(NULLIF([Title],''),'{U}') AS Title
      ,ISNULL(NULLIF([FirstName],''),'{Unknown}') AS FirstName
      ,ISNULL(NULLIF([MiddleInitial],''),'{Unknown}') AS MiddleInitial
      ,ISNULL(NULLIF([LastName],''),'{Unknown}') AS LastName
      ,ISNULL(NULLIF([PartyName],''),'{Unknown}') AS PartyName
      ,ISNULL(NULLIF([PostalAddressLine1],''),'{Unknown}') AS PostalAddressLine1
      ,ISNULL(NULLIF([PostalSuburb],''),'{Unknown}') AS PostalSuburb
      ,ISNULL(NULLIF([PostalPostcode],''),'{Un}') AS PostalPostcode
      ,ISNULL(NULLIF([PostalState],''),'{U}') AS PostalState
      ,ISNULL(NULLIF([PostalStateAsProvided],''),'{U}') AS PostalStateAsProvided
      ,ISNULL(NULLIF([ResidentialAddressLine1],''),'{Unknown}') AS ResidentialAddressLine1
      ,ISNULL(NULLIF([ResidentialSuburb],''),'{Unknown}') AS ResidentialSuburb
      ,ISNULL(NULLIF([ResidentialPostcode],''),'{Un}') AS ResidentialPostcode
      ,ISNULL(NULLIF([ResidentialState],''),'{U}') AS ResidentialState
      ,ISNULL(NULLIF([ResidentialStateAsProvided],''),'{U}') AS ResidentialStateAsProvided
      ,ISNULL(NULLIF([PrimaryPhone],''),'{Unknown}') AS PrimaryPhone
      ,ISNULL(NULLIF([PrimaryPhoneType],''),'{Unk}') AS PrimaryPhoneType
      ,ISNULL(NULLIF([SecondaryPhone],''),'{Unknown}') AS SecondaryPhone
      ,ISNULL(NULLIF([SecondaryPhoneType],''),'{Unk}') AS SecondaryPhoneType
      ,ISNULL(NULLIF([MobilePhone],''),'{Unknown}') AS MobilePhone
      ,ISNULL(NULLIF([Email],''),'{Unknown}') AS Email
      ,[DateOfBirth]
	 ,DATEDIFF(YEAR,[DateOfBirth],GETDATE()) AS Age
      ,ISNULL(NULLIF([CustomerType],''),'{Unknown}') AS CustomerType
      ,ISNULL(NULLIF([CustomerStatus],''),'{Unk}') AS CustomerStatus
      ,ISNULL(NULLIF([OmbudsmanComplaints],''),'{U}') AS OmbudsmanComplaints
      ,[CreationDate]
      ,[JoinDate]
      ,ISNULL(NULLIF([PrivacyPreferredStatus],''),'{Unknown}') AS PrivacyPreferredStatus,
	 Meta_IsCurrent,
	 Meta_EffectiveStartDate,
	 Meta_EffectiveEndDate
     FROM DW_Dimensional.DW.DimCustomer;





GO

