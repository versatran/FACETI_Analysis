%READ
%This is the edited version of sort_selected_snapshot_by_var, but this
%cannot run on its own as it depends on appdata taken from ImgTestGui
%This gets called in the menuWaterfall callback function of ImgTestGui

%selected snapshot sorted by some variable 
%WARNING: currently only works in 1D
% function [sorted_UID,sorting_values,sorted_vector] = sort_processed_by_acquired_data(data,want_sorted,sort_parameter)


sebas_colors=sebasColorTable;

%%%%%%%%%%%%Change to be user defined?
%subplot_columns=20; 
%probably dont need to ask for background verification here when this code fully works
%skip_background_verification=0;
%remove_xrays = 0;%should probably be 1, unless testing code since decreases speed
%remote=1;%Should probably be gotten from appdata as well?

%from ImgTestGui
source_dir=getappdata(0, 'source_dir');
server_str=getappdata(0, 'server_str');
expt_str=getappdata(0, 'expt_str');
date_str=getappdata(0, 'date_str');
dataset_str=getappdata(0, 'dataset_str');
data = getappdata(0, 'data');

%get parameter names for data set
scalar_struc=data.raw.scalars;
scalars = fieldnames(scalar_struc);
num_parameters = length(scalars);
%create empty cell array for converted parameters with more user friendly definitions
converted_parameters = cell(num_parameters+3,1);

%convert to user friendly defined parameters
for i = 1:num_parameters
        converted_parameters{i} = eda_extract_data_for_list(scalars{i});
end
%These are calculated in nvn_extract_data, they are not parameters in data
converted_parameters{num_parameters+1,1} = 'excess_charge_USBPM1_DSBPM1';
converted_parameters{num_parameters+2,1} = 'excess_charge_USBPM1_DSBPM2';
converted_parameters{num_parameters+3,1} = 'excess_charge_UStoro1_DStoro1';

%prompt user to select sorting parameter
[s, ok] = listdlg('PromptString','What would you like to sort by?', 'SelectionMode', 'single', 'ListString',converted_parameters);
sort_parameter = converted_parameters{s};
setappdata(0,'sort_parameter',sort_parameter);
% scalar_parameter = scalars(s);
% scalar_parameter = scalar_parameter{1};
%ASK about outputdir conflict between saveLineouts and here
outputdir=['E:\Sorting Output Directory\' date_str(1:4) ' FACET Analysis\'];

% load dataset
% prefix = getappdata(0,'prefix');
% image_struc = getappdata(0,'image_struc');
% stack_text = getappdata(0,'stack_text');
% func_name = getappdata(0,'func_name');
% bend_struc = getappdata(0,'bend_struc');
% show_noise_sample = getappdata(0,  'show_noise_sample');

num_stacks = getappdata(0,'num_stacks');
num_images = getappdata(0,'num_images');
data = getappdata(0, 'data');
camera = getappdata(0, 'camera');
dataset_str = getappdata(0, 'dataset_str');
linearize = getappdata(0, 'linearize');

%had problem of program being confused on which processed vector to look at
%so removed the fields that arent relevant. For 13116 20140601
%   data.processed.vectors = rmfield(data.processed.vectors, 'CMOS_FAR_lineouts_10_300_linearized');
%   data.processed.vectors = rmfield(data.processed.vectors, 'CMOS_FAR_lineouts_100_400_linearized');
%   data.processed.vectors = rmfield(data.processed.vectors, 'CMOS_FAR_lineouts_50_250_linearized');
%   data.processed.vectors = rmfield(data.processed.vectors, 'CMOS_FAR_lineouts_10_350');
%   data.processed.vectors = rmfield(data.processed.vectors, 'CMOS_FAR_energy_limits_10_350');
%   data.processed.vectors = rmfield(data.processed.vectors, 'CMOS_FAR_lineouts_1_400');
%   data.processed.vectors = rmfield(data.processed.vectors, 'CMOS_FAR_lineouts_1_350_linearized');
%   data.processed.vectors = rmfield(data.processed.vectors, 'CMOS_FAR_lineouts_1_350');
%   data.processed.vectors = rmfield(data.processed.vectors, 'CMOS_FAR_energy_limits_1_350');
%   data.processed.vectors = rmfield(data.processed.vectors, 'CMOS_FAR_lineouts_1_400_linearized');
%   data.processed.vectors = rmfield(data.processed.vectors, 'CMOS_FAR_energy_limits_1_400_linearized');
 
% setappdata(0, 'data', data);

%Perform sort
% [sorted_UID,sorting_values,sorted_vector] = sort_processed_by_acquired_data(data,'with_trapped_CMOS_WLAN',sort_parameter);
[sorted_UID,sorting_values,sorted_vector] = sort_processed_by_acquired_data(data,getappdata(0, 'save_struc_str' ),sort_parameter, s);
setappdata(0, 'sorting_values',sorting_values);


p = figure('Name', ['Parameter Plot ' sort_parameter ' ' dataset_str]);
set(p, 'color', [1,1,1]);
param_plot = plot(sorting_values);
param_plot_title = title(['Sorted by ' sort_parameter]);
param_plot_xlabel = xlabel('Corresponding Shot');
param_plot_ylabel = ylabel(sort_parameter);
set(param_plot_xlabel, 'Interpreter', 'none');
set(param_plot_title, 'Interpreter', 'none');
set(param_plot_ylabel, 'Interpreter', 'none');

w = figure('Name', ['Waterfall ' sort_parameter ' ' dataset_str]);
set(w, 'color', [1,1,1]);



% load_noiseless_images_15_edited;  
if camera.energy_camera
%             imagesc(image)
%             energy_pixel = getappdata(0, 'energy_pixel');
%             energy_ticks = getappdata(0, 'energy_ticks');
%             set(gca,'YTick',energy_pixel);
%             set(gca,'YTickLabel',energy_ticks);
            if linearize
                linear_energy_scale = getappdata(0, 'linear_energy_scale');
%                  set(gca,'XTick',linear_energy_scale);
 %                 set(gca,'XTickLabel','Energy (GeV)');
            end
                
        else
%             imagesc(this_image)
end        
        colormap(sebas_colors)
        set(gca,'clim',[120 1000])
%         ylabel(y_label_text,'fontsize',15); 
%         xlabel('pixels','fontsize',15);


if (linearize)
    im = imagesc(linear_energy_scale, linspace(0,num_images*num_stacks,10) , squeeze(sorted_vector));
else
    im = imagesc(squeeze(sorted_vector));
end
set(gcf, 'color', [1,1,1]);
waterfall_title = title(['Sorted by ' sort_parameter]);
waterfall_ylabel = ylabel('Corresponding Shot');
set(waterfall_ylabel, 'Interpreter', 'none');
waterfall_xlabel = xlabel('Energy (GeV)');
set(waterfall_title, 'Interpreter', 'none');

%uiconextmenu to change contrast using imcontrast right on image
m = uicontextmenu(w);
z = uimenu(m,'Label','Change Contrast','Callback', 'imcontrast');
set(im,'uicontextmenu',m);

% assert(num_groups==num_stacks,'you should choose shots from all stracks') 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Process and visualization
%background_checked=0;
%counter=0;

% for i=1:num_stacks    
%     if camera.energy_camera 
%         if exist('variable_bend','var')
%             dipole_bend=bend_struc.dipole_multiplier_values(i);
%             zero_Gev_px=bend_struc.zero_Gev_px_vector(i);                        
%         end
%         if dipole_bend~=1
%             stack_text{i}=['Dipole=' num2str(dipole_bend,2) ', ' stack_text{i}];
%         end
%     end
%     for j=1:length(sorted_vector)        
%         curr_image=sorted_vector(j);
%         load_noiseless_images_15_edited;  
%         counter=counter+1;
% 
%         %%%%%%%%%%%%%%%%%
%         %show the image 
%         %         if show_image && mod(j,2)==1 %Fix For odd(1) or even(0)
%         if counter ==1 
%             main_canvas=figure(50);
%             subplot_rows=ceil(length(sorted_vector)/subplot_columns);
% 
%             set(gcf,'position',[100 350 2400 1200])
% %             set(gca,'position',[0.02 0.02 0.96 0.96])
%         end
%             
% 
%         subplot(subplot_rows,subplot_columns,counter)
%         %make the original image if diagnostic is on, otherwise work
%         %only with linearized (or otherwise processed?) image
%         if camera.energy_camera
%             imagesc(image)
%             set(gca,'YTick',energy_pixel);
%             set(gca,'YTickLabel',energy_ticks);            
%         else
%             imagesc(this_image)
%         end        
%         colormap(sebas_colors)
%         set(gca,'clim',[120 1000])
% %         ylabel(y_label_text,'fontsize',15); 
% %         xlabel('pixels','fontsize',15);
%            
%     end
% 
% end
% 
% %set(gcf,'position',[100 943 2341 402]);
