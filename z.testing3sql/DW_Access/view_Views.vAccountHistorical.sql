USE [DW_Access]
GO

/****** Object:  View [Views].[vAccountHistorical]    Script Date: 2/09/2014 12:14:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [Views].[vAccountHistorical]
AS SELECT        AccountCode,
                 ISNULL(NULLIF(PostalAddressLine1,''),'{Unknown}') AS PostalAddressLine1,
                 ISNULL(NULLIF(PostalSuburb,''),'{Unknown}') AS PostalSuburb,
                 ISNULL(NULLIF(PostalPostcode,''),'{Un}') AS PostalPostcode,
                 ISNULL(NULLIF(PostalState,''),'{U}') AS PostalState,
                 ISNULL(NULLIF(PostalStateAsProvided,''),'{U}') AS PostalStateAsProvided,
                 ISNULL(NULLIF(MyAccountStatus,''),'{Unknown}') AS MyAccountStatus,
                 CreationDate,
                 ISNULL(NULLIF(AccountStatus,''),'{Unkn}') AS AccountStatus,
                 AccountClosedDate,
                 AccountBillStartDate,
                 ISNULL(NULLIF(CreditControlStatus,''),'{Unknown}') AS CreditControlStatus,
                 ISNULL(NULLIF(InvoiceDeliveryMethod,''),'{Unknown}') AS InvoiceDeliveryMethod,
                 ISNULL(NULLIF(PaymentMethod,''),'{Unknown}') AS PaymentMethod,
			  Meta_IsCurrent,
			  Meta_EffectiveStartDate,
			  Meta_EffectiveEndDate
     FROM DW_Dimensional.DW.DimAccount;
	

GO

