USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [lookup].[CreditControlCategory]
AS
SELECT 1 AS seq_credit_status_id, 'STANDARD' AS seq_credit_status_code, 'Immediate Recovery' AS CreditControlCategory UNION ALL
SELECT 2 AS seq_credit_status_id, 'PAYPLAN' AS seq_credit_status_code, 'Payment Plan' AS CreditControlCategory UNION ALL
SELECT 3 AS seq_credit_status_id, 'DOUBTFUL' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 4 AS seq_credit_status_id, 'OUT - DNB' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 5 AS seq_credit_status_id, 'EXTENSION' AS seq_credit_status_code, 'Payment Plan' AS CreditControlCategory UNION ALL
SELECT 6 AS seq_credit_status_id, 'OUT - NCML' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 7 AS seq_credit_status_id, 'ESCALATED' AS seq_credit_status_code, 'Further Work Required' AS CreditControlCategory UNION ALL
SELECT 8 AS seq_credit_status_id, 'HARDSHIP' AS seq_credit_status_code, 'Hardship' AS CreditControlCategory UNION ALL
SELECT 9 AS seq_credit_status_id, 'POT HARD' AS seq_credit_status_code, 'Hardship' AS CreditControlCategory UNION ALL
SELECT 10 AS seq_credit_status_id, 'GOV_ASSIST' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 11 AS seq_credit_status_id, 'OUT_ARL' AS seq_credit_status_code, 'Further Work Required' AS CreditControlCategory UNION ALL
SELECT 12 AS seq_credit_status_id, 'BOD_CORP' AS seq_credit_status_code, 'Immediate Recovery' AS CreditControlCategory UNION ALL
SELECT 13 AS seq_credit_status_id, 'DISC_DNP' AS seq_credit_status_code, 'Immediate Recovery' AS CreditControlCategory UNION ALL
SELECT 14 AS seq_credit_status_id, 'QLDFLOOD' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 15 AS seq_credit_status_id, 'MANUAL' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 16 AS seq_credit_status_id, 'VICFLOOD' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 17 AS seq_credit_status_id, 'PPLAN_PLUS' AS seq_credit_status_code, 'Payment Plan' AS CreditControlCategory UNION ALL
SELECT 18 AS seq_credit_status_id, 'PPLAN_CLSD' AS seq_credit_status_code, 'Payment Plan' AS CreditControlCategory UNION ALL
SELECT 19 AS seq_credit_status_id, 'PPLAN_PHRD' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 20 AS seq_credit_status_id, 'PPLAN_HARD' AS seq_credit_status_code, 'Hardship' AS CreditControlCategory UNION ALL
SELECT 21 AS seq_credit_status_id, 'PPLAN_INC' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 22 AS seq_credit_status_id, 'DNUNKUSR' AS seq_credit_status_code, 'Occupier' AS CreditControlCategory UNION ALL
SELECT 25 AS seq_credit_status_id, 'VICBFIRE' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 28 AS seq_credit_status_id, 'SABFIRE' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 29 AS seq_credit_status_id, 'NSWBFIRE' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 30 AS seq_credit_status_id, 'QLDBFIRE' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 31 AS seq_credit_status_id, 'RTS' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 32 AS seq_credit_status_id, 'NOEIC' AS seq_credit_status_code, 'Further Work Required' AS CreditControlCategory UNION ALL
SELECT 33 AS seq_credit_status_id, 'QLDFLD2013' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 34 AS seq_credit_status_id, 'DEF_VEDA' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 35 AS seq_credit_status_id, 'OUT_CRCLCT' AS seq_credit_status_code, 'Further Work Required' AS CreditControlCategory UNION ALL
SELECT 36 AS seq_credit_status_id, 'COMACCMGED' AS seq_credit_status_code, 'Immediate Recovery' AS CreditControlCategory UNION ALL
SELECT 37 AS seq_credit_status_id, 'WRONGSITE' AS seq_credit_status_code, 'Further Work Required' AS CreditControlCategory UNION ALL
SELECT 39 AS seq_credit_status_id, 'UNABLEDNP' AS seq_credit_status_code, 'Immediate Recovery' AS CreditControlCategory UNION ALL
SELECT 40 AS seq_credit_status_id, 'VICBFIRE14' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 41 AS seq_credit_status_id, 'OUT_WTRMN' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 43 AS seq_credit_status_id, 'DIS_RAISED' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 44 AS seq_credit_status_id, 'CM_MONITOR' AS seq_credit_status_code, 'Other' AS CreditControlCategory
 
 
 

GO
USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [lookup].[CreditControlCategory]
AS
SELECT 1 AS seq_credit_status_id, 'STANDARD' AS seq_credit_status_code, 'Immediate Recovery' AS CreditControlCategory UNION ALL
SELECT 2 AS seq_credit_status_id, 'PAYPLAN' AS seq_credit_status_code, 'Payment Plan' AS CreditControlCategory UNION ALL
SELECT 3 AS seq_credit_status_id, 'DOUBTFUL' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 4 AS seq_credit_status_id, 'OUT - DNB' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 5 AS seq_credit_status_id, 'EXTENSION' AS seq_credit_status_code, 'Payment Plan' AS CreditControlCategory UNION ALL
SELECT 6 AS seq_credit_status_id, 'OUT - NCML' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 7 AS seq_credit_status_id, 'ESCALATED' AS seq_credit_status_code, 'Further Work Required' AS CreditControlCategory UNION ALL
SELECT 8 AS seq_credit_status_id, 'HARDSHIP' AS seq_credit_status_code, 'Hardship' AS CreditControlCategory UNION ALL
SELECT 9 AS seq_credit_status_id, 'POT HARD' AS seq_credit_status_code, 'Hardship' AS CreditControlCategory UNION ALL
SELECT 10 AS seq_credit_status_id, 'GOV_ASSIST' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 11 AS seq_credit_status_id, 'OUT_ARL' AS seq_credit_status_code, 'Further Work Required' AS CreditControlCategory UNION ALL
SELECT 12 AS seq_credit_status_id, 'BOD_CORP' AS seq_credit_status_code, 'Immediate Recovery' AS CreditControlCategory UNION ALL
SELECT 13 AS seq_credit_status_id, 'DISC_DNP' AS seq_credit_status_code, 'Immediate Recovery' AS CreditControlCategory UNION ALL
SELECT 14 AS seq_credit_status_id, 'QLDFLOOD' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 15 AS seq_credit_status_id, 'MANUAL' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 16 AS seq_credit_status_id, 'VICFLOOD' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 17 AS seq_credit_status_id, 'PPLAN_PLUS' AS seq_credit_status_code, 'Payment Plan' AS CreditControlCategory UNION ALL
SELECT 18 AS seq_credit_status_id, 'PPLAN_CLSD' AS seq_credit_status_code, 'Payment Plan' AS CreditControlCategory UNION ALL
SELECT 19 AS seq_credit_status_id, 'PPLAN_PHRD' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 20 AS seq_credit_status_id, 'PPLAN_HARD' AS seq_credit_status_code, 'Hardship' AS CreditControlCategory UNION ALL
SELECT 21 AS seq_credit_status_id, 'PPLAN_INC' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 22 AS seq_credit_status_id, 'DNUNKUSR' AS seq_credit_status_code, 'Occupier' AS CreditControlCategory UNION ALL
SELECT 25 AS seq_credit_status_id, 'VICBFIRE' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 28 AS seq_credit_status_id, 'SABFIRE' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 29 AS seq_credit_status_id, 'NSWBFIRE' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 30 AS seq_credit_status_id, 'QLDBFIRE' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 31 AS seq_credit_status_id, 'RTS' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 32 AS seq_credit_status_id, 'NOEIC' AS seq_credit_status_code, 'Further Work Required' AS CreditControlCategory UNION ALL
SELECT 33 AS seq_credit_status_id, 'QLDFLD2013' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 34 AS seq_credit_status_id, 'DEF_VEDA' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 35 AS seq_credit_status_id, 'OUT_CRCLCT' AS seq_credit_status_code, 'Further Work Required' AS CreditControlCategory UNION ALL
SELECT 36 AS seq_credit_status_id, 'COMACCMGED' AS seq_credit_status_code, 'Immediate Recovery' AS CreditControlCategory UNION ALL
SELECT 37 AS seq_credit_status_id, 'WRONGSITE' AS seq_credit_status_code, 'Further Work Required' AS CreditControlCategory UNION ALL
SELECT 39 AS seq_credit_status_id, 'UNABLEDNP' AS seq_credit_status_code, 'Immediate Recovery' AS CreditControlCategory UNION ALL
SELECT 40 AS seq_credit_status_id, 'VICBFIRE14' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 41 AS seq_credit_status_id, 'OUT_WTRMN' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 43 AS seq_credit_status_id, 'DIS_RAISED' AS seq_credit_status_code, 'Other' AS CreditControlCategory UNION ALL
SELECT 44 AS seq_credit_status_id, 'CM_MONITOR' AS seq_credit_status_code, 'Other' AS CreditControlCategory

GO
