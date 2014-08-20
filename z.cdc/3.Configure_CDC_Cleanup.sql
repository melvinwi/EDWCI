Use Orion_VE;
go

EXECUTE sys.sp_cdc_change_job 
    @job_type = N'cleanup',
    @retention = 4320; --3 days retention
    --@retention = 2880; --2 days retention
GO

