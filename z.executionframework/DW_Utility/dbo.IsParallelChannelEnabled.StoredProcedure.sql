USE [DW_Utility]
GO
/****** Object:  StoredProcedure [dbo].[IsParallelChannelEnabled]    Script Date: 16/10/2014 7:18:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IsParallelChannelEnabled]
	@Channel int,
	@ApplicationExecutionInstanceID int
AS
	SELECT 
		CASE WHEN (AllowParallelExecution = '1') THEN
			CASE WHEN (ParallelChannels >= @Channel) THEN
				CONVERT(bit, '1')
			ELSE
				CONVERT(bit, '0')
			END
		ELSE
			CASE WHEN (@Channel  = 1) THEN
				CONVERT(bit, '1')
			ELSE
				CONVERT(bit, '0')
			END
		END AS ChannelEnabled
	FROM dbo.ApplicationExecutionInstance e
	JOIN config.[Application] a ON (e.ApplicationID = a.ApplicationID)
	WHERE e.ApplicationExecutionInstanceID = @ApplicationExecutionInstanceID

GO
