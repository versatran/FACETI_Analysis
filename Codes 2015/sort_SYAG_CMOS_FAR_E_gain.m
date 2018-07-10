%sort SYAG and CMOS_FAR on energy gain
clear all
% clearvars -except E200_vector ii
close all
sebas_colors=sebasColorTable;
%Get user to specify the dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%BEGIN USER INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
want_sorted={'CMOS_FAR_lineouts','SYAG_lineouts'}; 
% sort_parameter='CMOS_FAR_energy_gain';
% sort_parameter='start_energy_top';
sort_parameter='start_pixel_top';
% sort_parameter='transformer_ratio';
sort_structure='CMOS_FAR_energy_limits';
save_data=0;


% set path to data
% source_dir='/Volumes/LaCie 1/FACET_data/2014/';
source_dir='/Volumes/LaCie1/FACET_data/2015/';
% source_dir='/';
server_str='nas/nas-li20-pm00/';
% expt_str='E217';
expt_str='E200';

date_str='20150228';

dataset_str='14614';

%set to zero only if /nas is in the pwd
remote=1;

save_override=0;
%this parameter is necessary if there is a floor of noise that needs to be
%subtracted
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%END USER INPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Load dataset
data_path=[source_dir server_str expt_str '/' date_str(1:4) '/' date_str '/' ...
    expt_str '_' dataset_str '/' expt_str '_' dataset_str '.mat'];

% load data
data=E200_load_data(data_path,expt_str);
% Get prefix - if not remote, there is no prefix.
if remote
    prefix=get_remoteprefix();
else
    prefix='';
end

%check that the prefix is actually right! if it isn't, fix it! 
if ~strcmp(prefix,source_dir(1:end-1))
    setpref('FACET_data','prefix',source_dir(1:end-1));
    prefix=get_remoteprefix();
end

%load the processed structures 
processed_fields=fieldnames(data.processed.vectors);

%%
%Make the sort vector
%find the exact name of the structure to be sorted
sort_structure = find_exact_string(processed_fields,sort_structure);
sort_vector = data.processed.vectors.(genvarname(sort_structure)).(genvarname(sort_parameter));
[Y1,I1]=sort(sort_vector);        
sorted_UID=data.processed.vectors.(genvarname(sort_structure)).UID;
%this line actually sorts the UID
sorted_UID=sorted_UID(I1);

%%
%Sort the lineouts
for i=1:length(want_sorted)
    %j will be looping over the stack numbers
    j=1;
    wanted_sort_structure=find_exact_string(processed_fields,want_sorted{i});
    %get what user wants sorted    
    if findstr(wanted_sort_structure,'lineout')>0
        variable_to_sort='lineout';
    else
        error('don''t know what you want sorted!')
    end
    initial_vector=data.processed.vectors.(genvarname(wanted_sort_structure)).(genvarname(variable_to_sort));
    initial_UID=data.processed.vectors.(genvarname(wanted_sort_structure)).UID;
%     sorted_vector=initial_vector(I1);
    %this command finds the initial UID that intersects with sorted_ID
    %while keeping the order of sorted_UID intact (using the 'stable' flag)
    [UID_values,index_sorted_UID,index_initial_UID_matched]=intersect(sorted_UID,initial_UID,'stable');
    sorted_vector=initial_vector(j,index_initial_UID_matched,:);
    figure(i)
    imagesc(squeeze(sorted_vector)')
    
    colormap(sebas_colors)
end
figure(1)
hold on
plot(1:50,Y1(end,:),'k')


%%
%Figure labels
% SYAG
figure(2)
axis([1 50 200 900])
imcontrast
hold on
plot(1:50,800*ones(1,50),'k')
plot(1:50,720*ones(1,50),'r')
set(gcf,'position',[996,442,1380,434]);
set(gca,'fontsize',15)
title(['SYAG ' dataset_str ' sorted by decreasing Egain'])

%CMOS_FAR
figure(1)
axis([1 50 250 1500])
imcontrast
hold on
set(gcf,'position',[1000,951,1364,387])
set(gca,'fontsize',15)

title(['CMOS\_FAR ' dataset_str ' sorted by decreasing Egain'])
set(gca,'YTick',([400 600 800 1000 1200 1400]));
set(gca,'YTickLabel',round(data.processed.vectors.CMOS_FAR_lineouts_53_420.energy_vector([400 600 800 1000 1200 1400])));
ylabel('Energy (GeV)')

