USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IsApplicationRunning]
	@ApplicationID int
AS

/*
Usage:
  EXEC [dbo].[IsApplicationRunning] 1
*/

	DECLARE @IsRunning bit
	
	IF (
		SELECT
			COUNT(*)
		FROM dbo.ApplicationExecutionInstance
		WHERE ApplicationID = @ApplicationID
		AND StatusCode = 'E'
		) > 0
	BEGIN
		SET @IsRunning = '1'
	END
	ELSE
	BEGIN
		SET @IsRunning = '0'
	END
	
	SELECT @IsRunning

GO
