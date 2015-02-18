USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimUnitType](
	[UnitTypeKey] [nvarchar](30) NULL,
	[UnitTypeName] [nvarchar](20) NULL,
	[MultiplicationFactorToBase] [decimal](12, 4) NULL
) ON [PRIMARY]

GO
USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[DimUnitType](
	[UnitTypeKey] [nvarchar](30) NULL,
	[UnitTypeName] [nvarchar](20) NULL,
	[MultiplicationFactorToBase] [decimal](12, 4) NULL
) ON [DATA]

GO
