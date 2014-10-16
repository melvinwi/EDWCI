USE [DW_Utility]
GO
/****** Object:  StoredProcedure [dbo].[IsApplicationAborted]    Script Date: 16/10/2014 7:18:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[IsApplicationAborted]
	@ApplicationExecutionInstanceID int
AS
	SELECT
		ExecutionAborted
	FROM dbo.ApplicationExecutionInstance
	WHERE ApplicationExecutionInstanceID=@ApplicationExecutionInstanceID
GO
