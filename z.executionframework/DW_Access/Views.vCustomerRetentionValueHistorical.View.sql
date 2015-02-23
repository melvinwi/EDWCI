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
       COALESCE(FactCustomerValue.ValueRating, '') AS Rating,
       COALESCE(DimCustomer.PartyName, '') AS PartyName,
       COALESCE(DimCustomer.ResidentialState, '') AS ResidentialState
FROM   DW_Dimensional.DW.FactCustomerValue
INNER  JOIN DW_Dimensional.DW.DimCustomer ON DimCustomer.CustomerId = FactCustomerValue.CustomerId


GO
