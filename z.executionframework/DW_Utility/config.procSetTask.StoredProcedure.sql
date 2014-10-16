USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [config].[procSetTask]  @TaskId             INT           
                                  , @TaskName           NVARCHAR(255) 
                                  , @ApplicationId      INT           
                                  , @PackageId          INT           
                                  , @ParallelChannel    INT           
                                  , @ExecutionOrder     INT           
                                  , @PrecendentTaskIds  NVARCHAR(1000)
                                  , @ExecuteAsync       BIT           
                                  , @FailureActionCode  NCHAR(1)      
                                  , @RecoveryActionCode NCHAR(1)      
                                  , @IsActive           BIT           
                                  , @IsDisabled         BIT           
AS
  /*
  -- =============================================
  -- Author:		Melvin Widodo
  -- Create date: 15 Sep 2014
  -- Description:	
  -- =============================================

  Usage:
    EXEC config.procSetTask   @TaskId             = NULL
                            , @TaskName           = N'Truncate Table: DW_Work - DimFinancialAccount'
                            , @ApplicationId      = 4    
                            , @PackageId          = 17
                            , @ParallelChannel    = 1
                            , @ExecutionOrder     = 110
                            , @PrecendentTaskIds  = NULL
                            , @ExecuteAsync       = 0
                            , @FailureActionCode  = 'A'
                            , @RecoveryActionCode = 'R'
                            , @IsActive           = 1
                            , @IsDisabled         = 0
  */

  BEGIN

      IF ISNULL(@TaskId, 0) = 0
          BEGIN
              ----- Insert Into [config].[Task] --------------------
              INSERT INTO config.Task ( TaskName
                                      , ApplicationID
                                      , PackageID
                                      , ParallelChannel
                                      , ExecutionOrder
                                      , PrecendentTaskIds
                                      , ExecuteAsync
                                      , FailureActionCode
                                      , RecoveryActionCode
                                      , IsActive
                                      , IsDisabled
                                      )
                              VALUES  ( @TaskName
                                      , @ApplicationId
                                      , @PackageId
                                      , @ParallelChannel
                                      , @ExecutionOrder
                                      , @PrecendentTaskIds
                                      , @ExecuteAsync
                                      , @FailureActionCode
                                      , @RecoveryActionCode
                                      , @IsActive
                                      , @IsDisabled
                                      );
              SET @TaskId = @@Identity;
          END
      ELSE
          BEGIN
              ----- Update [config].[Task] --------------------
              UPDATE  config.Task
              SET     TaskName            = @TaskName
                    , ApplicationID       = @ApplicationId
                    , PackageID           = @PackageId
                    , ParallelChannel     = @ParallelChannel
                    , ExecutionOrder      = @ExecutionOrder
                    , PrecendentTaskIds   = @PrecendentTaskIds
                    , ExecuteAsync        = @ExecuteAsync
                    , FailureActionCode   = @FailureActionCode
                    , RecoveryActionCode  = @RecoveryActionCode
                    , IsActive            = @IsActive
                    , IsDisabled          = @IsDisabled
              WHERE   TaskID              = @TaskId;
          END

      ----- Return ID --------------------
      SELECT  @TaskId AS TaskId;

  END;

GO
