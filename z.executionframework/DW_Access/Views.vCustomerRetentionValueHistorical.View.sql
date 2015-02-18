USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Views].[vCustomerRetentionValueHistorical]
AS
SELECT DimCustomer.CustomerCode,
       CONVERT(DATE, CAST(FactCustomerValue.ValuationDateId AS NCHAR(8)), 112) AS ValuationDate,
       FactCustomerValue.ValueRating AS Rating,
       DimCustomer.PartyName,
       DimCustomer.ResidentialState
FROM   DW_Dimensional.DW.FactCustomerValue
INNER  JOIN DW_Dimensional.DW.DimCustomer ON DimCustomer.CustomerId = FactCustomerValue.CustomerId


GO
