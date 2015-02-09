CREATE VIEW [Views].[vMarketTransactionHistorical]
AS
SELECT -- DimAccount
       DimAccount.AccountCode,
       DimAccount.PostalAddressLine1,
       DimAccount.PostalSuburb,
       DimAccount.PostalPostcode,
       DimAccount.PostalState,
       DimAccount.PostalStateAsProvided,
       DimAccount.DistrictState,
       DimAccount.AccountStatus,
       DimAccount.AccountCreationDate,
       DimAccount.AccountClosedDate,
       DimAccount.CreditControlStatus,
       DimAccount.CreditControlCategory,
       DimAccount.InvoiceDeliveryMethod,
       DimAccount.PaymentMethod,
       DimAccount.MyAccountStatus,
       DimAccount.ACN,
       DimAccount.ABN,
       DimAccount.AccountType,
       DimAccount.BillCycleCode,
       -- DimService
       DimService.MarketIdentifier,
       DimService.ServiceType,
       DimService.LossFactor,
       DimService.EstimatedDailyConsumption,
       DimService.MeteringType,
       DimService.ResidentialSuburb,
       DimService.ResidentialPostcode,
       DimService.ResidentialState,
       DimService.NextScheduledReadDate,
       DimService.FRMPDate,
       DimService.Threshold,
       DimService.FirstImportRegisterDate,
       DimService.SiteStatus,
       DimService.SiteStatusType,
       -- DimTransmissionNode
       DimTransmissionNode.TransmissionNodeIdentity,
       DimTransmissionNode.TransmissionNodeName,
       DimTransmissionNode.TransmissionNodeState,
       DimTransmissionNode.TransmissionNodeNetwork,
       DimTransmissionNode.TransmissionNodeServiceType,
       DimTransmissionNode.TransmissionNodeLossFactor,
       -- DimChangeReason
       DimChangeReason.ChangeReasonCode,
       DimChangeReason.ChangeReasonDesc,
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
LEFT   JOIN DW_Dimensional.DW.DimService ON DimService.ServiceId = FactMarketTransaction.ServiceId
LEFT   JOIN DW_Dimensional.DW.DimTransmissionNode ON DimTransmissionNode.TransmissionNodeId = DimService.TransmissionNodeId
LEFT   JOIN DW_Dimensional.DW.DimChangeReason ON DimChangeReason.ChangeReasonId = FactMarketTransaction.ChangeReasonId;


GO

