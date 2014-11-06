USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROC [dbo].[RethrowError]
AS

/*
  Schema          : dbo
  Object          : RethrowError
  Author          : Jon Giles
  Created Date    : 11.08.2014
  Description     : Rethrows an error (e.g. within the CATCH block of a TRY CATCH)

  Change History  : 
  Author  Date        Description of Change
  JG      26/09/2014  added: WITH LOG
  <YOUR ROW HERE>
  
  Usage:
    EXEC dbo.RethrowError

  */
  
	DECLARE @ErrorMessage   NVARCHAR(4000)
	      , @ErrorNumber    INT
	      , @ErrorSeverity  INT
	      , @ErrorState     INT
	      , @ErrorLine      INT
	      , @ErrorProcedure NVARCHAR(200);
	
	SELECT  @ErrorNumber    = ERROR_NUMBER()
		    , @ErrorSeverity  = ERROR_SEVERITY()
		    , @ErrorState     = CASE WHEN ERROR_STATE() > 0 THEN ERROR_STATE() ELSE 1 END
		    , @ErrorLine      = ERROR_LINE()
		    , @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-')
		    , @ErrorMessage   = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: ' + ERROR_MESSAGE();

	RAISERROR ( @ErrorMessage
            , @ErrorSeverity
            , @ErrorState
            , @ErrorNumber
            , @ErrorSeverity
            , @ErrorState
            , @ErrorProcedure
            , @ErrorLine
            ) WITH LOG;
GO
