% READ
% This script creates and saves lineouts in data structure 
% This script is called in menuSaveLineouts_Callback(in lineouts.m and 
% ImgTestGui.m), and menuWaterfall_Callback asks for range of lineout to give 
% the option of creating lineouts without viewing them. This is also needed for 
% waterfall plot creation

clear vars; % NOTE: is this supposed to be the method 'clearvars'?

dataset_str = getappdata(0, 'dataset_str');
date_str = getappdata(0, 'date_str');
camera = getappdata(0, 'camera');
outputdir = ['E:/Lab Work/FACET Analysis/' dataset_str '/'];
setappdata(0, 'outputdir', outputdir);
data = getappdata(0, 'data');
linearize = getappdata(0, 'linearize');
save_override = 0;
show_noise_sample = getappdata(0, 'show_noise_sample');
scale_adjustment = getappdata(0, 'scale_adjustment');
DC_offset = getappdata(0, 'DC_offset');
save_data = getappdata(0, 'save_data');
skip_background_verification = getappdata(0, 'skip_background_verification');
remove_xrays = getappdata(0, 'remove_xrays');

if(linearize)
    check_linearize_ROI = getappdata(0, 'check_linearize_ROI');
    if (check_linearize_ROI)
        draw_ROI = getappdata(0, 'draw_ROI'); % CMOSFAR 2014 15 up to 
                                              % 35 GeV 13128 close up
    end
end

% prompt user for starting line and ending line of region of interest for
% lineout
name = 'Range of Lineout'; 
a = inputdlg('Enter start of lineout:', name);
box_region_start = a{1};
b = inputdlg('Enter end of lineout:', name);
box_region_end = b{1};
box_region = str2double(box_region_start):str2double(box_region_end);
setappdata(0, 'box_region', box_region);
m3_cmt = ['lineout of range ' box_region_start ':' box_region_end];
setappdata(0, 'cmt_str', m3_cmt);
m3 = msgbox(m3_cmt, 'Range of Lineout');
uiwait(m3);

% construct the output and saved variables
outputFileName = [outputdir date_str(3:end) '_' dataset_str '_' camera.name];
save_struc_str = camera.name;
purpose = 'lineouts';
processtype = 1;

if exist('purpose', 'var')
    outputFileName = [outputFileName '_' purpose];
    save_struc_str = [save_struc_str '_' purpose];
end
if processtype == 1
    outputFileName = [outputFileName '_' num2str(box_region(1)) '_' ...
        num2str(box_region(end))];
    save_struc_str = [save_struc_str '_' num2str(box_region(1)) '_' ...
        num2str(box_region(end))];
end
if linearize
    outputFileName = [outputFileName '_linearized'];
    save_struc_str = [save_struc_str '_linearized'];
end

prefix = getappdata(0, 'prefix');
num_stacks = getappdata(0, 'num_stacks');
image_struc = getappdata(0, 'image_struc');
num_images = getappdata(0, 'num_images');
stack_text = getappdata(0, 'stack_text');
func_name = getappdata(0, 'func_name');
bend_struc = getappdata(0, 'bend_struc');

% process and visualization
background_checked = 0;
mBox = msgbox('Starting lineout process. One moment, please...');
% go over scan steps, if no scan, only one loop iteration
for i = 1:num_stacks
    if camera.energy_camera 
        if (isfield(bend_struc, 'variable_bend') && bend_struc.variable_bend)
            camera.dipole_bend = bend_struc.dipole_multiplier_values(i);
            camera.zero_Gev_px = bend_struc.zero_Gev_px_vector(i);                        
        end
        if camera.dipole_bend ~= 1
            stack_text{i} = ['Dipole=' num2str(camera.dipole_bend,2) ', ' ...
                stack_text{i}];
            setappdata(0, 'stack_text', stack_text);
        end
    end
    % go through images in each scan step
    for j = 1:num_images
        % REMOVED: disp(['starting lineout of ' num2str(j)]);
        curr_image = (i - 1) * num_images + j;
        % setappdata(0, 'curr_image', curr_image');
        % curr_image = getappdata(0, 'curr_image');
        load_noiseless_images_15_edited_saveLineouts;
        % this_image = getappdata(0, 'this_image');
        lineout(i,j,:) = sum(this_image(:, box_region), 2);
        assembled_UID(i,j) = image_UID;
    end
end
% close dialog box if user did not already close it
try
    close(mBox);
catch
    % message box was already closed by user
end
cmt_str = getappdata(0, 'cmt_str');
if save_data
    process_struc.camera = camera.name;
    process_struc.linearized = linearize;
    process_struc.readme_comment = cmt_str;
    % process_struc.remove_xrays = remove_xrays;
    process_struc.UID = assembled_UID;
    process_struc.date = date;
    if exist('noint_shot','var')
        process_struc.noint_shot = noint_shot;
    end
    if exist('draw_ROI','var')
        process_struc.ROI = draw_ROI;
    end
    
    % save lineout specific operations to process_struc
    process_struc.lineout = lineout;
    process_struc.box_region = box_region;
            
    if camera.energy_camera
        process_struc.energy_vector = energy_calib_vector;
        if linearize
            process_struc.linear_energy_vector = linear_energy_scale;
        end
    end

    source_dir = getappdata(0, 'source_dir');
    server_str = getappdata(0, 'server_str');
    expt_str = getappdata(0, 'expt_str');
    date_str = getappdata(0, 'date_str');
    dataset_str = getappdata(0, 'dataset_str');
    data_path = [source_dir server_str expt_str '/' date_str(1:4) '/' ...
        date_str '/' expt_str '_' dataset_str '/' expt_str '_' dataset_str ...
        '.mat'];
    % data_path = getappdata(0, 'data_path');
    data.processed.vectors.(genvarname(save_struc_str)) = process_struc;
    setappdata(0, 'save_struc_str', save_struc_str);
    setappdata(0, 'lineout', lineout);
    E200_save_remote(data, save_override)
    % msgbox('ended E200 save remote', 'E200 save remote');
    setappdata(0, 'data', data);
    disp('Data saved!')
end