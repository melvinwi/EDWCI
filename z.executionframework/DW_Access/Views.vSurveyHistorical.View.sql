USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Views].[vSurveyHistorical]
AS
SELECT -- DimCustomer
       DimCustomer.CustomerCode,
       DimCustomer.Title,
       DimCustomer.FirstName,
       DimCustomer.MiddleInitial,
       DimCustomer.LastName,
       DimCustomer.PartyName,
       DimCustomer.ResidentialAddressLine1,
       DimCustomer.ResidentialSuburb,
       DimCustomer.ResidentialPostcode,
       DimCustomer.ResidentialState,
       DimCustomer.ResidentialStateAsProvided,
       DimCustomer.PrimaryPhone,
       DimCustomer.PrimaryPhoneType,
       DimCustomer.SecondaryPhone,
       DimCustomer.SecondaryPhoneType,
       DimCustomer.MobilePhone,
       DimCustomer.Email,
       DimCustomer.DateOfBirth,
       DATEDIFF(YEAR, DimCustomer.DateOfBirth, GETDATE())
       - CASE
           WHEN DATEDIFF(DAY, GETDATE(), DATEADD(YEAR, DATEDIFF (YEAR, DimCustomer.DateOfBirth, GETDATE()), DimCustomer.DateOfBirth)) > 0 THEN 1
           ELSE 0 -- Subtract birthdays that are yet to occur in the current year
         END AS Age,
       DimCustomer.CustomerType,
       DimCustomer.CustomerStatus,
       DimCustomer.OmbudsmanComplaints,
       DimCustomer.CreationDate,
       DimCustomer.JoinDate,
       DimCustomer.PrivacyPreferredStatus,
       DimCustomer.InferredGender,
       -- DimQuestion
       DimQuestion.Question,
       -- FactSurvey
       CONVERT(DATE, CAST(FactSurvey.ResponseDateId AS NCHAR(8)), 120) AS ResponseDate,
       FactSurvey.Response
FROM   DW_Dimensional.DW.FactSurvey
LEFT   JOIN DW_Dimensional.DW.DimCustomer ON DimCustomer.CustomerId = FactSurvey.CustomerId
LEFT   JOIN DW_Dimensional.DW.DimQuestion ON DimQuestion.QuestionId = FactSurvey.QuestionId;
GO
