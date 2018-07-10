PVs = {'OSC:LA20:10:FS_TGT_TIME'; 'XPS:LA20:LS24:M1.RBV'};
start_str =  '04/02/2016 12:00:00';
end_str =  '04/03/2016 15:00:00';
expt = 'E225';
header = '/Volumes/PWFA_5big';

[vals,times] = E200_crawl(PVs,start_str,end_str,expt,header);

plot(times,vals,'o'); datetick('x');