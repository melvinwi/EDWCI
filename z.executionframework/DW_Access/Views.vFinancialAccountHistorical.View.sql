USE [DW_Access]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Views].[vFinancialAccountHistorical]
AS SELECT ISNULL(NULLIF(FinancialAccountName,''),'{Unknown}') AS FinancialAccountName,
          ISNULL(NULLIF(FinancialAccountType,''),'{Unknown}') AS FinancialAccountType,
          ISNULL(NULLIF(Level1Name,''),'{Unknown}') AS Level1Name,
          ISNULL(NULLIF(Level2Name,''),'{Unknown}') AS Level2Name,
          ISNULL(NULLIF(Level3Name,''),'{Unknown}') AS Level3Name,
          Meta_IsCurrent,
          Meta_EffectiveStartDate,
          Meta_EffectiveEndDate
   FROM   DW_Dimensional.DW.DimFinancialAccount;



GO
