USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [log].[LogTaskParameterChange]
	  @TaskExecutionInstanceID INT
	, @ParameterName NVARCHAR(128) 
	, @ParameterValue SQL_VARIANT
AS
	INSERT  [log].[TaskExecutionParameterLog]  
          ( TaskExecutionInstanceID
          , ParameterName
          , ParameterValue
          , LoggedDateTime
          )
  VALUES  ( @TaskExecutionInstanceID
	        , @ParameterName
	        , @ParameterValue
	        , GETDATE()
	        )

GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [log].[LogTaskParameterChange]
	  @TaskExecutionInstanceID INT
	, @ParameterName NVARCHAR(128) 
	, @ParameterValue SQL_VARIANT
AS
	INSERT  [log].[TaskExecutionParameterLog]  
          ( TaskExecutionInstanceID
          , ParameterName
          , ParameterValue
          , LoggedDateTime
          )
  VALUES  ( @TaskExecutionInstanceID
	        , @ParameterName
	        , @ParameterValue
	        , GETDATE()
	        )

GO
