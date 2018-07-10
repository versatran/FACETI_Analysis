%selected snapshot sorted by some variable 
%WARNING: currently only works in 1D
% function [sorted_UID,sorting_values,sorted_vector] = sort_processed_by_acquired_data(data,want_sorted,sort_parameter)
clearvars
close all

sebas_colors=sebasColorTable;


expt_str='E217';
% expt_str='E200';
% date_str='20150606';
% dataset_str='18010';
date_str='20140601';
% date_str='20140406';
% date_str='20141213';
% dataset_str='13116';
dataset_str='13122';
% dataset_str='13439';
% dataset_str='14295';
% dataset_str='17979';
% dataset_str='17983';
camera='CMOS_FAR';
% camera='CMOS_WLAN';
% camera='BETAL';
% sort_parameter='DS_toro1';
% sort_parameter='LaserE';
% sort_parameter='pyro_int';
sort_parameter='US_BPM1_raw';
% sort_parameter='US_BPM1_Y';
curr_clim=[0 2000];
% want_sorted_string='for_LPAW';
want_sorted_string='lineout_300_550';

outputdir=['/Users/Navid/Library/Mobile Documents/com~apple~CloudDocs/Lab Work/' date_str(1:4) ' FACET Analysis/'];


source_dir=['/Volumes/LaCie/FACET_data/' date_str(1:4) '/'];
setpref('FACET_data','prefix',source_dir) 
server_str='nas/nas-li20-pm00/';
scale_adjustment=1;
subplot_columns=5;
skip_background_verification=0;
remove_xrays = 1;
linearize=1; 
skip_DCOffset=0;
%format is [x0 y0 w h]
draw_ROI=[170 300 500 2180];

%position on the monitor
% image_position=[100 350 2400 1200];
image_position= [730 454 1285 664]; %for lpaw
%load camera config
camera= load_camera_config(camera);
% load dataset
[prefix,data,num_stacks,image_struc,num_images,stack_text] = ...
    nvn_load_data(expt_str,source_dir,server_str,date_str...
    ,dataset_str,camera.name);

%Perform sort
% [sorted_UID,sorting_values,sorted_vector] = sort_processed_by_acquired_data(data,'with_trapped_CMOS_WLAN',sort_parameter);
[sorted_UID,sorting_values,sorted_vector] = sort_processed_by_acquired_data(data,want_sorted_string,sort_parameter);

%TODO: Have to figure how to deal with multiple stacks, which have
%diffefrent size of selected shots. 
% [num_groups,num_selected_]=size(sorted_vector);

figure(25)
plot(sorting_values,'bo','markerfacecolor','b')
ylabel(sort_parameter)

% assert(num_groups==num_stacks,'you should choose shots from all stracks') 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Process and visualization
background_checked=0;
counter=0;
for i=1:num_stacks    
% for i=1:1    
    if camera.energy_camera 
        if exist('variable_bend','var')
            dipole_bend=bend_struc.dipole_multiplier_values(i);
            zero_Gev_px=bend_struc.zero_Gev_px_vector(i);                        
        end
%         if dipole_bend~=1
%             stack_text{i}=['Dipole=' num2str(dipole_bend,2) ', ' stack_text{i}];
%         end
    end
    imagesc(squeeze(sorted_vector))
    for j=1:length(sorted_vector)
        curr_image=sorted_vector(j);
        load_noiseless_images_15  
        counter=counter+1;

        %%%%%%%%%%%%%%%%%
        %show the image 
        %         if show_image && mod(j,2)==1 %Fix For odd(1) or even(0)
        if counter ==1 
            main_canvas=figure(50);
            subplot_rows=ceil(length(sorted_vector)/subplot_columns);

            set(gcf,'position',image_position)
%             set(gca,'position',[0.02 0.02 0.96 0.96])
        end
            

        subplot(subplot_rows,subplot_columns,counter)
        %make the original image if diagnostic is on, otherwise work
        %only with linearized (or otherwise processed?) image
        if camera.energy_camera
            imagesc(this_image)
            set(gca,'YTick',energy_pixel);
            set(gca,'YTickLabel',energy_ticks);            
        else
            imagesc(this_image)
        end        
        colormap(sebas_colors)
        set(gca,'clim',curr_clim)
        set(gca,'fontsize',15)
%         ylabel(y_label_text,'fontsize',15); 
%         xlabel('pixels','fontsize',15);
           
    end

end

%set(gcf,'position',[100 943 2341 402]);
