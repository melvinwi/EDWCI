USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Melvin Widodo
-- Create date: 15 Sep 2014
-- Description:	
-- =============================================
CREATE PROCEDURE [config].[procSetApplication]
	-- Add the parameters for the stored procedure here
	@ApplicationID INT
	, @ApplicationName VARCHAR (1035)
	, @RecoveryActionCode VARCHAR (256)
	, @AllowParallelExecution VARCHAR (520)
	, @ParallelChannels VARCHAR (1035)
	, @IsDisabled BIT
AS
BEGIN

--DECLARE @ApplicationID INT

----- Get Existing Application ID --------------------
--SELECT @ApplicationID = ApplicationID
--FROM [config].[Application]
--WHERE 0 = 0
--	AND ApplicationName = @ApplicationName


IF (ISNULL(@ApplicationID, 0) = 0)
BEGIN
	----- Insert Into [config].[Application] --------------------
	INSERT INTO [config].[Application] (ApplicationName, RecoveryActionCode, AllowParallelExecution, ParallelChannels, IsDisabled)
	VALUES (@ApplicationName, @RecoveryActionCode, @AllowParallelExecution, @ParallelChannels, @IsDisabled)
	SET @ApplicationID = @@IDENTITY
END
ELSE
BEGIN
	----- Update [config].[Application] --------------------
	UPDATE [config].[Application] SET
		ApplicationName			 = @ApplicationName
		, RecoveryActionCode	 = @RecoveryActionCode
		, AllowParallelExecution = @AllowParallelExecution
		, ParallelChannels		 = @ParallelChannels
		, IsDisabled			 = @IsDisabled
	WHERE ApplicationID = @ApplicationID
END

----- Return ID --------------------
SELECT @ApplicationID

END

GO
