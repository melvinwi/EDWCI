USE [DW_Staging]
GO
CREATE PARTITION SCHEME [ps_TOU_Data_Week_right] AS PARTITION [pf_TOU_Data_Week_right] TO ([TOU_DATA01], [TOU_DATA01], [TOU_DATA01], [TOU_DATA01], [TOU_DATA01], [TOU_DATA01], [TOU_DATA01], [TOU_DATA01], [TOU_DATA01], [TOU_DATA01], [TOU_DATA01], [TOU_DATA01], [TOU_DATA01], [TOU_DATA02], [TOU_DATA02], [TOU_DATA02], [TOU_DATA02], [TOU_DATA02], [TOU_DATA02], [TOU_DATA02], [TOU_DATA02], [TOU_DATA02], [TOU_DATA02], [TOU_DATA02], [TOU_DATA02], [TOU_DATA02], [TOU_DATA03], [TOU_DATA03], [TOU_DATA03], [TOU_DATA03], [TOU_DATA03], [TOU_DATA03], [TOU_DATA03], [TOU_DATA03], [TOU_DATA03], [TOU_DATA03], [TOU_DATA03], [TOU_DATA03], [TOU_DATA03], [TOU_DATA04], [TOU_DATA04], [TOU_DATA04], [TOU_DATA04], [TOU_DATA04], [TOU_DATA04], [TOU_DATA04], [TOU_DATA04], [TOU_DATA04], [TOU_DATA04], [TOU_DATA04], [TOU_DATA04], [TOU_DATA04], [TOU_DATA04])
GO
