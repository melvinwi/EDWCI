USE [DW_Utility]
GO
/****** Object:  StoredProcedure [config].[ResetAllLogs]    Script Date: 16/10/2014 7:18:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [config].[ResetAllLogs]
AS
truncate table [dbo].[ApplicationExecutionInstance]
truncate table [dbo].[TaskExecutionInstance]
truncate table [log].[ApplicationExecutionError]
truncate table [log].[TaskExecutionError]
truncate table [log].[TaskExecutionVariableLog]
GO
