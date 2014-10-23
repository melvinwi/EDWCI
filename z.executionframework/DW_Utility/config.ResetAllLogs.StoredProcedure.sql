USE [DW_Utility]
GO
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
