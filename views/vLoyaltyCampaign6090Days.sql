CREATE VIEW [Views].[vLoyaltyCampaign6090Days]
AS WITH LoyaltyPoints
       AS (SELECT DimCustomer.CustomerCode,
                  SUM (FactLoyaltyPoints.PointsAmount) AS TotalPoints
          FROM    DW_Dimensional.DW.FactLoyaltyPoints
          INNER   JOIN DW_Dimensional.DW.DimCustomer ON FactLoyaltyPoints.CustomerId = DimCustomer.CustomerId
          GROUP BY DimCustomer.CustomerCode),
       Contracts
       AS (SELECT vContract.AccountCode,
                  vContract.ContractEndDate,
                  vContract.ServiceType,
                  vContract.MarketIdentifier,
                  vContract.ProductName,
                  ROW_NUMBER () OVER (PARTITION BY vContract.AccountCode ORDER BY vContract.ContractEndDate ASC, vContract.ServiceType ASC, vContract.MarketIdentifier ASC) AS RC
           FROM   DW_Access.Views.vContract
           WHERE  vContract.ContractEndDate > GETDATE ()
           AND    vContract.ContractStatus = 'Open'),
       promptPaymentDiscount
       AS (SELECT DimAccount.AccountKey,
                  -1 * SUM (FactTransaction.Value + FactTransaction.Tax) AS PromptPaymentDiscountReceived
           FROM   DW_Dimensional.DW.FactTransaction
           INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactTransaction.AccountId
           INNER  JOIN DW_Dimensional.DW.DimFinancialAccount ON DimFinancialAccount.FinancialAccountId = FactTransaction.FinancialAccountId AND DimFinancialAccount.FinancialAccountName = 'Prompt Payment Disc'
           GROUP  BY DimAccount.AccountKey),
       factHeader
       AS (SELECT DimAccount.AccountKey,
                  CASE
                    WHEN SUM (CASE FactHeader.PaidOnTime
                                WHEN 'Yes' THEN 1.0
                                ELSE 0.0
                              END) / COUNT (*) = 1.0 THEN '100%'
                    WHEN SUM (CASE FactHeader.PaidOnTime
                                WHEN 'Yes' THEN 1.0
                                ELSE 0.0
                              END) / COUNT (*) >= 0.8 THEN '80%-99%'
                    WHEN SUM (CASE FactHeader.PaidOnTime
                                WHEN 'Yes' THEN 1.0
                                ELSE 0.0
                              END) / COUNT (*) >= 0.6 THEN '60%-79%'
                    WHEN SUM (CASE FactHeader.PaidOnTime
                                WHEN 'Yes' THEN 1.0
                                ELSE 0.0
                              END) / COUNT (*) >= 0.4 THEN '40%-59%'
                    WHEN SUM (CASE FactHeader.PaidOnTime
                                WHEN 'Yes' THEN 1.0
                                ELSE 0.0
                              END) / COUNT (*) >= 0.2 THEN '20%-39%'
                    ELSE '00%-19%'
                  END AS PaidOnTime12Months
           FROM   DW_Dimensional.DW.FactHeader INNER JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactHeader.AccountId
           WHERE  CONVERT (date, CAST (FactHeader.DueDateId AS nchar (8)) , 112) < GETDATE ()
           AND    CONVERT (date, CAST (FactHeader.DueDateId AS nchar (8)) , 112) > DATEADD (year, -1, GETDATE ())
           GROUP  BY DimAccount.AccountKey),
       factContract
       AS (SELECT DimAccount.AccountKey,
                  SUM(CASE WHEN ContractStatus = 'Open' THEN 1 ELSE 0 END) AS NumberOfOpenContracts,
                  SUM (CASE
                         WHEN ContractStatus = 'Open' AND DimService.ServiceType = 'Gas' THEN 1
                         ELSE 0
                       END) AS NumberOfOpenGasContracts,
                  SUM (CASE
                         WHEN ContractStatus = 'Open' AND DimService.ServiceType = 'Electricity' THEN 1
                         ELSE 0
                       END) AS NumberOfOpenElectricityContracts
           FROM   DW_Dimensional.DW.FactContract
           INNER JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactContract.AccountId
           INNER JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactContract.ServiceId
           INNER JOIN DW_Dimensional.DW.DimProduct ON DimProduct.ProductId = FactContract.ProductId
           GROUP  BY DimAccount.AccountKey),
       factActivity
       AS (SELECT DimCustomer.CustomerKey,
                  FactActivity.ActivityNotes,
                  row_number() OVER (PARTITION BY DimCustomer.CustomerKey ORDER BY FactActivity.ActivityDateId DESC, FactActivity.ActivityTime DESC) AS recency
           FROM   DW_Dimensional.DW.FactActivity
           INNER  JOIN DW_Dimensional.DW.DimCustomer ON DimCustomer.CustomerId = FactActivity.CustomerId)
       SELECT --DimCustomer
              DimCustomer.CustomerCode,
              ISNULL (NULLIF (DimCustomer.Title, '') , '{U}') AS Title,
              ISNULL (NULLIF (DimCustomer.FirstName, '') , '{Unknown}') AS FirstName,
              ISNULL (NULLIF (DimCustomer.LastName, '') , '{Unknown}') AS LastName,
              ISNULL (NULLIF (DimCustomer.PartyName, '') , '{Unknown}') AS PartyName,
              ISNULL (NULLIF (DimCustomer.PostalAddressLine1, '') , '{Unknown}') AS PostalAddressLine1,
              ISNULL (NULLIF (DimCustomer.PostalSuburb, '') , '{Unknown}') AS PostalSuburb,
              ISNULL (NULLIF (DimCustomer.PostalPostcode, '') , '{Un}') AS PostalPostcode,
              ISNULL (NULLIF (DimCustomer.PostalState, '') , '{U}') AS PostalState,
              ISNULL (NULLIF (DimCustomer.ResidentialState, '') , '{U}') AS ResidentialState,
              ISNULL (NULLIF (DimCustomer.Email, '') , '{Unknown}') AS Email,
              ISNULL (NULLIF (DimCustomer.CustomerType, '') , '{Unknown}') AS CustomerType,
              ISNULL (NULLIF (DimCustomer.CustomerStatus, '') , '{Unk}') AS CustomerStatus,
              ISNULL (NULLIF (DimCustomer.OmbudsmanComplaints, '') , '{U}') AS OmbudsmanComplaints,
              ISNULL (NULLIF (DimCustomer.PrivacyPreferredStatus, '') , '{Unknown}') AS PrivacyPreferredStatus,
              ISNULL (NULLIF (DimAccount.CreditControlStatus, '') , '{Unknown}') AS CreditControlStatus,
              DimCustomer.CreationDate,
              --Contracts
              Contracts.ContractEndDate AS NextContractEndDate,
              Contracts.ProductName AS ProductNameForNextContract,
              Contracts.ServiceType AS ServiceTypeForNextContract,
              --LoyaltyPoints
              ISNULL (LoyaltyPoints.TotalPoints, 0) AS LoyaltyPoints,
              --promptPaymentDiscount
              ISNULL (promptPaymentDiscount.PromptPaymentDiscountReceived, 0) AS PromptPaymentDiscountReceived,
              --factHeader
              ISNULL (factHeader.PaidOnTime12Months, '00%-19%') AS PaidOnTime12Months,
              --factContract
              CASE
                WHEN factContract.NumberOfOpenGasContracts > 0 AND factContract.NumberOfOpenElectricityContracts > 0 THEN 'Dual Fuel'
                WHEN factContract.NumberOfOpenGasContracts > 0 THEN 'Gas'
                WHEN factContract.NumberOfOpenElectricityContracts > 0 THEN 'Electricity'
                ELSE 'None'
              END AS ActiveFuelType,
              factContract.NumberOfOpenContracts,
              --factActivity
              COALESCE(factActivity.ActivityNotes, '{Unknown}') AS LatestActivityNotes,
              --EmailCheck
              CASE
                WHEN ISNULL (NULLIF (DimCustomer.Email, '') , '{Unknown}') IN ('{Unknown}',
                                                                               'noemail@lumoenergy.com.au',
                                                                               'noemail@no.com',
                                                                               'no@email.lumo',
                                                                               '<blank>',
                                                                               'noemail@lumo.com',
                                                                               'noemail@email.com',
                                                                               'no@noemail.com',
                                                                               'no@email.com',
                                                                               'nil@hotmail.com',
                                                                               'noemail@no.com.au',
                                                                               'no@email.lumo.com',
                                                                               'noemail@lumoenergy.com ',
                                                                               'noemail@nomail.com',
                                                                               'nil@info.com',
                                                                               'na@noemail.com',
                                                                               'noe@na.com',
                                                                               'noemail@email.com.au',
                                                                               ' noemail@no.com') THEN 'No'
                ELSE 'Yes'
              END AS HasEmail
       FROM   DW_Dimensional.DW.FactCustomerAccount
       INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactCustomerAccount.AccountId AND DimAccount.Meta_IsCurrent = 1
       INNER  JOIN DW_Dimensional.DW.DimCustomer ON DimCustomer.CustomerId = FactCustomerAccount.CustomerId AND DimCustomer.Meta_IsCurrent = 1
       INNER  JOIN Contracts ON DimAccount.AccountCode = Contracts.AccountCode AND Contracts.RC = 1
       LEFT   JOIN LoyaltyPoints ON DimCustomer.CustomerCode = LoyaltyPoints.CustomerCode
       LEFT   JOIN promptPaymentDiscount ON promptPaymentDiscount.AccountKey = DimAccount.AccountKey
       LEFT   JOIN factHeader ON factHeader.AccountKey = DimAccount.AccountKey
       LEFT   JOIN factContract ON factContract.AccountKey = DimAccount.AccountKey
       LEFT   JOIN factActivity ON factActivity.CustomerKey = DimCustomer.CustomerKey AND factActivity.recency = 1
       WHERE  Contracts.ContractEndDate >= DATEADD (day, 60, GETDATE ())
       AND    Contracts.ContractEndDate <= DATEADD (day, 90, GETDATE ())
       AND    DimCustomer.PartyName NOT LIKE '%estate%';

GO

