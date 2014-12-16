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
  JG      28.11.2014    Changed join from INNER to LEFT OUTER so as to catch task precedents that have not been initialised
                        Also added clause to filter tasks with a greater TaskExecutionInstanceID, as these are now generated in the order in which they're expected to be run, and we don't want to check subsequently initialised tasks.
  JG      04/12/2014    Added join to config.Task, to filter invalid taskIds.
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
  --DECLARE @ApplicationExecutionID INT
  --/
  
  --Populate parameters
	SELECT    @PrecedentTaskIdsList   = PrecedentTaskIds
          --, @ApplicationExecutionID = ApplicationExecutionInstanceID
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
    ( SELECT  ISNULL(TE.StatusCode, 'U')                                                                                AS  StatusCode
            , ROW_NUMBER() OVER (PARTITION BY PT.PrecendentTaskID ORDER BY ISNULL(TE.TaskExecutionInstanceID, 0) DESC)  AS  Precedence 
      FROM            @PrecedentTaskIds         AS PT
      INNER JOIN      config.Task               AS T
                      ON  T.TaskID = PT.PrecendentTaskID
      LEFT OUTER JOIN dbo.TaskExecutionInstance AS TE
                      ON  TE.TaskID = PT.PrecendentTaskID
      WHERE         TE.TaskExecutionInstanceID < @TaskExecutionID
      --AND           TE.StatusUpdateDateTime > DATEADD(MONTH, -1, GETDATE()) --If execution duration slows over time, consider uncommenting this.
    )
  SELECT @PrecendentComplete = MIN( CASE  WHEN  ISNULL(StatusCode, 'S') = 'S'       THEN  1   --Precendent succeeded or none exists
                                          WHEN  StatusCode IN ('E', 'F', 'U', 'P')  THEN  -1  --Precendent failed : the SSIS 'task' package won't attempt the task
                                          WHEN  StatusCode = 'I'                    THEN  0   --Precendent initialised but pending : the SSIS 'task' package will sleep and check again later
                                                                                    ELSE  0
                                    END
                                  )
  FROM  PrecedentsByPrecedence
  WHERE Precedence = 1
	--/

  --Return latest PrecendentComplete status
	SELECT ISNULL(@PrecendentComplete, 1)
  --/


GO
