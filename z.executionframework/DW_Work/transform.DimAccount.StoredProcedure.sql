USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [transform].[DimAccount]
@TaskExecutionInstanceID int
,
@LatestSuccessfulTaskExecutionInstanceID int
AS
BEGIN

    --Get LatestSuccessfulTaskExecutionInstanceID
    IF  @LatestSuccessfulTaskExecutionInstanceID IS NULL
        BEGIN
            EXEC DW_Utility.config.GetLatestSuccessfulTaskExecutionInstanceID
            @TaskExecutionInstanceID = @TaskExecutionInstanceID
            , @LatestSuccessfulTaskExecutionInstanceID = @LatestSuccessfulTaskExecutionInstanceID OUTPUT;
        END;
    --/
    WITH accountStatus
        AS (SELECT nc_client.seq_party_id,
                   MIN (nc_product_item.accnt_status_date) AS MinAccountStatusDate,
                   MAX (nc_product_item.accnt_status_date) AS MaxAccountStatusDate,
                   MAX (CASE
                        WHEN utl_account_status.accnt_status_class_id = '2' THEN 1
                            ELSE 0
                        END) AS StatusOpen,
                   MAX (CASE
                        WHEN utl_account_status.accnt_status_class_id = '3' THEN 1
                            ELSE 0
                        END) AS StatusPending,
                   MAX (CASE
                        WHEN utl_account_status.accnt_status_class_id = '4' THEN 1
                            ELSE 0
                        END) AS StatusError,
                   MAX (CASE
                        WHEN nc_client.Meta_LatestUpdate_TaskExecutionInstanceId >= @LatestSuccessfulTaskExecutionInstanceID
                          OR nc_product.Meta_LatestUpdate_TaskExecutionInstanceId >= @LatestSuccessfulTaskExecutionInstanceID
                          OR nc_product_item.Meta_LatestUpdate_TaskExecutionInstanceId >= @LatestSuccessfulTaskExecutionInstanceID THEN 1
                            ELSE 0
                        END) AS Meta_HasChanged
              FROM
                   DW_Staging.orion.nc_client LEFT OUTER JOIN DW_Staging.orion.nc_product
                   ON nc_product.seq_party_id = nc_client.seq_party_id
                                  LEFT OUTER JOIN DW_Staging.orion.nc_product_item
                   ON nc_product_item.seq_product_id = nc_product.seq_product_id
                                  LEFT OUTER JOIN DW_Staging.orion.utl_account_status
                   ON utl_account_status.accnt_status_id = nc_product_item.accnt_status_id
              GROUP BY nc_client.seq_party_id) 
        INSERT INTO temp.DimAccount (
        DimAccount.AccountKey,
        DimAccount.AccountCode,
        DimAccount.PostalAddressLine1,
        DimAccount.PostalSuburb,
        DimAccount.PostalPostcode,
        DimAccount.PostalState,
        DimAccount.PostalStateAsProvided,
        DimAccount.AccountStatus,
        DimAccount.AccountCreationDate,
        DimAccount.AccountClosedDate,
        DimAccount.CreditControlStatus,
        DimAccount.CreditControlCategory,
        DimAccount.InvoiceDeliveryMethod,
        DimAccount.PaymentMethod,
        DimAccount.MyAccountStatus,
        DimAccount.ACN,
        DimAccount.ABN) 
        SELECT
        CAST ( nc_client.seq_party_id AS int) ,
        CASE
        WHEN ISNUMERIC (crm_party.party_code) = 1 THEN CAST ( crm_party.party_code AS int) 
        END,
        CAST ( crm_party.postal_addr_1 AS nvarchar (100)) ,
        CAST ( crm_party.postal_addr_2 AS nvarchar (50)) ,
        CAST ( crm_party.postal_post_code AS nchar (4)) ,
        CASE
        WHEN LEFT (UPPER ( crm_party.postal_addr_3) , 3) IN ('ACT', 'NSW', 'NT', 'QLD', 'SA', 'TAS', 'VIC', 'WA') THEN LEFT (UPPER (crm_party.postal_addr_3) , 3) 
            ELSE NULL
        END,
        CAST ( crm_party.postal_addr_3 AS nchar (3)) ,
        CAST (CASE
              WHEN _accountStatus.StatusOpen = 1 THEN 'Open'
              WHEN _accountStatus.StatusPending = 1 THEN 'Pending'
              WHEN _accountStatus.StatusError = 1 THEN 'Error'
                  ELSE 'Closed'
              END AS nchar (10)) ,
        nc_client.insert_datetime,
        CAST (CASE
              WHEN _accountStatus.StatusOpen = 1
                OR _accountStatus.StatusPending = 1
                OR _accountStatus.StatusError = 1 THEN NULL
                  ELSE _accountStatus.MaxAccountStatusDate
              END AS date) ,
        CAST ( nc_credit_control_status.seq_credit_status_desc AS nvarchar (50)) ,
        _creditControlCategory.CreditControlCategory,
        CAST ( nc_inv_deliver_mode.inv_del_mode_desc AS nvarchar (50)) ,
        CAST (CASE nc_client.seq_pay_method_id
              WHEN 14 THEN 'Cheque'
              WHEN 17 THEN 'Direct Credit'
              WHEN 18 THEN 'Direct Debit'
              WHEN 22 THEN 'Credit Card'
                  ELSE NULL
              END AS nvarchar (20)) ,
        CAST (CASE nc_client.cz_registered
              WHEN 'Y' THEN 'Registered'
                  ELSE 'Not Registered'
              END AS nvarchar (14)) ,
        CAST (NULLIF ( nc_client.user_defined_1 , '') AS nvarchar (100)) ,
        CAST (NULLIF ( nc_client.user_defined_2 , '') AS nvarchar (100)) 
          FROM
               DW_Staging.orion.nc_client INNER JOIN DW_Staging.orion.crm_party
               ON nc_client.seq_party_id = crm_party.seq_party_id
                              INNER JOIN accountStatus AS _accountStatus
               ON _accountStatus.seq_party_id = nc_client.seq_party_id
                              LEFT JOIN DW_Staging.orion.nc_credit_control_status
               ON nc_credit_control_status.seq_credit_status_id = nc_client.seq_credit_status_id
                              LEFT JOIN DW_Work.lookup.CreditControlCategory AS _CreditControlCategory
               ON _CreditControlCategory.seq_credit_status_id = nc_client.seq_credit_status_id
                              LEFT JOIN DW_Staging.orion.nc_inv_deliver_mode
               ON nc_inv_deliver_mode.seq_inv_del_mode_id = nc_client.seq_inv_del_mode_id
          WHERE crm_party.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
            OR nc_client.Meta_LatestUpdate_TaskExecutionInstanceId > @LatestSuccessfulTaskExecutionInstanceID
            OR _accountStatus.Meta_HasChanged = 1;

    SELECT 0 AS ExtractRowCount,
           @@ROWCOUNT AS InsertRowCount,
           0 AS UpdateRowCount,
           0 AS DeleteRowCount,
           0 AS ErrorRowCount;

END;
GO
