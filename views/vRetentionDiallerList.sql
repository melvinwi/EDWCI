CREATE VIEW Views.vRetentionDiallerList
AS
WITH   notifications
       AS (SELECT FactMarketTransaction.AccountId,
                  FactMarketTransaction.ServiceId,
                  FactMarketTransaction.ChangeReasonId,
                  FactMarketTransaction.TransactionDateId,
                  FactMarketTransaction.TransactionStatus,
                  FactMarketTransaction.ParticipantCode,
                  ROW_NUMBER() OVER (PARTITION BY DimAccount.AccountKey, DimService.ServiceKey ORDER BY FactMarketTransaction.TransactionDateId DESC) AS RC
           FROM   DW_Dimensional.DW.FactMarketTransaction
           INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactMarketTransaction.AccountId
           INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactMarketTransaction.ServiceId
           WHERE  FactMarketTransaction.TransactionType = N'NOTIFICATION'),
       phoneNumbers
       AS (SELECT CustomerKey,
                  CASE
                    WHEN LEFT(PrimaryPhone,2) IN (N'01',N'02',N'03',N'05',N'06',N'07',N'08',N'09') AND LEN(PrimaryPhone) = 10 THEN PrimaryPhone
                  END AS HomePhone1,
                  CASE
                    WHEN LEFT(SecondaryPhone,2) IN (N'01',N'02',N'03',N'05',N'06',N'07',N'08',N'09') AND LEN(SecondaryPhone) = 10 THEN SecondaryPhone
                  END AS HomePhone2,
                  CASE
                    WHEN LEFT(PrimaryPhone,2) = N'04' AND LEN(PrimaryPhone) = 10 THEN PrimaryPhone
                  END AS MobilePhone1,
                  CASE
                    WHEN LEFT(SecondaryPhone,2) = N'04' AND LEN(SecondaryPhone) = 10 THEN SecondaryPhone
                  END AS MobilePhone2
           FROM   DW_Dimensional.DW.DimCustomer
           WHERE  Meta_IsCurrent = 1),
       retentionActivities
       AS (SELECT DISTINCT DimCustomer.CustomerCode
           FROM   DW_Dimensional.DW.DimCustomer
           INNER  JOIN DW_Dimensional.DW.FactActivity ON FactActivity.CustomerId = DimCustomer.CustomerId
           INNER  JOIN DW_Dimensional.DW.DimActivityType ON DimActivityType.ActivityTypeId = FactActivity.ActivityTypeId
           -- Checks for 'CR1000 Retained' and 'Outbound Retention - Retain' activity within the last 10 days 
           WHERE  (DimActivityType.ActivityTypeKey IN (1010, -- CR 1000 Retained
                                                       1057, -- Inbound: Retained
                                                       2122, -- Retention - Inbound Retain Added 18/05/2012 as Hari's request (BIU -415)
                                                       1286, -- CR 1010 Retained
                                                       1647, -- CR 1010/0003 - Retained
                                                       1648, -- CR 1000/0001 - Retained
                                                       1904, -- Outbound Retention - Retain
                                                       2127, -- Retention - Outbound Retain  Added 09/05/2012 at Hari's request (BIU-386)
                                                       1913, -- Request - Client Retain        Added 04/10/2011 at Martin's request
                                                       2647, --Retention – Inbound Re-contract Added 13/09/2013 at Hari's request (BIU-3931)
                                                       2648) --Retention – Outbound Re-contract Added 13/09/2013 at Hari's request (BIU-3931))
                   AND DATEDIFF(DAY, CONVERT(NCHAR(8), FactActivity.ActivityDateId, 112), GETDATE()) <= 10)
           -- Checks for other Retention activities within the last 3 months
           OR     (DimActivityType.ActivityTypeKey IN (1043, -- CR1000 Lost
                                                       1287, -- CR 1010 - Lost
                                                       1758, -- Churn: Poor Customer Service
                                                       1759, -- Churn: Under Contract
                                                       1760, -- Churn: Misleading Information
                                                       1761, -- Churn: Not Australian Owned
                                                       1762, -- Churn: Better Offer
                                                       1763, -- Churn: Contract Expired
                                                       1902, -- Outbound Retention - Lost
                                                       2128, -- Retention - Outbound No Retain Added 09/05/2012 at Hari's request (BIU-386)
                                                       2123) -- Retention – Inbound No Retain Added 04/06/2012 at Hari's request
                   AND DATEDIFF(MONTH, CONVERT(NCHAR(8), FactActivity.ActivityDateId, 112), GETDATE()) <= 3)
           -- Checks for Outbound Retention - Callback within the last 5 days
           OR     (DimActivityType.ActivityTypeKey IN (1903, -- Outbound Retention - Callback
                                                       2130) -- Retention - Outbound Call Back Added 09/05/2012 at Hari's request (BIU-386)
                   AND DATEDIFF(DAY, CONVERT(NCHAR(8), FactActivity.ActivityDateId, 112), GETDATE()) <= 5)),
       agedTrialBalance
       AS (SELECT FactAgedTrialBalance.AccountId,
                  Days61To90,
                  Days90Plus,
                  ROW_NUMBER () OVER (PARTITION BY FactAgedTrialBalance.AccountId ORDER BY FactAgedTrialBalance.ATBDateId DESC) AS RC
           FROM   DW_Dimensional.DW.FactAgedTrialBalance),
       service
       AS (SELECT DimAccount.AccountCode,
                  MIN(NextScheduledReadDate) AS NextScheduledReadDate
           FROM   DW_Dimensional.DW.DimAccount
           INNER  JOIN DW_Dimensional.DW.FactContract ON FactContract.AccountId = DimAccount.AccountId
           INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactContract.ServiceId
           WHERE  NextScheduledReadDate IS NOT NULL
           GROUP  BY DimAccount.AccountCode),
       CallList
       AS (SELECT ISNULL(DimCustomer.PartyName,'') AS [Name],
                  ISNULL(DimCustomer.ResidentialAddressLine1,'') AS [ADDRESS],
                  ISNULL(DimCustomer.ResidentialSuburb,'') AS [SUBURB],
                  ISNULL(DimCustomer.PostalPostcode,'') AS [POSTCODE],
                  ISNULL(DimCustomer.ResidentialState,'') AS [ZONE],
                  CASE
                    WHEN phoneNumbers.HomePhone1 IS NOT NULL THEN phoneNumbers.HomePhone1
                    WHEN phoneNumbers.HomePhone2 IS NOT NULL THEN phoneNumbers.HomePhone2
                    ELSE ''
                  END AS [Ph Home 01],
                  CASE
                    WHEN phoneNumbers.HomePhone2 IS NOT NULL AND phoneNumbers.HomePhone1 IS NOT NULL THEN phoneNumbers.HomePhone2
                    ELSE ''
                  END AS [Ph Home 02],
                  CASE
                    WHEN phoneNumbers.MobilePhone1 IS NOT NULL THEN phoneNumbers.MobilePhone1
                    WHEN phoneNumbers.MobilePhone2 IS NOT NULL THEN phoneNumbers.MobilePhone2
                    ELSE ''
                  END AS [Ph Mobile 01],
                  CASE
                    WHEN phoneNumbers.MobilePhone2 IS NOT NULL AND phoneNumbers.MobilePhone1 IS NOT NULL THEN phoneNumbers.MobilePhone2
                    ELSE ''
                  END AS [Ph Mobile 02],
                  '' AS [Ph Work 01],
                  '' AS [Ph Work 02],
                  '' AS [Ph Other 01],
                  '' AS [Ph Other 02],
                  ISNULL(DimCustomer.Title,'') AS [TITLE],
                  ISNULL(DimCustomer.CustomerCode,'') AS [PARTYCODE],
                  CONVERT(VARCHAR,DimCustomer.DateOfBirth,101) AS [DOB],
                  'TODO' AS [ACCTSEXCL],
                  'TODO' AS [RETAINEDON], --Number of days since last sales involvement (optional)
                  CASE
                    WHEN phoneNumbers.MobilePhone1 IS NOT NULL OR phoneNumbers.MobilePhone2 IS NOT NULL THEN 'Y'
                    ELSE 'N'
                  END AS [Mobile],
                  'TODO' AS [CONTACTS 10], --Count of dispositions in last 10 days specific to retention
                  'TODO' AS [CONTACTS CR], --Count of dispositions since CR date
                  DATEDIFF(DAY,CONVERT (date, CAST (notifications.TransactionDateId AS nchar (8)) , 112),GETDATE()) AS [CRRAISED], -- Number of days since CR raised
                  COALESCE(CONVERT(NCHAR(10), DATEDIFF(DAY, GETDATE(), NextScheduledReadDate)), '') AS [CRLOST], -- Number of days before CR is due to be completed (next scheduled read date)
                  'TODO' AS [CRRETAIN], -- Last sales involvement code if it was a retain (optional)
                  ISNULL(notifications.ParticipantCode,'') AS [COMPETITOR],
                  '' AS [SKILLNAME],
                  CASE vRetentionValue.Rating
                    WHEN 'Silver' THEN 2
                    WHEN 'Gold' THEN 3
                    WHEN 'Platinum' THEN 4
                    ELSE 1
                  END AS [PROPENSITYSCORE],
                  CASE
                    WHEN DimChangeReason.ChangeReasonCode IN (N'1000',N'1010') THEN DimChangeReason.ChangeReasonCode ELSE ''
                  END AS [User Field1],
                  CASE WHEN DimChangeReason.ChangeReasonCode IN (N'0001',N'0003') THEN DimChangeReason.ChangeReasonCode ELSE '' END AS [User Field2],
                  CONVERT(VARCHAR,GETDATE(),101) AS [Import Date],
                  '' AS [Remarks], ISNULL(DimCustomer.Email,'') AS [User Field3],
                  '' AS [LASTDISPOSITION],
                  '' AS [LASTDISPDATE],
                  '' AS [LASTDISPTIME],
                  '' AS [5THCNCTDISP],
                  '' AS [5THCNCTDISPDATE],
                  '' AS [5THCNCTDISPTIME],
                  '' AS [4THCNCTDISP],
                  '' AS [3RDCNCTDISP],
                  '' AS [2NDCNCTDISP],
                  '' AS [1STCNCTDISP],
                  '' AS [PREVIEW],
                  '' AS [PREVIOUSCONTACT],
                  '' AS [JOB],
                  ISNULL(DimCustomer.PrivacyPreferredStatus,'') AS [Privacy],
                  ROW_NUMBER () OVER (PARTITION BY DimCustomer.CustomerCode ORDER BY notifications.TransactionDateId) AS RC
       FROM   notifications
       INNER  JOIN DW_Dimensional.DW.DimChangeReason ON DimChangeReason.ChangeReasonId = notifications.ChangeReasonId AND DimChangeReason.Meta_IsCurrent = 1
       INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = notifications.AccountId AND DimAccount.Meta_IsCurrent = 1
       INNER  JOIN DW_Dimensional.DW.FactCustomerAccount ON FactCustomerAccount.AccountId = DimAccount.AccountId
       INNER  JOIN DW_Dimensional.DW.DimCustomer ON DimCustomer.CustomerId = FactCustomerAccount.CustomerId AND DimCustomer.Meta_IsCurrent = 1
       INNER  JOIN phoneNumbers ON phoneNumbers.CustomerKey = DimCustomer.CustomerKey
       INNER  JOIN DW_Access.Views.vRetentionValue ON vRetentionValue.CustomerCode = DimCustomer.CustomerCode
       LEFT   JOIN retentionActivities ON retentionActivities.CustomerCode = DimCustomer.CustomerCode
       LEFT   JOIN agedTrialBalance ON agedTrialBalance.AccountId = DimAccount.AccountId AND agedTrialBalance.RC = 1
       LEFT   JOIN service ON service.AccountCode = DimAccount.AccountCode
       WHERE  notifications.RC = 1
       AND    DimChangeReason.ChangeReasonCode IN (N'1000',N'1010',N'0001',N'0003')
       AND    notifications.TransactionStatus IN (N'Requested', N'Pending')
       AND    DimCustomer.CustomerType = N'Residential'
       AND    NOT ISNULL(notifications.ParticipantCode,'VENCORP') IN (N'VEPL',N'VEGAS',N'SAEPL',N'QEPL',N'NSWEPL',N'LUMOUSR')
       AND    DimAccount.AccountStatus = 'Open'
       AND    (DimAccount.CreditControlStatus LIKE 'Standard%' OR DimAccount.CreditControlStatus LIKE 'Payplan%')
       AND    retentionActivities.CustomerCode IS NULL
       AND    COALESCE(agedTrialBalance.Days61To90 + agedTrialBalance.Days90Plus, 0) < 500
       AND    CONVERT(DATETIME, CAST(notifications.TransactionDateId AS NCHAR(8)), 112) BETWEEN DATEADD(DAY, -90, GETDATE()) AND GETDATE())
SELECT [Name],
       [ADDRESS],
       [SUBURB],
       [POSTCODE],
       [ZONE],
       [Ph Home 01],
       [Ph Home 02],
       [Ph Mobile 01],
       [Ph Mobile 02],
       [Ph Work 01],
       [Ph Work 02],
       [Ph Other 01],
       [Ph Other 02],
       [TITLE],
       [PARTYCODE],
       [DOB],
       (SELECT COUNT(*) FROM CallList AS CL2 WHERE CL2.PartyCode = CallList.PartyCode) AS [ACCTSEXCL],
       [RETAINEDON],
       [Mobile],
       [CONTACTS 10],
       [CONTACTS CR],
       [CRRAISED],
       [CRLOST],
       [CRRETAIN],
       [COMPETITOR],
       [SKILLNAME],
       [PROPENSITYSCORE],
       [User Field1],
       [User Field2],
       [User Field3],
       [Import Date],
       [Remarks],
       [LASTDISPOSITION],
       [LASTDISPDATE],
       [LASTDISPTIME],
       [5THCNCTDISP],
       [5THCNCTDISPDATE],
       [5THCNCTDISPTIME],
       [4THCNCTDISP],
       [3RDCNCTDISP],
       [2NDCNCTDISP],
       [1STCNCTDISP],
       [PREVIEW],
       [PREVIOUSCONTACT],
       [JOB],
       [Privacy]
FROM   CallList
WHERE  CallList.RC = 1;