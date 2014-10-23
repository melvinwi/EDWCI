USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Melvin Widodo
-- Create date: 12 Sep 2014
-- Description:	
-- =============================================
CREATE PROCEDURE [config].[procSetPackage]
	-- Add the parameters for the stored procedure here
	  @PackageId    INT
	, @PackagePath  VARCHAR (1035)
	, @PackageName  VARCHAR (256)
	, @ProjectName  VARCHAR (520)
	, @FolderName   VARCHAR (1035)
	, @IsDisabled   BIT
AS

/*
Usage:
  EXEC  [config].[procSetPackage]
      @PackageId    = NULL
    , @PackagePath  = N'CSV - Import - csv_FactMarketingCampaignActivity'
    , @PackageName  = N'CSV - Import - csv_FactMarketingCampaignActivity'
    , @ProjectName  = N'DW'
    , @FolderName   = N'DW'
    , @IsDisabled   = 0
*/


BEGIN

--DECLARE @PackageId INT

------- Get Existing Package ID --------------------
--SELECT @PackageId = PackageID
--FROM [config].[Package]
--WHERE 0 = 0
--	AND PackageName = @PackageName
--	AND FolderName = @FolderName 
--	AND ProjectName = @ProjectName

IF (ISNULL(@PackageId, 0) = 0)
BEGIN
	----- Insert Into [config].[Package] --------------------
	INSERT INTO [config].[Package] (PackagePath, PackageName, ProjectName, FolderName, IsDisabled)
	VALUES (@PackagePath, @PackageName, @ProjectName, @FolderName, @IsDisabled)
	SET @PackageId = @@IDENTITY
END
ELSE
BEGIN
	----- Update [config].[Package] --------------------
	UPDATE [config].[Package] SET
		PackagePath	= @PackagePath
		, PackageName = @PackageName
		, ProjectName = @ProjectName
		, FolderName = @FolderName
		, IsDisabled = @IsDisabled
	WHERE PackageID = @PackageId
END

----- Return ID --------------------
SELECT @PackageId AS PackageId

END

GO
