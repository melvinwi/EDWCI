USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [Views].[clintweighting_vRetentionValue]
AS WITH factContract
       AS (SELECT DimAccount.AccountKey,
                  SUM (CASE
                       WHEN ContractStatus = 'Open' THEN 1
                           ELSE 0
                       END) AS NumberOfOpenContracts
             FROM
                  DW_Dimensional.DW.FactContract INNER JOIN DW_Dimensional.DW.DimAccount
                  ON DimAccount.AccountId = FactContract.AccountId
             GROUP  BY DimAccount.AccountKey) ,
ATB
       AS (SELECT AccountId,
                  Days1To30,
                  Days31To60,
                  Days61To90,
                  Days90Plus
             FROM DW_Dimensional.DW.FactAgedTrialBalance AS FATB
             WHERE ATBDateId = (
                               SELECT MAX (ATBDateId) 
                                 FROM DW_Dimensional.DW.FactAgedTrialBalance
                                 WHERE AccountId = FATB.AccountId
                                 GROUP BY AccountId)) ,
gasUsage
       AS (SELECT DimAccount.AccountKey,
                  SUM (DimService.EstimatedDailyConsumption) * 365 AS YearlyGasUsageMJ
             FROM
                  DW_Dimensional.DW.FactContract INNER JOIN DW_Dimensional.DW.DimAccount
                  ON DimAccount.AccountId = FactContract.AccountId
                                                 INNER JOIN DW_Dimensional.DW.DimService
                  ON DimService.ServiceId = FactContract.ServiceId
             WHERE DimService.Meta_IsCurrent = 1
               AND DimAccount.Meta_IsCurrent = 1
               AND DimService.ServiceType = 'Gas'
             GROUP BY DimAccount.AccountKey) ,
elecUsage
       AS (SELECT DimAccount.AccountKey,
                  SUM (DimService.EstimatedDailyConsumption) * 365 AS YearlyElecUsageKWH
             FROM
                  DW_Dimensional.DW.FactContract INNER JOIN DW_Dimensional.DW.DimAccount
                  ON DimAccount.AccountId = FactContract.AccountId
                                                 INNER JOIN DW_Dimensional.DW.DimService
                  ON DimService.ServiceId = FactContract.ServiceId
             WHERE DimService.Meta_IsCurrent = 1
               AND DimAccount.Meta_IsCurrent = 1
               AND DimService.ServiceType = 'Electricity'
             GROUP BY DimAccount.AccountKey),
lossFactor
AS
(SELECT DimAccount.AccountKey,
SUM(DimService.LossFactor * DimService.EstimatedDailyConsumption) / NULLIF(SUM(DimService.EstimatedDailyConsumption),0) AS AverageLossFactor
 FROM
                  DW_Dimensional.DW.FactContract INNER JOIN DW_Dimensional.DW.DimAccount
                  ON DimAccount.AccountId = FactContract.AccountId
                                                 INNER JOIN DW_Dimensional.DW.DimService
                  ON DimService.ServiceId = FactContract.ServiceId
             WHERE DimService.Meta_IsCurrent = 1
               AND DimAccount.Meta_IsCurrent = 1
               AND DimService.ServiceType = 'Electricity'
             GROUP BY DimAccount.AccountKey),
paymentMethod AS (SELECT DimAccount.AccountKey, FactTransaction.TransactionDesc AS PaymentMethod,
ROW_NUMBER () OVER (PARTITION BY DimAccount.AccountKey ORDER BY COUNT(*) DESC) AS RC
  FROM [DW_Dimensional].[DW].[FactTransaction]
  INNER JOIN DW_Dimensional.DW.DimAccount
  ON DimAccount.AccountId = FactTransaction.AccountId
  WHERE FactTransaction.FinancialAccountId = 10
  AND FactTransaction.TransactionDateId > CONVERT (nchar (8) , DATEADD (year, -1, GETDATE ()) , 112) 
  AND FactTransaction.TransactionDateId < CONVERT (nchar (8) , GETDATE () , 112) 
  GROUP BY DimAccount.AccountKey, FactTransaction.TransactionDesc),

pricePlanProfitability
AS
(SELECT DimAccount.AccountKey,
SUM(ISNULL(DimPricePlan.PricePlanValueRatio,1.00) * DimService.EstimatedDailyConsumption) / NULLIF(SUM(DimService.EstimatedDailyConsumption),0) AS ValueRatio
 FROM
                  DW_Dimensional.DW.FactContract INNER JOIN DW_Dimensional.DW.DimAccount
                  ON DimAccount.AccountId = FactContract.AccountId
                                                 INNER JOIN DW_Dimensional.DW.DimService
                  ON DimService.ServiceId = FactContract.ServiceId
                                                 INNER JOIN DW_Dimensional.DW.DimPricePlan
                  ON DimPricePlan.PricePlanId = FactContract.PricePlanId
             WHERE DimService.Meta_IsCurrent = 1
               AND DimAccount.Meta_IsCurrent = 1
               AND DimPricePlan.Meta_IsCurrent = 1
             GROUP BY DimAccount.AccountKey),
paidOnTime
       AS (SELECT DimAccount.AccountKey,
                  SUM (CASE FactHeader.PaidOnTime
                                WHEN 'Yes' THEN 1.0
                                ELSE 0.0
                              END) / COUNT (*) AS PaidOnTime12Months
           FROM   DW_Dimensional.DW.FactHeader INNER JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactHeader.AccountId
           WHERE  CONVERT (date, CAST (FactHeader.DueDateId AS nchar (8)) , 112) < GETDATE ()
           AND    CONVERT (date, CAST (FactHeader.DueDateId AS nchar (8)) , 112) > DATEADD (year, -1, GETDATE ())
           GROUP  BY DimAccount.AccountKey),
theRating AS (SELECT DimCustomer.CustomerCode,
CASE
                   WHEN DATEDIFF (DAY, DimAccount.AccountCreationDate, ISNULL (DimAccount.AccountClosedDate, GETDATE ())) > 1460 THEN 4 * 0.10
                   WHEN DATEDIFF (DAY, DimAccount.AccountCreationDate, ISNULL (DimAccount.AccountClosedDate, GETDATE ())) > 1095 THEN 3 * 0.10
                   WHEN DATEDIFF (DAY, DimAccount.AccountCreationDate, ISNULL (DimAccount.AccountClosedDate, GETDATE ())) > 730 THEN  2 * 0.10
                   WHEN DATEDIFF (DAY, DimAccount.AccountCreationDate, ISNULL (DimAccount.AccountClosedDate, GETDATE ())) > 365 THEN  1 * 0.10
                       ELSE 0.0
                   END + --Usage
                   CASE
                   WHEN elecUsage.YearlyElecUsageKWH > 8000 THEN 4 * 0.20
                   WHEN elecUsage.YearlyElecUsageKWH > 6500 THEN 3 * 0.20
                   WHEN elecUsage.YearlyElecUsageKWH > 5500 THEN 2 * 0.20
                   WHEN elecUsage.YearlyElecUsageKWH > 4000 THEN 1 * 0.20
                   WHEN elecUsage.YearlyElecUsageKWH > 0001 THEN 0.0	  
                   WHEN gasUsage.YearlyGasUsageMJ > 90000 THEN   4 * 0.20
                   WHEN gasUsage.YearlyGasUsageMJ > 75000 THEN   3 * 0.20
                   WHEN gasUsage.YearlyGasUsageMJ > 55000 THEN   2 * 0.20
                   WHEN gasUsage.YearlyGasUsageMJ > 35000 THEN   1 * 0.20
                       ELSE 0.0
                   END + --Debt
                   CASE
                   WHEN ISNULL (ATB.Days1To30, 0) + ISNULL (ATB.Days31To60, 0) + ISNULL (ATB.Days61To90, 0) + ISNULL (ATB.Days90Plus, 0) <= 0 THEN 4 * 0.20
                   WHEN ISNULL (ATB.Days31To60, 0) + ISNULL (ATB.Days61To90, 0) + ISNULL (ATB.Days90Plus, 0) <= 0 THEN                             3 * 0.20
                   WHEN ISNULL (ATB.Days61To90, 0) + ISNULL (ATB.Days90Plus, 0) <= 0 THEN                                                          2 * 0.20
                       ELSE                                                                                                                        1 * 0.20
                   END + --Payment
                   CASE paymentMethod.PaymentMethod
                   WHEN 'Payment - Credit Card' THEN            4 * 0.05
                   WHEN 'Payment - Australia Post Billpay' THEN 4 * 0.05
                   WHEN 'Payment - Direct Debit' THEN           3 * 0.05
                   WHEN 'Payment - Imported From Westpac' THEN  2 * 0.05
                       ELSE                                     1 * 0.05
                   END + --Active Products
                   CASE
                   WHEN factContract.NumberOfOpenContracts >= 5 THEN 4 * 0.05
                   WHEN factContract.NumberOfOpenContracts >= 3 THEN 3 * 0.05
                   WHEN factContract.NumberOfOpenContracts = 2 THEN  2 * 0.05
                   WHEN factContract.NumberOfOpenContracts = 1 THEN  1 * 0.05
                       ELSE 0.0
                   END + --Loss Factor
			    CASE
                   WHEN lossfactor.AverageLossFactor >= 1.09 THEN  4 * 0.05
                   WHEN lossfactor.AverageLossFactor >= 1.06  THEN 3 * 0.05
                   WHEN lossfactor.AverageLossFactor >= 1.03 THEN  2 * 0.05
                   WHEN lossfactor.AverageLossFactor >= 0.99  THEN 1 * 0.05
                       ELSE                                        4 * 0.05
                   END + --Price Plan Profitability
                   CASE
                   WHEN pricePlanProfitability.ValueRatio >= 1.15 THEN  4 * 0.25
                   WHEN pricePlanProfitability.ValueRatio >= 1.08  THEN 3 * 0.25
                   WHEN pricePlanProfitability.ValueRatio >= 1.01 THEN  2 * 0.25
                       ELSE                                             1 * 0.25
                   END + --Activities
			    4 * 0.05 + 	  --Paid On Time
                  CASE
                  WHEN paidOnTime.PaidOnTime12Months >= 0.75 THEN 4 * 0.05
                  WHEN paidOnTime.PaidOnTime12Months >= 0.50 THEN 3 * 0.05
                  WHEN paidOnTime.PaidOnTime12Months >= 0.25 THEN 2 * 0.05
                      ELSE                                        1 * 0.05
                  END AS Rating,
			   ISNULL (NULLIF (DimCustomer.PartyName, '') , '{Unknown}') AS PartyName
       ,
       ISNULL (NULLIF (DimCustomer.ResidentialState, '') , '{U}') AS ResidentialState

   
       ,
       

       --Tenure
 
       CASE
       WHEN DATEDIFF (DAY, DimAccount.AccountCreationDate, ISNULL (DimAccount.AccountClosedDate, GETDATE ())) > 1460 THEN 'Platinum'
       WHEN DATEDIFF (DAY, DimAccount.AccountCreationDate, ISNULL (DimAccount.AccountClosedDate, GETDATE ())) > 1095 THEN 'Gold'
       WHEN DATEDIFF (DAY, DimAccount.AccountCreationDate, ISNULL (DimAccount.AccountClosedDate, GETDATE ())) > 730 THEN 'Silver'
       WHEN DATEDIFF (DAY, DimAccount.AccountCreationDate, ISNULL (DimAccount.AccountClosedDate, GETDATE ())) > 365 THEN 'Bronze'
           ELSE 'None'
       END AS Tenure

       --Usage
       ,
       CASE
       WHEN elecUsage.YearlyElecUsageKWH > 8000 THEN 'Platinum'
       WHEN elecUsage.YearlyElecUsageKWH > 6500 THEN 'Gold'
       WHEN elecUsage.YearlyElecUsageKWH > 5500 THEN 'Silver'
       WHEN elecUsage.YearlyElecUsageKWH > 4000 THEN 'Bronze'
       WHEN elecUsage.YearlyElecUsageKWH > 0001 THEN 'None'
       WHEN gasUsage.YearlyGasUsageMJ > 90000 THEN 'Platinum'
       WHEN gasUsage.YearlyGasUsageMJ > 75000 THEN 'Gold'
       WHEN gasUsage.YearlyGasUsageMJ > 55000 THEN 'Silver'
       WHEN gasUsage.YearlyGasUsageMJ > 35000 THEN 'Bronze'
           ELSE 'None'
       END AS Usage

       --Debt
       ,
       CASE
       WHEN ISNULL (ATB.Days1To30, 0) + ISNULL (ATB.Days31To60, 0) + ISNULL (ATB.Days61To90, 0) + ISNULL (ATB.Days90Plus, 0) <= 0 THEN 'Platinum'
       WHEN ISNULL (ATB.Days31To60, 0) + ISNULL (ATB.Days61To90, 0) + ISNULL (ATB.Days90Plus, 0) <= 0 THEN 'Gold'
       WHEN ISNULL (ATB.Days61To90, 0) + ISNULL (ATB.Days90Plus, 0) <= 0 THEN 'Silver'
           ELSE 'Bronze'
       END AS Debt

       --Payment
       ,
       CASE paymentMethod.PaymentMethod
       WHEN 'Payment - Credit Card' THEN 'Platinum'
	  WHEN 'Payment - Australia Post Billpay' THEN 'Platinum'
       WHEN 'Payment - Direct Debit' THEN 'Gold'
       WHEN 'Payment - Imported From Westpac' THEN 'Silver'
           ELSE 'Bronze'
       END AS PaymentMethod

       --Active Products
       ,
       CASE
       WHEN factContract.NumberOfOpenContracts >= 5 THEN 'Platinum'
       WHEN factContract.NumberOfOpenContracts >= 3 THEN 'Gold'
       WHEN factContract.NumberOfOpenContracts = 2 THEN 'Silver'
       WHEN factContract.NumberOfOpenContracts = 1 THEN 'Bronze'
           ELSE 'None'
       END AS ActiveProducts

	  --Loss Factor
       ,
       CASE
       WHEN lossfactor.AverageLossFactor >= 1.09 THEN 'Platinum'
       WHEN lossfactor.AverageLossFactor >= 1.06  THEN 'Gold'
       WHEN lossfactor.AverageLossFactor >= 1.03 THEN 'Silver'
       WHEN lossfactor.AverageLossFactor >= 0.99  THEN 'Bronze'
           ELSE 'Platinum'
       END AS AverageLossFactor

	  --Price Plan Profitability
       ,
       CASE
       WHEN pricePlanProfitability.ValueRatio >= 1.15 THEN 'Platinum'
       WHEN pricePlanProfitability.ValueRatio >= 1.08  THEN 'Gold'
       WHEN pricePlanProfitability.ValueRatio >= 1.01 THEN 'Silver'
           ELSE 'Bronze'
       END AS PricePlanProfitability

	  --Activities
       ,
       'Platinum' AS Activities

	  --Paid On Time
       ,
       CASE
       WHEN paidOnTime.PaidOnTime12Months >= 0.75 THEN 'Platinum'
       WHEN paidOnTime.PaidOnTime12Months >= 0.50 THEN 'Gold'
       WHEN paidOnTime.PaidOnTime12Months >= 0.25 THEN 'Silver'
           ELSE 'Bronze'
       END AS PaidOnTime
			    FROM
              DW_Dimensional.DW.FactCustomerAccount INNER JOIN DW_Dimensional.DW.DimAccount
              ON DimAccount.AccountId = FactCustomerAccount.AccountId
                                                    INNER JOIN DW_Dimensional.DW.DimCustomer
              ON DimCustomer.CustomerId = FactCustomerAccount.CustomerId
                                                    LEFT JOIN factContract
              ON factContract.AccountKey = DimAccount.AccountKey
                                                    LEFT JOIN ATB
              ON ATB.AccountId = DimAccount.AccountId
                                                    LEFT JOIN gasUsage
              ON gasUsage.AccountKey = DimAccount.AccountKey
                                                    LEFT JOIN elecUsage
              ON elecUsage.AccountKey = DimAccount.AccountKey
                                                    LEFT JOIN lossFactor
              ON lossFactor.AccountKey = DimAccount.AccountKey
                                                    LEFT JOIN paymentMethod
              ON paymentMethod.AccountKey = DimAccount.AccountKey
		                                          LEFT JOIN pricePlanProfitability
              ON pricePlanProfitability.AccountKey = DimAccount.AccountKey
		                                          LEFT JOIN paidOnTime
              ON paidOnTime.AccountKey = DimAccount.AccountKey

         WHERE  DimAccount.Meta_IsCurrent = 1
            AND DimCustomer.Meta_IsCurrent = 1


			   )
 
       SELECT
       DimCustomer.CustomerCode
	 ,CASE 
	 WHEN theRating.Rating >= 2.95 THEN 'Platinum'
	 WHEN theRating.Rating >= 2.50 THEN 'Gold'
	 WHEN theRating.Rating >= 1.90 THEN 'Silver'
	 ELSE 'Bronze' END AS Rating
      ,theRating.[PartyName]
      ,theRating.[ResidentialState]
      ,theRating.[Tenure]
      ,theRating.[Usage]
      ,theRating.[Debt]
      ,theRating.[PaymentMethod]
      ,theRating.[ActiveProducts]
      ,theRating.[AverageLossFactor]
      ,theRating.[PricePlanProfitability]
      ,theRating.[Activities]
      ,theRating.[PaidOnTime]

         FROM
              DW_Dimensional.DW.DimCustomer
       
		    INNER JOIN theRating
		    ON theRating.CustomerCode = DimCustomer.CustomerCode

         WHERE DimCustomer.Meta_IsCurrent = 1;













GO
