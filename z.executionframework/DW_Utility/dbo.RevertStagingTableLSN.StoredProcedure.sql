USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RevertStagingTableLSN]
                @SchemaName               NVARCHAR(256) NULL
              , @TableName                NVARCHAR(256) NULL
              , @LSN_State                NVARCHAR(256) NULL
              , @TaskExecutionInstanceID  INT NULL
              , @Debug                    BIT NULL
AS

  /*
  Schema            :   dbo
  Object            :   RevertStagingTableLSN
  Author            :   Jon Giles
  Created Date      :   29.10.2014
  Description       :   Reverts the LSN CDC state value stored in the DW_Staging..CDC_States table to that of the last successful refresh.

  Change  History   : 
  Author  Date          Description of Change
  JG      29.10.2014    Created
  <YOUR ROW HERE>     
  
  Usage:
        EXEC  DW_Utility.dbo.RevertStagingTableLSN
                @SchemaName               = 'orion'
              , @TableName                = 'ar_aged_debtor_balance'
              , @LSN_State                = NULL  --'TFEND/CS/0x012412FD000880A90002/TS/2014-10-27T15:43:48.7234805/'
              , @TaskExecutionInstanceID  = NULL
              , @Debug                    = 1
  */
    
  SET NOCOUNT ON

  --Derive the LSN_State, if it hasn't been specified.
  IF @LSN_State IS NULL
  BEGIN
    
    --Get TaskId Using @TaskExecutionInstanceID / by PackageName and TaskName
    DECLARE @TaskId TABLE (TaskId INT NULL) --We expect there to be 2 valid TaskIds (Initial Load and Incremental Load)
    
    INSERT  INTO @TaskId  ( TaskID
                          )
    SELECT    TaskId 
    FROM      dbo.TaskExecutionInstance 
    WHERE     TaskExecutionInstanceID = @TaskExecutionInstanceID
    GROUP BY  TaskId
    
    UNION
    
    SELECT  TaskId 
    FROM    config.Task 
    WHERE   TaskName LIKE N'CDC%' + @SchemaName + N'%' + @TableName + N'%' 
        AND PackageID IN  ( SELECT  PackageID 
                            FROM    config.Package 
                            WHERE   ProjectName = 'DW' 
                                AND PackageName LIKE N'CDC%' + @SchemaName + N'%' + @TableName + N'%' 
                                AND IsDisabled = 0
                          )
    --/

    --Get LSN_State from most recent successful CDC load
    SELECT      TOP 1 @LSN_State = L.VariableValue 
    FROM        [log].TaskExecutionVariableLog  AS L
    INNER JOIN  dbo.TaskExecutionInstance       AS T
                ON T.TaskExecutionInstanceID = L.TaskExecutionInstanceID
    INNER JOIN  @TaskId                         AS TP
                ON TP.TaskId    = T.TaskId
    WHERE       T.StatusCode    = N'S'
            AND L.VariableName  = N'CDC_State'
    ORDER BY    T.EndDateTime     DESC
              , L.LoggedDateTime  DESC
    --/
  END
  --/

  --Set @SQL string
  DECLARE @SQL NVARCHAR(MAX)  = N'UPDATE DW_Staging.' + @SchemaName + N'.CDC_States SET [State] = ''' + @LSN_State 
                                + N''' WHERE [Name] = ''' + @TableName + N''' AND [State] <> ''' + @LSN_State + N''''
  --/

  SET NOCOUNT OFF

  --Print or Execute @SQL string
  IF @Debug = 1 OR @SQL IS NULL
    BEGIN
      PRINT ISNULL(@SQL, N'@SQL is NULL in [dbo].[RevertStagingTableLSN]')
    END
  ELSE 
    BEGIN
      EXEC sp_executesql @SQL
    END
  --/
GO
