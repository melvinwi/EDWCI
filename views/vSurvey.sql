CREATE VIEW [Views].[vSurvey]
AS
SELECT -- DimCustomer
       DimCustomerCurrent.CustomerCode,
       DimCustomerCurrent.Title,
       DimCustomerCurrent.FirstName,
       DimCustomerCurrent.MiddleInitial,
       DimCustomerCurrent.LastName,
       DimCustomerCurrent.PartyName,
       DimCustomerCurrent.ResidentialAddressLine1,
       DimCustomerCurrent.ResidentialSuburb,
       DimCustomerCurrent.ResidentialPostcode,
       DimCustomerCurrent.ResidentialState,
       DimCustomerCurrent.ResidentialStateAsProvided,
       DimCustomerCurrent.PrimaryPhone,
       DimCustomerCurrent.PrimaryPhoneType,
       DimCustomerCurrent.SecondaryPhone,
       DimCustomerCurrent.SecondaryPhoneType,
       DimCustomerCurrent.MobilePhone,
       DimCustomerCurrent.Email,
       DimCustomerCurrent.DateOfBirth,
       DATEDIFF(YEAR, DimCustomerCurrent.DateOfBirth, GETDATE())
       - CASE
           WHEN DATEDIFF(DAY, GETDATE(), DATEADD(YEAR, DATEDIFF (YEAR, DimCustomerCurrent.DateOfBirth, GETDATE()), DimCustomerCurrent.DateOfBirth)) > 0 THEN 1
           ELSE 0 -- Subtract birthdays that are yet to occur in the current year
         END AS Age,
       DimCustomerCurrent.CustomerType,
       DimCustomerCurrent.CustomerStatus,
       DimCustomerCurrent.OmbudsmanComplaints,
       DimCustomerCurrent.CreationDate,
       DimCustomerCurrent.JoinDate,
       DimCustomerCurrent.PrivacyPreferredStatus,
       DimCustomerCurrent.InferredGender,
       -- DimQuestion
       DimQuestionCurrent.Question,
       -- FactSurvey
       CONVERT(DATE, CAST(FactSurvey.ResponseDateId AS NCHAR(8)), 120) AS ResponseDate,
       FactSurvey.Response,
       FactSurvey.RespondentKey,
       FactSurvey.Segment,
       FactSurvey.ResearchProjectName
FROM   DW_Dimensional.DW.FactSurvey
LEFT   JOIN DW_Dimensional.DW.DimCustomer ON DimCustomer.CustomerId = FactSurvey.CustomerId
LEFT   JOIN DW_Dimensional.DW.DimCustomer AS DimCustomerCurrent ON DimCustomerCurrent.CustomerKey = DimCustomer.CustomerKey AND DimCustomerCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimQuestion ON DimQuestion.QuestionId = FactSurvey.QuestionId
LEFT   JOIN DW_Dimensional.DW.DimQuestion AS DimQuestionCurrent ON DimQuestionCurrent.QuestionKey = DimQuestion.QuestionKey AND DimQuestionCurrent.Meta_IsCurrent = 1;