USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Melvin Widodo
-- Create date: 15 Sep 2014
-- Description:	
-- =============================================
CREATE PROCEDURE [config].[procSetTaskParameter]
	-- Add the parameters for the stored procedure here
@TaskParameterID INT
, @TaskID INT
, @ParameterName NVARCHAR(128)
, @ParameterValue sql_variant
, @ObjectType NVARCHAR(128)
, @IsDisabled BIT

AS
BEGIN

--DECLARE @TaskParameterID INT

------- Get Existing Task Parameter ID --------------------
--SELECT @TaskParameterID = TaskParameterID
--FROM [config].[TaskParameter]
--WHERE 0 = 0
--	AND TaskID = @TaskID
--	AND ParameterName = @ParameterName


IF (ISNULL(@TaskParameterID, 0) = 0)
BEGIN
	----- Insert Into [config].[TaskParameter] --------------------
	INSERT INTO [config].[TaskParameter] (TaskID, ParameterName, ParameterValue, ObjectType, IsDisabled)
	VALUES (@TaskID, @ParameterName, @ParameterValue, @ObjectType, @IsDisabled)
	SET @TaskParameterID = @@IDENTITY
END
ELSE
BEGIN
	----- Update [config].[TaskParameter] --------------------
	UPDATE [config].[TaskParameter] SET
		TaskID			 = @TaskID
		, ParameterName	 = @ParameterName
		, ParameterValue = @ParameterValue
		, ObjectType	 = @ObjectType
		, IsDisabled	 = @IsDisabled
	WHERE TaskParameterID = @TaskParameterID
END

----- Return ID --------------------
SELECT @TaskParameterID

END

GO
USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Melvin Widodo
-- Create date: 15 Sep 2014
-- Description:	
-- =============================================
CREATE PROCEDURE [config].[procSetTaskParameter]
	-- Add the parameters for the stored procedure here
@TaskParameterID INT
, @TaskID INT
, @ParameterName NVARCHAR(128)
, @ParameterValue sql_variant
, @ObjectType NVARCHAR(128)
, @IsDisabled BIT

AS
BEGIN

--DECLARE @TaskParameterID INT

------- Get Existing Task Parameter ID --------------------
--SELECT @TaskParameterID = TaskParameterID
--FROM [config].[TaskParameter]
--WHERE 0 = 0
--	AND TaskID = @TaskID
--	AND ParameterName = @ParameterName


IF (ISNULL(@TaskParameterID, 0) = 0)
BEGIN
	----- Insert Into [config].[TaskParameter] --------------------
	INSERT INTO [config].[TaskParameter] (TaskID, ParameterName, ParameterValue, ObjectType, IsDisabled)
	VALUES (@TaskID, @ParameterName, @ParameterValue, @ObjectType, @IsDisabled)
	SET @TaskParameterID = @@IDENTITY
END
ELSE
BEGIN
	----- Update [config].[TaskParameter] --------------------
	UPDATE [config].[TaskParameter] SET
		TaskID			 = @TaskID
		, ParameterName	 = @ParameterName
		, ParameterValue = @ParameterValue
		, ObjectType	 = @ObjectType
		, IsDisabled	 = @IsDisabled
	WHERE TaskParameterID = @TaskParameterID
END

----- Return ID --------------------
SELECT @TaskParameterID

END

GO
