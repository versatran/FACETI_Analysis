%add selected shots to the dataset
%For 18010
% with_trapped_WLAN=[2 16 18 20 21 29 30 31 32 33 35:39 44 45 46 49 56 62 66 71 99];
% with_trapped_WLAN=[2:100];
% with_trapped_WLAN=[2:220];
with_trapped_WLAN=[5 18 23 24 37]
% camera='CMOS_WLAN';
camera='CMOS_FAR';

%add the special shots to the dataset
% special_struc_identifier=['_with_trapped_' camera];
% special_struc_identifier=['_all_shots_' camera];
special_struc_identifier=['_for_LPAW_' camera];

expt_str='E200';
date_str='20140406';
dataset_str='12414';


% cmt_str='with trapped charge UID fixed';
% cmt_str='all data UID fixed';
cmt_str='showing data for LPAW 2015 paper';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save_struc_str = ['special_shots' special_struc_identifier];

% load dataset
% data = simple_data_load('E217','20150607','18010');
% data = simple_data_load('E217','20150606','17979');
data = simple_data_load(expt_str,date_str,dataset_str);
select_indeces=with_trapped_WLAN;

process_struc.camera=camera;
process_struc.readme_comment=cmt_str;
process_struc.special_indecies=select_indeces;

if strcmp(camera,'CMOS_WLAN')
    process_struc.UID=data.raw.images.(genvarname(camera)).UID(select_indeces-1);
else
    process_struc.UID=data.raw.images.(genvarname(camera)).UID(select_indeces);
end

data.processed.vectors.(genvarname(save_struc_str))=process_struc;
E200_save_remote(data,0)
display('Data saved!')