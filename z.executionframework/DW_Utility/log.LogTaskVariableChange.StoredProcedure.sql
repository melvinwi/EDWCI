USE [DW_Utility]
GO
/****** Object:  StoredProcedure [log].[LogTaskVariableChange]    Script Date: 16/10/2014 7:18:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [log].[LogTaskVariableChange]
	@TaskExecutionInstanceID int, 
	@VariableName varchar(255), 
	@VariableValue ntext
AS
	INSERT [log].[TaskExecutionVariableLog] (
		TaskExecutionInstanceID, VariableName, VariableValue, LoggedDateTime
	) VALUES (
		@TaskExecutionInstanceID, 
		@VariableName, 
		@VariableValue, 
		GETDATE()
	)
GO
