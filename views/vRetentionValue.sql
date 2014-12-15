CREATE VIEW Views.vRetentionValue
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
             WHERE DimService.ServiceType = 'Gas'
       AND  FactContract.ContractStatus = 'Open'
             GROUP BY DimAccount.AccountKey) ,
elecUsage
       AS (SELECT DimAccount.AccountKey,
                  SUM (DimService.EstimatedDailyConsumption) * 365 AS YearlyElecUsageKWH
             FROM
                  DW_Dimensional.DW.FactContract INNER JOIN DW_Dimensional.DW.DimAccount
                  ON DimAccount.AccountId = FactContract.AccountId
                                                 INNER JOIN DW_Dimensional.DW.DimService
                  ON DimService.ServiceId = FactContract.ServiceId
             WHERE DimService.ServiceType = 'Electricity'
       AND  FactContract.ContractStatus = 'Open'
             GROUP BY DimAccount.AccountKey) ,
lossFactor
       AS (SELECT DimAccount.AccountKey,
                  SUM (DimService.LossFactor * DimService.EstimatedDailyConsumption) / NULLIF (SUM (DimService.EstimatedDailyConsumption) , 0) AS AverageLossFactor
             FROM
                  DW_Dimensional.DW.FactContract INNER JOIN DW_Dimensional.DW.DimAccount
                  ON DimAccount.AccountId = FactContract.AccountId
                                                 INNER JOIN DW_Dimensional.DW.DimService
                  ON DimService.ServiceId = FactContract.ServiceId
             WHERE DimService.ServiceType = 'Electricity'
       AND  FactContract.ContractStatus = 'Open'
             GROUP BY DimAccount.AccountKey) ,
paymentMethod
       AS (SELECT DimAccount.AccountKey,
                  FactTransaction.TransactionDesc AS PaymentMethod,
                  ROW_NUMBER () OVER (PARTITION BY DimAccount.AccountKey ORDER BY COUNT (*), FactTransaction.TransactionDesc DESC) AS RC
             FROM
                  DW_Dimensional.DW.FactTransaction INNER JOIN DW_Dimensional.DW.DimAccount
                  ON DimAccount.AccountId = FactTransaction.AccountId
                                                    INNER JOIN DW_Dimensional.DW.DimFinancialAccount
                  ON DimFinancialAccount.FinancialAccountId = FactTransaction.FinancialAccountId
                 AND DimFinancialAccount.FinancialAccountKey = 10
                 AND FactTransaction.TransactionDateId BETWEEN CONVERT (nchar (8) , DATEADD (year, -1, GETDATE ()) , 112) AND CONVERT (nchar (8) , GETDATE () , 112) 
             GROUP BY DimAccount.AccountKey,
                      FactTransaction.TransactionDesc) ,
pricePlanProfitability
       AS (SELECT DimAccount.AccountKey,
                  SUM (ISNULL (DimPricePlan.PricePlanValueRatio, 1.00) * CASE DimService.ServiceType WHEN 'Electricity' THEN DimService.EstimatedDailyConsumption * 8 ELSE DimService.EstimatedDailyConsumption END) / NULLIF (SUM (CASE DimService.ServiceType WHEN 'Electricity' THEN DimService.EstimatedDailyConsumption * 8 ELSE DimService.EstimatedDailyConsumption END) , 0) AS ValueRatio
             FROM
                  DW_Dimensional.DW.FactContract INNER JOIN DW_Dimensional.DW.DimAccount
                  ON DimAccount.AccountId = FactContract.AccountId
                                                 INNER JOIN DW_Dimensional.DW.DimService
                  ON DimService.ServiceId = FactContract.ServiceId
                                                 INNER JOIN DW_Dimensional.DW.DimPricePlan
                  ON DimPricePlan.PricePlanId = FactContract.PricePlanId
      WHERE FactContract.ContractStatus = 'Open'
             GROUP BY DimAccount.AccountKey) ,
paidOnTime
       AS (SELECT DimAccount.AccountKey,
                  SUM (CASE FactHeader.PaidOnTime
                       WHEN 'Yes' THEN 1.0
                           ELSE 0.0
                       END) / COUNT (*) AS PaidOnTime12Months
             FROM
                  DW_Dimensional.DW.FactHeader INNER JOIN DW_Dimensional.DW.DimAccount
                  ON DimAccount.AccountId = FactHeader.AccountId
             WHERE  CONVERT (date, CAST (FactHeader.DueDateId AS nchar (8)) , 112) BETWEEN DATEADD (year, -1, GETDATE ()) AND GETDATE () 
             GROUP  BY DimAccount.AccountKey) ,
accountContract
       AS ( SELECT DimAccount.AccountKey,
                   DATEADD (DAY, -1, CONVERT (date, CAST (FactContract.ContractStartDateId AS nchar (8)) , 112)) AS PossibleTenureStartDate,
                   CONVERT (date, CAST (FactContract.ContractStartDateId AS nchar (8)) , 112) AS ContractStartDate,
                   CONVERT (date, CAST (FactContract.ContractTerminatedDateId AS nchar (8)) , 112) AS ContractTerminatedDate
              FROM
                   DW_Dimensional.DW.DimAccount INNER JOIN DW_Dimensional.DW.FactContract
                   ON FactContract.AccountId = DimAccount.AccountId
       ),
tenure
       AS (SELECT DimAccount.AccountKey,
                  DATEDIFF(DAY, DimAccount.AccountCreationDate, ISNULL(DimAccount.AccountClosedDate, GETDATE())) AS AccountTenureInDays
             FROM
                  DW_Dimensional.DW.DimAccount
    WHERE
    DimAccount.Meta_IsCurrent = 1) ,
activities
     AS (SELECT DimCustomer.CustomerKey,
    SUM (CASE
           WHEN DimActivityType.ActivityCategory IN ('Complaint', 'Compliance Call Note') THEN 1
           ELSE 0
         END) AS Complaints12Months,
    SUM (CASE
           WHEN FactActivity.ActivityCommunicationMethod IN ('Email In', 'Fax In', 'Letter In', 'Phone In', 'Live Chat') THEN 1
           ELSE 0
         END) AS Enquiries12Months
  FROM DW_Dimensional.DW.FactActivity
  INNER JOIN DW_Dimensional.DW.DimCustomer
  ON DimCustomer.CustomerId = FactActivity.CustomerId
        INNER JOIN DW_Dimensional.DW.DimActivityType
        ON DimActivityType.ActivityTypeId = FactActivity.ActivityTypeId
  WHERE DATEDIFF(DAY,CONVERT (date, CAST (FactActivity.ActivityDateId AS nchar (8)) , 112),GETDATE()) BETWEEN 0 AND 365
  GROUP BY DimCustomer.CustomerKey),
theRating
       AS (SELECT DimCustomer.CustomerCode,
                  CASE
                  WHEN tenure.AccountTenureInDays > 1825 THEN 4.0
                  WHEN tenure.AccountTenureInDays > 1095 THEN 3.0
                  WHEN tenure.AccountTenureInDays > 365 THEN  2.0
                      ELSE                                    1.0
                  END AS Tenure,

                  CASE
                  WHEN elecUsage.YearlyElecUsageKWH > 12000 THEN 4.0
                  WHEN elecUsage.YearlyElecUsageKWH > 7500 THEN  3.0
                  WHEN elecUsage.YearlyElecUsageKWH > 4500 THEN  2.0
                  WHEN elecUsage.YearlyElecUsageKWH > 0001 THEN  1.0
                  WHEN gasUsage.YearlyGasUsageMJ > 90000 THEN    4.0
                  WHEN gasUsage.YearlyGasUsageMJ > 75000 THEN    3.0
                  WHEN gasUsage.YearlyGasUsageMJ > 55000 THEN    2.0
                      ELSE                                       1.0
                  END AS Usage,

                  CASE
                  WHEN ISNULL (ATB.Days1To30, 0) + ISNULL (ATB.Days31To60, 0) + ISNULL (ATB.Days61To90, 0) + ISNULL (ATB.Days90Plus, 0) <= 0 THEN 4.0
                  WHEN ISNULL (ATB.Days31To60, 0) + ISNULL (ATB.Days61To90, 0) + ISNULL (ATB.Days90Plus, 0) <= 0 THEN                             3.0
                  WHEN ISNULL (ATB.Days61To90, 0) + ISNULL (ATB.Days90Plus, 0) <= 0 THEN                                                          2.0
                      ELSE                                                                                                                        1.0
                  END AS Debt,

                  CASE paymentMethod.PaymentMethod
                  WHEN 'Payment - Credit Card' THEN            4.0
                  WHEN 'Payment - Direct Debit' THEN           4.0
                  WHEN 'Payment - Australia Post Billpay' THEN 3.0
                  WHEN 'Payment - Imported From Westpac' THEN  2.0
                      ELSE                                     1.0
                  END AS PaymentMethod,

                  CASE
                  WHEN factContract.NumberOfOpenContracts >= 5 THEN 4.0
                  WHEN factContract.NumberOfOpenContracts >= 3 THEN 3.0
                  WHEN factContract.NumberOfOpenContracts = 2 THEN  2.0
                  WHEN factContract.NumberOfOpenContracts = 1 THEN  1.0
                      ELSE 0.0
                  END AS ActiveProducts,

                  CASE
                  WHEN lossfactor.AverageLossFactor <= 1.052  THEN  4.0
                  WHEN lossfactor.AverageLossFactor <= 1.072  THEN 3.0
                  WHEN lossfactor.AverageLossFactor <= 1.092 THEN  2.0
                  WHEN lossfactor.AverageLossFactor <= 1.110   THEN 1.0
                      ELSE                                         1.0
                  END AS LossFactor,

                  CASE
                  WHEN pricePlanProfitability.ValueRatio >= 1.11 THEN   4.0
                  WHEN pricePlanProfitability.ValueRatio >= 1.03 THEN   3.0
                  WHEN pricePlanProfitability.ValueRatio >= 0.999 THEN  2.0
                      ELSE                                              1.0
                  END AS PricePlanProfitability,

                  CASE
         WHEN ISNULL(activities.Complaints12Months,0) < 1 AND ISNULL(activities.Enquiries12Months,0) < 2 THEN 4.0
         WHEN ISNULL(activities.Complaints12Months,0) < 1 AND ISNULL(activities.Enquiries12Months,0) < 5 THEN 3.0
         WHEN ISNULL(activities.Complaints12Months,0) < 1 AND ISNULL(activities.Enquiries12Months,0) < 7 THEN 2.0
             ELSE                                       1.0
         END AS Activities,

                  CASE
                  WHEN paidOnTime.PaidOnTime12Months >= 0.93 THEN 4.0
                  WHEN paidOnTime.PaidOnTime12Months >= 0.75 THEN 3.0
                  WHEN paidOnTime.PaidOnTime12Months >= 0.25 THEN 2.0
                      ELSE                                        1.0
                  END AS PaidOnTime,
                  ISNULL (NULLIF (DimCustomer.PartyName, '') , '{Unknown}') AS PartyName,
                  ISNULL (NULLIF (DimCustomer.ResidentialState, '') , '{U}') AS ResidentialState
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
                                                        LEFT JOIN tenure
                  ON tenure.AccountKey = DimAccount.AccountKey
                                                        LEFT JOIN activities
                  ON activities.CustomerKey = DimCustomer.CustomerKey
             WHERE  DimAccount.Meta_IsCurrent = 1
                AND DimCustomer.Meta_IsCurrent = 1
                AND COALESCE (paymentMethod.RC, 1) = 1) 
       SELECT
       DimCustomer.CustomerCode,
       CASE
    WHEN DimCustomer.OmbudsmanComplaints = 'Yes' THEN 'Bronze'
       WHEN ((theRating.Tenure * 0.10) + (theRating.Usage * 0.20) + (theRating.Debt * 0.20) + (theRating.PaymentMethod * 0.05) + (theRating.ActiveProducts * 0.05) + (theRating.LossFactor * 0.05) + (theRating.PricePlanProfitability * 0.25) + (theRating.Activities * 0.05) + (theRating.PaidOnTime * 0.05)) >= 2.95 THEN 'Platinum'
       WHEN ((theRating.Tenure * 0.10) + (theRating.Usage * 0.20) + (theRating.Debt * 0.20) + (theRating.PaymentMethod * 0.05) + (theRating.ActiveProducts * 0.05) + (theRating.LossFactor * 0.05) + (theRating.PricePlanProfitability * 0.25) + (theRating.Activities * 0.05) + (theRating.PaidOnTime * 0.05)) >= 2.55 THEN 'Gold'
       WHEN ((theRating.Tenure * 0.10) + (theRating.Usage * 0.20) + (theRating.Debt * 0.20) + (theRating.PaymentMethod * 0.05) + (theRating.ActiveProducts * 0.05) + (theRating.LossFactor * 0.05) + (theRating.PricePlanProfitability * 0.25) + (theRating.Activities * 0.05) + (theRating.PaidOnTime * 0.05)) >= 2.10 THEN 'Silver'
           ELSE 'Bronze'
       END AS Rating,
       theRating.PartyName,
       theRating.ResidentialState,
       CASE
       WHEN theRating.Tenure = 4.0 THEN 'Platinum'
       WHEN theRating.Tenure = 3.0  THEN 'Gold'
       WHEN theRating.Tenure = 2.0 THEN 'Silver'
           ELSE 'Bronze'
       END AS Tenure,
       CASE
       WHEN theRating.Usage = 4.0 THEN 'Platinum'
       WHEN theRating.Usage = 3.0 THEN 'Gold'
       WHEN theRating.Usage = 2.0 THEN 'Silver'
           ELSE 'Bronze'
       END AS Usage,
       CASE
       WHEN theRating.Debt = 4.0 THEN 'Platinum'
       WHEN theRating.Debt = 3.0 THEN 'Gold'
       WHEN theRating.Debt = 2.0 THEN 'Silver'
           ELSE 'Bronze'
       END AS Debt,
       CASE
       WHEN theRating.PaymentMethod = 4.0 THEN 'Platinum'
       WHEN theRating.PaymentMethod = 3.0 THEN 'Gold'
       WHEN theRating.PaymentMethod = 2.0 THEN 'Silver'
           ELSE 'Bronze'
       END AS PaymentMethod,
       CASE
       WHEN theRating.ActiveProducts = 4.0 THEN 'Platinum'
       WHEN theRating.ActiveProducts = 3.0 THEN 'Gold'
       WHEN theRating.ActiveProducts = 2.0 THEN 'Silver'
       WHEN theRating.ActiveProducts = 1.0 THEN 'Bronze'
           ELSE 'None'
       END AS ActiveProducts,
       CASE
       WHEN theRating.LossFactor = 4.0 THEN 'Platinum'
       WHEN theRating.LossFactor = 3.0 THEN 'Gold'
       WHEN theRating.LossFactor = 2.0 THEN 'Silver'
       WHEN theRating.LossFactor = 1.0 THEN 'Bronze'
           ELSE 'Platinum'
       END AS AverageLossFactor,
       CASE
       WHEN theRating.PricePlanProfitability = 4.0 THEN 'Platinum'
       WHEN theRating.PricePlanProfitability = 3.0 THEN 'Gold'
       WHEN theRating.PricePlanProfitability = 2.0 THEN 'Silver'
           ELSE 'Bronze'
       END AS PricePlanProfitability,
       CASE
       WHEN theRating.Activities = 4.0 THEN 'Platinum'
       WHEN theRating.Activities = 3.0 THEN 'Gold'
       WHEN theRating.Activities = 2.0 THEN 'Silver'
           ELSE 'Bronze'
       END AS Activities,
       CASE
       WHEN theRating.PaidOnTime = 4.0 THEN 'Platinum'
       WHEN theRating.PaidOnTime = 3.0 THEN 'Gold'
       WHEN theRating.PaidOnTime = 2.0 THEN 'Silver'
           ELSE 'Bronze'
       END AS PaidOnTime
         FROM
              DW_Dimensional.DW.DimCustomer INNER JOIN theRating
              ON theRating.CustomerCode = DimCustomer.CustomerCode
         WHERE DimCustomer.Meta_IsCurrent = 1;