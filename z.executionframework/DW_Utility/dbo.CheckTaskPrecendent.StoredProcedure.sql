USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CheckTaskPrecendent]   @TaskExecutionID INT
AS

  /*
  Schema            : dbo
  Object            : CheckTaskPrecendent
  Author            : Jon Giles
  Created Date      : 01.08.2014
  Description       : Check whether a task's precendents have been satisfied for a given TaskExecution

  Change  History   : 
  Author  Date          Description of Change
  JG      10.09.2014    Altered to process a comma-seperated string of precedents (rather than just a single precedent).
  JG      12.09.2014    Simplified WHILE loop, amalgamating 3 statements into 1.
                        Removed unneccessary parameters: @PrecendentTaskID and @PrecendentStatus.
  JG      30.09.2014    Removed @ApplicationExecutionID clauses, to enable inter-application dependencies.
                        Removed cursor; replaced with set-based logic.
  <YOUR ROW HERE>     
  
  Usage:
    EXEC [dbo].[CheckTaskPrecendent] @TaskExecutionID = 123456789
 
  */


	SET NOCOUNT ON;
	
  --Declare parameters
	DECLARE @PrecendentComplete	    INT
	DECLARE @PrecedentTaskIdsList   NVARCHAR(1000)
  DECLARE @PrecedentTaskIds       TABLE ( PrecendentTaskID  INT 
                                        )	
  --/
  
  --Populate parameters
	SELECT    @PrecedentTaskIdsList   = PrecedentTaskIds
	FROM      dbo.TaskExecutionInstance
	WHERE     TaskExecutionInstanceID = @TaskExecutionID
  
  IF NULLIF(@PrecedentTaskIdsList, '') IS NOT NULL
    BEGIN
      INSERT INTO @PrecedentTaskIds ( PrecendentTaskID
                                    )
      SELECT  Item 
      FROM    dbo.DelimitedSplit (@PrecedentTaskIdsList, ',') 
    
    END
  --/

  --check the most recent execution statuses for all precedents, and set @PrecendentComplete to the minimum derived success value
  ;WITH PrecedentsByPrecedence AS 
    ( SELECT  TE.StatusCode
            , ROW_NUMBER() OVER (PARTITION BY TE.TaskId ORDER BY TE.TaskExecutionInstanceID DESC) AS Precedence 
      FROM        dbo.TaskExecutionInstance AS TE
      INNER JOIN  @PrecedentTaskIds         AS PT
              ON  PT.PrecendentTaskID = TE.TaskID
      --WHERE       TE.StatusUpdateDateTime > DATEADD(MONTH, -1, GETDATE()) --If execution duration slows over time, consider uncommenting this.
    )
  SELECT @PrecendentComplete = MIN( CASE  WHEN  ISNULL(StatusCode, 'S') = 'S'       THEN  1   --Precendent succeeded
                                          WHEN  StatusCode IN ('E', 'F', 'U', 'P')  THEN  -1  --Precendent failed     : the SSIS 'task' package won't attempt the task
                                                                                    ELSE  0   --Precendent pending    : the SSIS 'task' package will sleep and check again later
                                    END --If this statement returns 0 rows (e.g. if the precedent task was removed from the application), @PrecendentStatus will remain unchanged: no problem.
                                  )
  FROM  PrecedentsByPrecedence
  WHERE Precedence = 1
	--/

  --Return latest PrecendentComplete status
	SELECT ISNULL(@PrecendentComplete, 1)
  --/


GO
