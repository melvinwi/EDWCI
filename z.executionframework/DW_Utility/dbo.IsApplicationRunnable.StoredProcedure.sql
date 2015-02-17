USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IsApplicationRunnable]
	@ApplicationID int
AS

/*
Usage:
  EXEC [dbo].[IsApplicationRunnable] 1
*/

	DECLARE @IsRunnable BIT
	
	IF 
    ( SELECT  COUNT(*)
		  FROM    dbo.ApplicationExecutionInstance
		  WHERE   ApplicationID = @ApplicationID
		    AND   StatusCode = 'E'
		) > 0
  OR NOT EXISTS
    ( SELECT  *
      FROM    config.[Application]
      WHERE   ApplicationID = @ApplicationID
		    AND   IsDisabled = 0
    )
	  BEGIN
		  SET @IsRunnable = 0
	  END
	ELSE
	  BEGIN
		  SET @IsRunnable = 1
	  END
	
	SELECT  @IsRunnable AS IsRunnable

GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IsApplicationRunnable]
	@ApplicationID int
AS

/*
Usage:
  EXEC [dbo].[IsApplicationRunnable] 1
*/

	DECLARE @IsRunnable BIT
	
	IF 
    ( SELECT  COUNT(*)
		  FROM    dbo.ApplicationExecutionInstance
		  WHERE   ApplicationID = @ApplicationID
		    AND   StatusCode = 'R'
		) > 0
  OR NOT EXISTS
    ( SELECT  *
      FROM    config.[Application]
      WHERE   ApplicationID = @ApplicationID
		    AND   IsDisabled = 0
    )
	  BEGIN
		  SET @IsRunnable = 0
	  END
	ELSE
	  BEGIN
		  SET @IsRunnable = 1
	  END
	
	SELECT  @IsRunnable AS IsRunnable

GO
