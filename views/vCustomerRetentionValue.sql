CREATE VIEW Views.vCustomerRetentionValue
AS
WITH   customerValue AS (SELECT DimCustomer.CustomerCode,
                                DimCustomer.PartyName,
                                DimCustomer.ResidentialState,
                                FactCustomerValue.ValueRating,
                                ROW_NUMBER() OVER (PARTITION BY DimCustomer.CustomerCode ORDER BY FactCustomerValue.ValuationDateId DESC) AS recency
                         FROM   DW_Dimensional.DW.DimCustomer
                         INNER  JOIN DW_Dimensional.DW.FactCustomerValue ON FactCustomerValue.CustomerId = DimCustomer.CustomerId)
SELECT TOP 10 customerValue.CustomerCode,
       customerValue.ValueRating AS Rating,
       ISNULL(NULLIF(customerValue.PartyName, '') , '{Unknown}') AS PartyName,
       ISNULL(NULLIF(customerValue.ResidentialState, '') , '{U}') AS ResidentialState
FROM   customerValue
WHERE  customerValue.recency = 1