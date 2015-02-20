USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [lookup].[Product]
AS
SELECT 'Lumo Advantage' AS ProductKey,	'Lumo Advantage' AS ProductName,	'Best rates available' AS ProductDesc, 'Legacy' AS ProductType UNION ALL
SELECT 'Lumo Basic' AS ProductKey,	'Lumo Basic' AS ProductName,	'No exit fees' AS ProductDesc, 'Legacy' AS ProductType UNION ALL
SELECT 'Lumo Express' AS ProductKey,	'Lumo Express' AS ProductName,	'Lumo Express' AS ProductDesc, 'Legacy' AS ProductType UNION ALL
SELECT 'Lumo Life 10' AS ProductKey,	'Lumo Life 10' AS ProductName,	'Power your home with green energy' AS ProductDesc, 'Legacy' AS ProductType UNION ALL
SELECT 'Lumo Life 100' AS ProductKey,	'Lumo Life 100' AS ProductName,	'Lumo Life 100' AS ProductDesc, 'Legacy' AS ProductType UNION ALL
SELECT 'Lumo Movers' AS ProductKey,	'Lumo Movers' AS ProductName,	'Perfect for people moving or those that move a lot' AS ProductDesc, 'Legacy' AS ProductType UNION ALL
SELECT 'Lumo Options' AS ProductKey,	'Lumo Options' AS ProductName,	'Perfect for renters. Our standing offer' AS ProductDesc, 'Legacy' AS ProductType UNION ALL
SELECT 'Lumo Velocity' AS ProductKey,	'Lumo Velocity' AS ProductName,	'Perfect for Velocity Frequent Flyer Members' AS ProductDesc, 'Legacy' AS ProductType UNION ALL
SELECT 'Lumo Virgin Staff' AS ProductKey,	'Lumo Virgin Staff' AS ProductName,	'Lumo Virgin Staff' AS ProductDesc, 'Legacy' AS ProductType


GO
USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [lookup].[Product]
AS
SELECT 'Lumo Advantage' AS ProductKey,	'Lumo Advantage' AS ProductName,	'Best rates available' AS ProductDesc, 'Legacy' AS ProductType UNION ALL
SELECT 'Lumo Basic' AS ProductKey,	'Lumo Basic' AS ProductName,	'No exit fees' AS ProductDesc, 'Legacy' AS ProductType UNION ALL
SELECT 'Lumo Express' AS ProductKey,	'Lumo Express' AS ProductName,	'Lumo Express' AS ProductDesc, 'Legacy' AS ProductType UNION ALL
SELECT 'Lumo Life 10' AS ProductKey,	'Lumo Life 10' AS ProductName,	'Power your home with green energy' AS ProductDesc, 'Legacy' AS ProductType UNION ALL
SELECT 'Lumo Life 100' AS ProductKey,	'Lumo Life 100' AS ProductName,	'Lumo Life 100' AS ProductDesc, 'Legacy' AS ProductType UNION ALL
SELECT 'Lumo Movers' AS ProductKey,	'Lumo Movers' AS ProductName,	'Perfect for people moving or those that move a lot' AS ProductDesc, 'Legacy' AS ProductType UNION ALL
SELECT 'Lumo Options' AS ProductKey,	'Lumo Options' AS ProductName,	'Perfect for renters. Our standing offer' AS ProductDesc, 'Legacy' AS ProductType UNION ALL
SELECT 'Lumo Velocity' AS ProductKey,	'Lumo Velocity' AS ProductName,	'Perfect for Velocity Frequent Flyer Members' AS ProductDesc, 'Legacy' AS ProductType UNION ALL
SELECT 'Lumo Virgin Staff' AS ProductKey,	'Lumo Virgin Staff' AS ProductName,	'Lumo Virgin Staff' AS ProductDesc, 'Legacy' AS ProductType

GO
