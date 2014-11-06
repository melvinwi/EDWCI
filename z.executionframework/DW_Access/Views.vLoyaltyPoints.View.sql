USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [Views].[vLoyaltyPoints]
AS
  /*
  Schema            :   Views
  Object            :   vLoyaltyPoints
  Author            :   
  Created Date      :   
  Description       :   View of Loyalty Points

  Change  History   : 
  Author  Date          Description of Change
  JG      02.10.2014    Updated Age calculation
  <YOUR ROW HERE>     
  
  Usage:
    SELECT * FROM DW_Access.Views.vLoyaltyPoints

  */
SELECT		 --DimDate
                DimDate.Date AS AwardedDate,
                DimDate.DateId AS AwardedDateId,
			 --FactLoyaltyPoints
                ISNULL (NULLIF (FactLoyaltyPoints.ProgramName, '') , '{Unknown}') AS ProgramName,
                ISNULL (NULLIF (FactLoyaltyPoints.PointsType, '') , '{Unk}') AS PointsType,
                FactLoyaltyPoints.PointsAmount,
                ISNULL (NULLIF (FactLoyaltyPoints.MemberNumber, '') , '{Unknown}') AS MemberNumber,
			 --DimCustomer
                DimCustomer.CustomerCode                ,
                ISNULL (NULLIF (DimCustomer.Title, '') , '{U}') AS Title,
                ISNULL (NULLIF (DimCustomer.FirstName, '') , '{Unknown}') AS FirstName,
                ISNULL (NULLIF (DimCustomer.MiddleInitial, '') , '{Unknown}') AS MiddleInitial,
                ISNULL (NULLIF (DimCustomer.LastName, '') , '{Unknown}') AS LastName,
                ISNULL (NULLIF (DimCustomer.PartyName, '') , '{Unknown}') AS PartyName,
                ISNULL (NULLIF (DimCustomer.PostalAddressLine1, '') , '{Unknown}') AS PostalAddressLine1,
                ISNULL (NULLIF (DimCustomer.PostalSuburb, '') , '{Unknown}') AS PostalSuburb,
                ISNULL (NULLIF (DimCustomer.PostalPostcode, '') , '{Un}') AS PostalPostcode,
                ISNULL (NULLIF (DimCustomer.PostalState, '') , '{U}') AS PostalState,
                ISNULL (NULLIF (DimCustomer.PostalStateAsProvided, '') , '{U}') AS PostalStateAsProvided,
                ISNULL (NULLIF (DimCustomer.ResidentialAddressLine1, '') , '{Unknown}') AS ResidentialAddressLine1,
                ISNULL (NULLIF (DimCustomer.ResidentialSuburb, '') , '{Unknown}') AS ResidentialSuburb,
                ISNULL (NULLIF (DimCustomer.ResidentialPostcode, '') , '{Un}') AS ResidentialPostcode,
                ISNULL (NULLIF (DimCustomer.ResidentialState, '') , '{U}') AS ResidentialState,
                ISNULL (NULLIF (DimCustomer.ResidentialStateAsProvided, '') , '{U}') AS ResidentialStateAsProvided,
                ISNULL (NULLIF (DimCustomer.PrimaryPhone, '') , '{Unknown}') AS PrimaryPhone,
                ISNULL (NULLIF (DimCustomer.PrimaryPhoneType, '') , '{Unk}') AS PrimaryPhoneType,
                ISNULL (NULLIF (DimCustomer.SecondaryPhone, '') , '{Unknown}') AS SecondaryPhone,
                ISNULL (NULLIF (DimCustomer.SecondaryPhoneType, '') , '{Unk}') AS SecondaryPhoneType,
                ISNULL (NULLIF (DimCustomer.MobilePhone, '') , '{Unknown}') AS MobilePhone,
                ISNULL (NULLIF (DimCustomer.Email, '') , '{Unknown}') AS Email,
                DimCustomer.DateOfBirth
              , DATEDIFF(YEAR, DimCustomer.DateOfBirth, GETDATE())
                - CASE WHEN DATEDIFF(DAY, GETDATE(), DATEADD(YEAR, DATEDIFF (YEAR, DimCustomer.DateOfBirth, GETDATE()), DimCustomer.DateOfBirth)) > 0
                       THEN 1 ELSE 0 --this is to subtract birthdays that are yet to occur in the current year
                  END                                                  AS Age
              , ISNULL (NULLIF (DimCustomer.CustomerType, '') , '{Unknown}') AS CustomerType,
                ISNULL (NULLIF (DimCustomer.CustomerStatus, '') , '{Unk}') AS CustomerStatus,
                ISNULL (NULLIF (DimCustomer.OmbudsmanComplaints, '') , '{U}') AS OmbudsmanComplaints,
                DimCustomer.CreationDate,
                DimCustomer.JoinDate,
                ISNULL (NULLIF (DimCustomer.PrivacyPreferredStatus, '') , '{Unknown}') AS PrivacyPreferredStatus
    FROM        DW_Dimensional.DW.FactLoyaltyPoints 
    INNER JOIN  DW_Dimensional.DW.DimCustomer
                ON DimCustomer.CustomerId = FactLoyaltyPoints.CustomerId
    INNER JOIN  DW_Dimensional.DW.DimDate
                ON DimDate.DateId = FactLoyaltyPoints.AwardedDateId;

GO
