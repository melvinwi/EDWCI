USE [DW_Utility]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [reports].[GetCDC_DataLossRisks]
AS

  /*
  Schema            :   reports
  Object            :   GetCDC_DataLossRisks
  Author            :   Jon Giles
  Created Date      :   27.11.2014
  Description       :   Returns one row per CDC refresh task that did not have a subsequent refresh within three days, since the most recent initial refresh.

  Change  History   : 
  Author  Date          Description of Change
  <YOUR ROW HERE>     
  
  Usage:
      EXEC [reports].[GetCDC_DataLossRisks]
  */

--
WITH TEI AS (
    SELECT    A.ApplicationId
            , T.PackagePath
            , T.StartDateTime
            --, TaskName
            , CASE WHEN T.TaskName LIKE 'CDC - Initial%' OR T.TaskName LIKE 'Full %' THEN 1 ELSE 0 END  AS IsInitial
            , ROW_NUMBER() OVER (PARTITION BY T.PackagePath ORDER BY T.StartDateTime DESC)              AS TableRefreshSequence
    FROM        dbo.TaskExecutionInstance         AS T
    INNER JOIN  dbo.ApplicationExecutionInstance  AS A
                ON  A.ApplicationExecutionInstanceID = T.ApplicationExecutionInstanceID
    WHERE T.PackagePath LIKE 'CDC%'
      AND T.StatusCode  = 'S'
      AND T.FolderName  = 'DW'
      AND T.ProjectName = 'DW'
  )
, rCTE AS (
    SELECT      ApplicationId
              , PackagePath
              , StartDateTime
              , IsInitial
              , TableRefreshSequence
              , DATEDIFF(MINUTE, StartDateTime, GETDATE()) AS MinutesUntilSubsequentLoad
    FROM        TEI
    WHERE       TableRefreshSequence = 1

      UNION ALL

    SELECT      TEI.ApplicationId
              , TEI.PackagePath
              , TEI.StartDateTime
              , TEI.IsInitial
              , TEI.TableRefreshSequence
              , DATEDIFF(MINUTE, TEI.StartDateTime, rCTE.StartDateTime)
    FROM        TEI
    INNER JOIN  rCTE
                ON  rCTE.PackagePath          = TEI.PackagePath
                AND rCTE.TableRefreshSequence = TEI.TableRefreshSequence - 1
                AND rCTE.IsInitial            = 0 --We only want to go back as far as the most recent initial refresh
  )
SELECT  rCTE.ApplicationId
      , rCTE.PackagePath
      , rCTE.StartDateTime
      , rCTE.IsInitial
      , rCTE.TableRefreshSequence
      , rCTE.MinutesUntilSubsequentLoad / 1440.0                              AS DaysUntilSubsequentLoad
      , DATEADD(MINUTE, rCTE.MinutesUntilSubsequentLoad, rCTE.StartDateTime)  AS SubsequentLoadStartDateTime
FROM      rCTE
WHERE     rCTE.MinutesUntilSubsequentLoad / 1440.0 > 3.7  --As refreshes typically take place between 2am and 4am, and CDC data is deleted at approximately 12:30am, we are only 
ORDER BY  rCTE.MinutesUntilSubsequentLoad DESC            --...concerned with gaps greater than 3.9 days. We check for >3.7 days to give a margin of error in these assumptions.
OPTION    (MAXRECURSION 10000)
--/
GO
