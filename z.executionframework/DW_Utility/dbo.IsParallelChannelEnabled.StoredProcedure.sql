USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IsParallelChannelEnabled]
	@Channel int,
	@ApplicationExecutionInstanceID int
AS
	SELECT 
		CAST( CASE WHEN @Channel  = 1 
                    OR  (   AllowParallelExecution  =   1
                        AND ParallelChannels        >=  @Channel
                        ) 
            THEN  1
		      	ELSE  0
		      END AS BIT) AS ChannelEnabled
	FROM        dbo.ApplicationExecutionInstance  AS  e
	INNER JOIN  config.[Application]              AS  a 
              ON e.ApplicationID = a.ApplicationID
	WHERE e.ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID

GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IsParallelChannelEnabled]
	@Channel int,
	@ApplicationExecutionInstanceID int
AS
	SELECT 
		CAST( CASE WHEN @Channel  = 1 
                    OR  (   AllowParallelExecution  =   1
                        AND ParallelChannels        >=  @Channel
                        ) 
            THEN  1
		      	ELSE  0
		      END AS BIT) AS ChannelEnabled
	FROM        dbo.ApplicationExecutionInstance  AS  e
	INNER JOIN  config.[Application]              AS  a 
              ON e.ApplicationID = a.ApplicationID
	WHERE e.ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID

GO
