USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Views].[vCustomerRetentionValue]
AS
WITH   customerValue AS (SELECT DimCustomer.CustomerCode,
                                DimCustomer.PartyName,
                                DimCustomer.ResidentialState,
                                FactCustomerValue.ValueRating,
                                ROW_NUMBER() OVER (PARTITION BY DimCustomer.CustomerCode ORDER BY FactCustomerValue.ValuationDateId DESC) AS recency
                         FROM   DW_Dimensional.DW.DimCustomer
                         INNER  JOIN DW_Dimensional.DW.FactCustomerValue ON FactCustomerValue.CustomerId = DimCustomer.CustomerId)
SELECT customerValue.CustomerCode,
       COALESCE(customerValue.ValueRating, '') AS Rating,
       COALESCE(customerValue.PartyName, '') AS PartyName,
       COALESCE(customerValue.ResidentialState, '') AS ResidentialState
FROM   customerValue
WHERE  customerValue.recency = 1


GO
