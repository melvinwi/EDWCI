CREATE VIEW [Views].[vMarketTransaction]
AS
SELECT -- DimAccount
       DimAccountCurrent.AccountCode,
       DimAccountCurrent.PostalAddressLine1,
       DimAccountCurrent.PostalSuburb,
       DimAccountCurrent.PostalPostcode,
       DimAccountCurrent.PostalState,
       DimAccountCurrent.PostalStateAsProvided,
       DimAccountCurrent.DistrictState,
       DimAccountCurrent.AccountStatus,
       DimAccountCurrent.AccountCreationDate,
       DimAccountCurrent.AccountClosedDate,
       DimAccountCurrent.CreditControlStatus,
       DimAccountCurrent.CreditControlCategory,
       DimAccountCurrent.InvoiceDeliveryMethod,
       DimAccountCurrent.PaymentMethod,
       DimAccountCurrent.MyAccountStatus,
       DimAccountCurrent.ACN,
       DimAccountCurrent.ABN,
       DimAccountCurrent.AccountType,
       DimAccountCurrent.BillCycleCode,
       -- DimService
       DimServiceCurrent.MarketIdentifier,
       DimServiceCurrent.ServiceType,
       DimServiceCurrent.LossFactor,
       DimServiceCurrent.EstimatedDailyConsumption,
       DimServiceCurrent.MeteringType,
       DimServiceCurrent.ResidentialSuburb,
       DimServiceCurrent.ResidentialPostcode,
       DimServiceCurrent.ResidentialState,
       DimServiceCurrent.NextScheduledReadDate,
       DimServiceCurrent.FRMPDate,
       DimServiceCurrent.Threshold,
       DimServiceCurrent.FirstImportRegisterDate,
       DimServiceCurrent.SiteStatus,
       DimServiceCurrent.SiteStatusType,
       -- DimTransmissionNode
       DimTransmissionNodeCurrent.TransmissionNodeIdentity,
       DimTransmissionNodeCurrent.TransmissionNodeName,
       DimTransmissionNodeCurrent.TransmissionNodeState,
       DimTransmissionNodeCurrent.TransmissionNodeNetwork,
       DimTransmissionNodeCurrent.TransmissionNodeServiceType,
       DimTransmissionNodeCurrent.TransmissionNodeLossFactor,
       -- DimChangeReason
       DimChangeReasonCurrent.ChangeReasonCode,
       DimChangeReasonCurrent.ChangeReasonDesc,
       -- FactMarketTransaction
       CONVERT(DATETIME2, CAST(FactMarketTransaction.TransactionDateId AS NCHAR(8)) + N' ' + CAST(FactMarketTransaction.TransactionTime AS NCHAR(16))) AS TransactionDate,
       FactMarketTransaction.TransactionType,
       FactMarketTransaction.TransactionStatus,
       FactMarketTransaction.TransactionKey,
       FactMarketTransaction.ParticipantCode,
       FactMarketTransaction.NEMTransactionKey,
       FactMarketTransaction.NEMInitialTransactionKey,
       FactMarketTransaction.MoveIn,
       FactMarketTransaction.TransactionCounter
FROM   DW_Dimensional.DW.FactMarketTransaction
LEFT   JOIN DW_Dimensional.DW.DimAccount ON DimAccount.AccountId = FactMarketTransaction.AccountId
LEFT   JOIN DW_Dimensional.DW.DimAccount AS DimAccountCurrent ON DimAccountCurrent.AccountKey = DimAccount.AccountKey AND DimAccountCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactMarketTransaction.ServiceId
LEFT   JOIN DW_Dimensional.DW.DimService AS DimServiceCurrent ON DimServiceCurrent.ServiceKey = DimService.ServiceKey AND DimServiceCurrent.Meta_IsCurrent = 1
LEFT   JOIN DW_Dimensional.DW.DimTransmissionNode AS DimTransmissionNodeCurrent ON DimTransmissionNodeCurrent.TransmissionNodeId = DimServiceCurrent.TransmissionNodeId
LEFT   JOIN DW_Dimensional.DW.DimChangeReason ON DimChangeReason.ChangeReasonId = FactMarketTransaction.ChangeReasonId
LEFT   JOIN DW_Dimensional.DW.DimChangeReason AS DimChangeReasonCurrent ON DimChangeReasonCurrent.ChangeReasonKey = DimChangeReason.ChangeReasonKey AND DimChangeReasonCurrent.Meta_IsCurrent = 1;


GO

