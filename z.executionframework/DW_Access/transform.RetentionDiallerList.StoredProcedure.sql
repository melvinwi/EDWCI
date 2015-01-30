USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [transform].[RetentionDiallerList]
    @TaskExecutionInstanceID INT
  , @LatestSuccessfulTaskExecutionInstanceID INT
AS
BEGIN

    ----Get LatestSuccessfulTaskExecutionInstanceID
    --IF  @LatestSuccessfulTaskExecutionInstanceID IS NULL
    --  BEGIN
    --    EXEC DW_Utility.config.GetLatestSuccessfulTaskExecutionInstanceID
    --        @TaskExecutionInstanceID = @TaskExecutionInstanceID
    --      , @LatestSuccessfulTaskExecutionInstanceID  = @LatestSuccessfulTaskExecutionInstanceID OUTPUT
    --  END
    ----/
    
    -- #notifications
    SELECT FactMarketTransaction.AccountId,
           DimAccount.AccountKey,
           FactMarketTransaction.ServiceId,
           DimService.ServiceKey,
           FactMarketTransaction.ChangeReasonId,
           FactMarketTransaction.TransactionDateId,
           FactMarketTransaction.TransactionTime,
           FactMarketTransaction.TransactionStatus,
           FactMarketTransaction.ParticipantCode,
           ROW_NUMBER() OVER (PARTITION BY DimAccount.AccountKey, DimService.ServiceKey ORDER BY FactMarketTransaction.TransactionDateId DESC, FactMarketTransaction.TransactionTime DESC) AS RC
    INTO   #notifications
    FROM   DW_Dimensional.DW.FactMarketTransaction
    INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactMarketTransaction.AccountId
    INNER  JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactMarketTransaction.ServiceId
    WHERE  FactMarketTransaction.TransactionType = N'NOTIFICATION'
    AND    CONVERT(DATETIME, CAST(FactMarketTransaction.TransactionDateId AS NCHAR(8)), 112) BETWEEN DATEADD(DAY, -90, GETDATE()) AND GETDATE();

    -- #requestNotifications
    SELECT #notifications.AccountKey,
           #notifications.ServiceKey,
           MIN(RC) AS RC
    INTO   #requestNotifications
    FROM   #notifications
    WHERE  #notifications.TransactionStatus = N'Requested'
    GROUP  BY #notifications.AccountKey,
              #notifications.ServiceKey;

    -- #latestNotification
    SELECT #notifications.AccountKey,
           #notifications.ChangeReasonId,
           #notifications.TransactionDateId,
           _previousNotification.TransactionDateId AS RequestDateId,
           #notifications.TransactionTime,
           #notifications.TransactionStatus,
           #notifications.ParticipantCode,
           #notifications.RC
    INTO   #latestNotification
    FROM   #notifications
    LEFT   JOIN #requestNotifications ON #requestNotifications.AccountKey = #notifications.AccountKey AND #requestNotifications.ServiceKey = #notifications.ServiceKey
    LEFT   JOIN #notifications AS _previousNotification ON _previousNotification.AccountKey = #notifications.AccountKey AND _previousNotification.ServiceKey = #notifications.ServiceKey AND _previousNotification.RC = #requestNotifications.RC
    WHERE  #notifications.RC = 1
    AND    #notifications.TransactionStatus IN (N'Requested', N'Pending');

    -- #phoneNumbers
    SELECT CustomerKey,
           CASE
             WHEN LEFT(PrimaryPhone, 2) IN (N'01', N'02', N'03', N'05', N'06', N'07', N'08', N'09') AND LEN(PrimaryPhone) = 10 THEN PrimaryPhone
           END AS HomePhone1,
           CASE
             WHEN LEFT(SecondaryPhone, 2) IN (N'01', N'02', N'03', N'05', N'06', N'07', N'08', N'09') AND LEN(SecondaryPhone) = 10 THEN SecondaryPhone
           END AS HomePhone2,
           CASE
             WHEN LEFT(PrimaryPhone, 2) = N'04' AND LEN(PrimaryPhone) = 10 THEN PrimaryPhone
           END AS MobilePhone1,
           CASE
             WHEN LEFT(SecondaryPhone, 2) = N'04' AND LEN(SecondaryPhone) = 10 THEN SecondaryPhone
           END AS MobilePhone2
    INTO   #phoneNumbers
    FROM   DW_Dimensional.DW.DimCustomer
    WHERE  Meta_IsCurrent = 1;

    -- #customerValue
    SELECT DimCustomer.CustomerKey,
           FactCustomerValue.ValueRating,
           ROW_NUMBER() OVER (PARTITION BY DimCustomer.CustomerKey ORDER BY FactCustomerValue.ValuationDateId DESC) AS RC
    INTO   #customerValue
    FROM   DW_Dimensional.DW.DimCustomer
    INNER  JOIN DW_Dimensional.DW.FactCustomerValue ON FactCustomerValue.CustomerId = DimCustomer.CustomerId;

    -- #retentionActivities
    SELECT DISTINCT DimCustomer.CustomerKey
    INTO   #retentionActivities
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
                                                2647, --Retention � Inbound Re-contract Added 13/09/2013 at Hari's request (BIU-3931)
                                                2648) --Retention � Outbound Re-contract Added 13/09/2013 at Hari's request (BIU-3931))
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
                                                2123) -- Retention � Inbound No Retain Added 04/06/2012 at Hari's request
            AND DATEDIFF(MONTH, CONVERT(NCHAR(8), FactActivity.ActivityDateId, 112), GETDATE()) <= 3)
    -- Checks for Outbound Retention - Callback within the last 5 days
    OR     (DimActivityType.ActivityTypeKey IN (1903, -- Outbound Retention - Callback
                                                2130) -- Retention - Outbound Call Back Added 09/05/2012 at Hari's request (BIU-386)
            AND DATEDIFF(DAY, CONVERT(NCHAR(8), FactActivity.ActivityDateId, 112), GETDATE()) <= 5);

    -- #agedTrialBalance
    SELECT FactAgedTrialBalance.AccountId,
           Days61To90,
           Days90Plus,
           ROW_NUMBER() OVER (PARTITION BY FactAgedTrialBalance.AccountId ORDER BY FactAgedTrialBalance.ATBDateId DESC) AS RC
    INTO   #agedTrialBalance
    FROM   DW_Dimensional.DW.FactAgedTrialBalance
    WHERE  DATEDIFF(DAY, CONVERT(NCHAR(8), FactAgedTrialBalance.ATBDateId, 112), GETDATE()) <= 7;

    -- #salesActivities
    SELECT DimAccount.AccountKey,
           FactSalesActivity.SalesActivityType,
           FactSalesActivity.SalesActivityDateId,
           ROW_NUMBER() OVER (PARTITION BY DimAccount.AccountCode ORDER BY FactSalesActivity.SalesActivityDateId DESC, FactSalesActivity.SalesActivityTime DESC) AS RC
    INTO   #salesActivities
    FROM   DW_Dimensional.DW.DimAccount
    INNER  JOIN DW_Dimensional.DW.FactSalesActivity ON FactSalesActivity.AccountId = DimAccount.AccountId
    WHERE  FactSalesActivity.SalesActivityType IN (N'Sale', N'Movement', N'Retained', N'Re-Contracted', N'Xsell', N'Existing Retain', N'New Retain', N'CR Retain', N'Sale_IB_Online', N'Sale_OB_Online', N'Recontracted_IB_Online', N'Recontracted_OB_Online', N'Move In Referral', N'Sale_Campaign', N'SD_NewRetain', N'SD_ExistingRetain', N'SD_Recontract', N'SD_CRRetain', N'SD_Sale', N'SD_Cancellation', N'SD_MoveinReferral', N'Channel Lead/Referral', N'sale_campaign_Shop1', N'sale_Campaign_Rewards', N'sale_campaign_Movies1', N'Retain ib movie (all inbound movies)', N'Retain ib movie (out cr campaign retains)', N'Retain_WB_movie (winback campaign sales and lost client winbacks)', N'Retain_WB_retain_movie (winback campaign retains)', N'Retain_recon_movie (recontract campaign)', N'Retain_recon_sale_movie (recontract campaign sales)', N'Retain_admin_movie (activities campaign retains)', N'Retain_sale_movie (ib sales)', N'Retain_xsell_movie (ob sales)', N'Retain_adminsale_movie (sales on admin campaign)', N'Sale_Campaign_Familyfriends', N'Sale_Campaign_Auspost', N'Virgin Lounge', N'sales_campaign_cudo1', N'sale_campaign_Movies2', N'sale_campaign_Pick1', N'BS $100 Cashback Campaign', N'BS Movers Campaign', N'BS Movie Lovers Campaign', N'BS_Ret_$100 credit', N'BS_Ret_Movie lovers', N'BS_Move_waive_con', N'BS_Move_Movie lovers', N'BS_Recon_Movie lovers', N'BS_Recon_$100 credit', N'sale_campaign_Movies4', N'sale_campaign_Movies5', N'Velocity TV1', N'Advantage TV1', N'BS_TV_Movie Lovers', N'Cancellation Save', N'sales_campaign_Movie1', N'BS_OBRet_$100 credit', N'BS_IBRet_$100 credit', N'BS_OBRet_Movie lovers', N'BS_IBRet_Movie lovers', N'BS_SA Movie Lovers', N'BS_Radio Movie Lovers', N'BS_DM Movie Lovers', N'sale_sponsor_netball1', N'BS_OBRecon_$100 credit', N'BS_IBRecon_$100 credit', N'BS_OBRecon_Movie Lovers', N'BS_IBRecon_Movie Lovers', N'BS_EDM_$100 Cashback', N'BS_Sale_Movie Lovers', N'sale_campaign_moving', N'sale_campaign_yellow2', N'BS Gas Xsell')
    AND    DATEDIFF(DAY, CONVERT(NCHAR(8), FactSalesActivity.SalesActivityDateId, 112), GETDATE()) <= 60;

    -- #contactActivities
    SELECT DimCustomer.CustomerKey,
           FactActivity.ActivityDateId
    INTO   #contactActivities
    FROM   DW_Dimensional.DW.DimCustomer
    INNER  JOIN DW_Dimensional.DW.FactActivity ON FactActivity.CustomerId = DimCustomer.CustomerId
    INNER  JOIN DW_Dimensional.DW.DimActivityType ON DimActivityType.ActivityTypeId = FactActivity.ActivityTypeId
    WHERE  DimActivityType.ActivityTypeKey IN (1764, -- Retention Dialler Contact
                                               1777) -- Retention Dialler Attempted Contact
    AND    CONVERT(DATETIME, CAST(FactActivity.ActivityDateId AS NCHAR(8)), 112) BETWEEN DATEADD(DAY, -90, GETDATE()) AND GETDATE();

    -- #CallList
    SELECT ISNULL(DimCustomerCurrent.PartyName, '') AS [Name],
           ISNULL(DimCustomerCurrent.ResidentialAddressLine1, '') AS [ADDRESS],
           ISNULL(DimCustomerCurrent.ResidentialSuburb, '') AS [SUBURB],
           ISNULL(DimCustomerCurrent.PostalPostcode, '') AS [POSTCODE],
           ISNULL(DimCustomerCurrent.ResidentialState, '') AS [ZONE],
           CASE
             WHEN #phoneNumbers.HomePhone1 IS NOT NULL THEN #phoneNumbers.HomePhone1
             WHEN #phoneNumbers.HomePhone2 IS NOT NULL THEN #phoneNumbers.HomePhone2
             ELSE ''
           END AS [Ph_Home_01],
           CASE
             WHEN #phoneNumbers.HomePhone2 IS NOT NULL AND #phoneNumbers.HomePhone1 IS NOT NULL THEN #phoneNumbers.HomePhone2
             ELSE ''
           END AS [Ph_Home_02],
           CASE
             WHEN #phoneNumbers.MobilePhone1 IS NOT NULL THEN #phoneNumbers.MobilePhone1
             WHEN #phoneNumbers.MobilePhone2 IS NOT NULL THEN #phoneNumbers.MobilePhone2
             ELSE ''
           END AS [Ph_Mobile_01],
           CASE
             WHEN #phoneNumbers.MobilePhone2 IS NOT NULL AND #phoneNumbers.MobilePhone1 IS NOT NULL THEN #phoneNumbers.MobilePhone2
             ELSE ''
           END AS [Ph_Mobile_02],
           '' AS [Ph_Work_01],
           '' AS [Ph_Work_02],
           '' AS [Ph_Other_01],
           '' AS [Ph_Other_02],
           ISNULL(DimCustomerCurrent.Title, '') AS [TITLE],
           ISNULL(DimCustomerCurrent.CustomerCode, '') AS [PARTYCODE],
           CONVERT(VARCHAR, DimCustomerCurrent.DateOfBirth, 101) AS [DOB],
           COALESCE(DATEDIFF(DAY, CONVERT(DATE, CAST(#salesActivities.SalesActivityDateId AS NCHAR(8)), 112), GETDATE()), 0) AS [RETAINEDON], --Number of days since last sales involvement (optional)
           CASE
             WHEN #phoneNumbers.MobilePhone1 IS NOT NULL OR #phoneNumbers.MobilePhone2 IS NOT NULL THEN N'Y'
             ELSE N'N'
           END AS [Mobile],
           COALESCE((SELECT COUNT(*)
                     FROM   #contactActivities
                     WHERE  #contactActivities.CustomerKey = DimCustomerCurrent.CustomerKey
                     AND    DATEDIFF(DAY, CONVERT(NCHAR(8), #contactActivities.ActivityDateId, 112), GETDATE()) <= 10), 0) AS [CONTACTS_10], -- Count of dispositions in last 10 days specific to retention
           COALESCE((SELECT COUNT(*)
                     FROM   #contactActivities
                     WHERE  #contactActivities.CustomerKey = DimCustomerCurrent.CustomerKey
                     AND    #contactActivities.ActivityDateId >= #latestNotification.RequestDateId), 0) AS [CONTACTS_CR], -- Count of dispositions since CR date
           DATEDIFF(DAY, CONVERT(DATE, CAST(#latestNotification.RequestDateId AS NCHAR(8)), 112), GETDATE()) AS [CRRAISED], -- Number of days since CR raised
           COALESCE(CONVERT(NCHAR(10), DATEDIFF(DAY, GETDATE(), NextScheduledReadDate)), '') AS [CRLOST], -- Number of days before CR is due to be completed (next scheduled read date)
           CASE #salesActivities.SalesActivityType
             WHEN N'Retained' THEN 6
             WHEN N'Existing Retain' THEN 18
             WHEN N'CR Retain' THEN 23
             ELSE ''
           END AS [CRRETAIN], -- Last sales involvement code if it was a retain (optional)
           ISNULL(#latestNotification.ParticipantCode, '') AS [COMPETITOR],
           '' AS [SKILLNAME],
           CASE #customerValue.ValueRating
             WHEN N'Silver' THEN 2
             WHEN N'Gold' THEN 3
             WHEN N'Platinum' THEN 4
             ELSE 1
           END AS [PROPENSITYSCORE],
           CASE
             WHEN DimChangeReasonCurrent.ChangeReasonCode IN (N'1000', N'1010') THEN DimChangeReasonCurrent.ChangeReasonCode ELSE ''
           END AS [UserField1],
           CASE WHEN DimChangeReasonCurrent.ChangeReasonCode IN (N'0001', N'0003') THEN DimChangeReasonCurrent.ChangeReasonCode ELSE '' END AS [UserField2],
           CONVERT(VARCHAR, GETDATE(), 101) AS [ImportDate],
           '' AS [Remarks],
           ISNULL(DimCustomerCurrent.Email, '') AS [UserField3],
           '' AS [LASTDISPOSITION],
           '' AS [LASTDISPDATE],
           '' AS [LASTDISPTIME],
           '' AS [ID5THCNCTDISP],
           '' AS [ID5THCNCTDISPDATE],
           '' AS [ID5THCNCTDISPTIME],
           '' AS [ID4THCNCTDISP],
           '' AS [ID3RDCNCTDISP],
           '' AS [ID2NDCNCTDISP],
           '' AS [ID1STCNCTDISP],
           '' AS [PREVIEW],
           '' AS [PREVIOUSCONTACT],
           '' AS [JOB],
           ISNULL(DimCustomerCurrent.PrivacyPreferredStatus, '') AS [Privacy],
           ROW_NUMBER() OVER (PARTITION BY DimCustomerCurrent.CustomerCode ORDER BY #latestNotification.TransactionDateId DESC, #latestNotification.TransactionTime DESC) AS RC
    INTO   #CallList
    FROM   #latestNotification
    INNER  JOIN DW_Dimensional.DW.DimChangeReason ON DimChangeReason.ChangeReasonId = #latestNotification.ChangeReasonId
    INNER  JOIN DW_Dimensional.DW.DimChangeReason AS DimChangeReasonCurrent ON DimChangeReasonCurrent.ChangeReasonKey = DimChangeReason.ChangeReasonKey AND DimChangeReasonCurrent.Meta_IsCurrent = 1t
    INNER  JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountKey = #latestNotification.AccountKey AND DimAccount.Meta_IsCurrent = 1
    INNER  JOIN DW_Dimensional.DW.FactCustomerAccount ON FactCustomerAccount.AccountId = DimAccount.AccountId
    INNER  JOIN DW_Dimensional.DW.DimCustomer ON DimCustomer.CustomerId = FactCustomerAccount.CustomerId
    INNER  JOIN DW_Dimensional.DW.DimCustomer AS DimCustomerCurrent ON DimCustomerCurrent.CustomerKey = DimCustomer.CustomerKey AND DimCustomerCurrent.Meta_IsCurrent = 1
    INNER  JOIN #phoneNumbers ON #phoneNumbers.CustomerKey = DimCustomerCurrent.CustomerKey
    INNER  JOIN #customerValue ON #customerValue.CustomerKey = DimCustomerCurrent.CustomerKey AND #customerValue.RC = 1
    LEFT   JOIN #retentionActivities ON #retentionActivities.CustomerKey = DimCustomerCurrent.CustomerKey
    LEFT   JOIN #agedTrialBalance ON #agedTrialBalance.AccountId = DimAccount.AccountId AND #agedTrialBalance.RC = 1
    LEFT   JOIN #salesActivities ON #salesActivities.AccountKey = DimAccount.AccountKey AND #salesActivities.RC = 1
    WHERE  DimChangeReasonCurrent.ChangeReasonCode IN (N'1000', N'1010', N'0001', N'0003')
    AND    DimCustomerCurrent.CustomerType = N'Residential'
    AND    NOT ISNULL(#latestNotification.ParticipantCode, N'VENCORP') IN (N'VEPL', N'VEGAS', N'SAEPL', N'QEPL', N'NSWEPL', N'LUMOUSR')
    AND    DimAccount.AccountStatus = N'Open'
    AND    (DimAccount.CreditControlStatus LIKE N'Standard%' OR DimAccount.CreditControlStatus LIKE N'Payplan%')
    AND    #retentionActivities.CustomerKey IS NULL
    AND    COALESCE(#agedTrialBalance.Days61To90 + #agedTrialBalance.Days90Plus, 0) < 500;
    
    INSERT INTO [views].[RetentionDiallerList]
        ( [Name]
        , [ADDRESS]
        , [SUBURB]
        , [POSTCODE]
        , [ZONE]
        , [Ph_Home_01]
        , [Ph_Home_02]
        , [Ph_Mobile_01]
        , [Ph_Mobile_02]
        , [Ph_Work_01]
        , [Ph_Work_02]
        , [Ph_Other_01]
        , [Ph_Other_02]
        , [TITLE]
        , [PARTYCODE]
        , [DOB]
        , [ACCTSEXCL]
        , [RETAINEDON]
        , [Mobile]
        , [CONTACTS_10]
        , [CONTACTS_CR]
        , [CRRAISED]
        , [CRLOST]
        , [CRRETAIN]
        , [COMPETITOR]
        , [SKILLNAME]
        , [PROPENSITYSCORE]
        , [UserField1]
        , [UserField2]
        , [ImportDate]
        , [Remarks]
        , [UserField3]
        , [LASTDISPOSITION]
        , [LASTDISPDATE]
        , [LASTDISPTIME]
        , [ID5THCNCTDISP]
        , [ID5THCNCTDISPDATE]
        , [ID5THCNCTDISPTIME]
        , [ID4THCNCTDISP]
        , [ID3RDCNCTDISP]
        , [ID2NDCNCTDISP]
        , [ID1STCNCTDISP]
        , [PREVIEW]
        , [PREVIOUSCONTACT]
        , [JOB]
        , [Privacy]
        , [Meta_Insert_TaskExecutionInstanceId]
        )
    SELECT [Name],
           [ADDRESS],
           [SUBURB],
           [POSTCODE],
           [ZONE],
           [Ph_Home_01],
           [Ph_Home_02],
           [Ph_Mobile_01],
           [Ph_Mobile_02],
           [Ph_Work_01],
           [Ph_Work_02],
           [Ph_Other_01],
           [Ph_Other_02],
           [TITLE],
           [PARTYCODE],
           [DOB],
           (SELECT CASE WHEN COUNT(*) > 0 THEN COUNT(*) - 1 ELSE 0 END FROM #CallList AS CL2 WHERE CL2.PartyCode = #CallList.PartyCode) AS [ACCTSEXCL],
           [RETAINEDON],
           [Mobile],
           [CONTACTS_10],
           [CONTACTS_CR],
           [CRRAISED],
           [CRLOST],
           [CRRETAIN],
           [COMPETITOR],
           [SKILLNAME],
           [PROPENSITYSCORE],
           [UserField1],
           [UserField2],
           [ImportDate],
           [Remarks],
           [UserField3],
           [LASTDISPOSITION],
           [LASTDISPDATE],
           [LASTDISPTIME],
           [ID5THCNCTDISP],
           [ID5THCNCTDISPDATE],
           [ID5THCNCTDISPTIME],
           [ID4THCNCTDISP],
           [ID3RDCNCTDISP],
           [ID2NDCNCTDISP],
           [ID1STCNCTDISP],
           [PREVIEW],
           [PREVIOUSCONTACT],
           [JOB],
           [Privacy],
           @TaskExecutionInstanceID
    FROM   #CallList
    WHERE  #CallList.RC = 1;
    
    --Return row counts
    SELECT  0 AS ExtractRowCount,
            @@ROWCOUNT AS InsertRowCount,
            0 AS UpdateRowCount,
            0 AS DeleteRowCount,
            0 AS ErrorRowCount;
    --/

END;

GO