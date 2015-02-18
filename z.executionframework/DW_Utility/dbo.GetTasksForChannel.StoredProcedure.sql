USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTasksForChannel]
	@ApplicationExecutionInstanceID INT,
	@Channel INT
AS
	SELECT  l.TaskExecutionInstanceID
	FROM    dbo.TaskExecutionInstance l
	WHERE   l.ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
	  AND   l.ParallelChannel = @Channel	
	  AND   ( l.StatusCode = 'I'
	  	    OR  (   l.StatusCode <> 'S'
	  		      AND l.RecoveryActionCode = 'R'
	  	        )
	        )
	ORDER BY  l.ExecutionOrder ASC
          , l.TaskName ASC
GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTasksForChannel]
	@ApplicationExecutionInstanceID INT,
	@Channel INT
AS
	SELECT  l.TaskExecutionInstanceID
	FROM    dbo.TaskExecutionInstance l
	WHERE   l.ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID
	  AND   l.ParallelChannel = @Channel	
	  AND   ( l.StatusCode = 'I'
	  	    OR  (   l.StatusCode <> 'S'
	  		      AND l.RecoveryActionCode = 'R'
	  	        )
	        )
	ORDER BY  l.ExecutionOrder ASC
          , l.TaskName ASC

GO
